import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/package_image.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/new_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/select_patient_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/profile/my_package_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/family_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/models/user_package_purchase_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/services/public_service.dart';
import 'package:vesalius_m_flutter/services/user_package_service.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';
import 'package:vesalius_m_flutter/ui/appointment/new_appointment_2.dart';
import 'package:vesalius_m_flutter/ui/appointment/reschedule_appointment.dart';
import 'package:vesalius_m_flutter/ui/appointment/select_patient.dart';
import 'package:vesalius_m_flutter/ui/health-package/ipay_submit.dart';

import 'package_detail.dart';
//import 'package:vesalius_m_flutter/ui/profile/package_details.dart';

class MyPackage extends StatefulWidget {

  const MyPackage({super.key});

  @override
  State<MyPackage> createState() => _MyPackageState();
}

class _MyPackageState extends State<MyPackage> {

  late ScrollController scr;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final MyPackageCtrl ctrl = Get.put(MyPackageCtrl());
  final SelectPatientCtrl selectPatientCtrl = Get.put(SelectPatientCtrl());
  final NewAppointmentCtrl newAppointmentCtrl = Get.put(NewAppointmentCtrl());

  @override
  void initState() {
    super.initState();
    scr = ScrollController();
    scr.addListener(scrollListener);
    load();
  }

  @override
  void dispose() {
    scr.removeListener(scrollListener);
    scr.dispose();
    super.dispose();
  }

  void scrollListener() {
    final nextPageTrigger = 0.8 * scr.position.maxScrollExtent;
    if (scr.position.pixels > nextPageTrigger) {
      loadMore();
    }
  }

  void load() async {
    try {
      ctrl.init();
      ctrl.setIsLoading(true);
      List<UserPackagePurchase> lx = await UserPackageService.getAllPackages(ctrl.page, kPageSize);
      ctrl.setList(lx);
      ctrl.setIsLoading(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, load);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  void loadMore() async {
    int p = ctrl.page + 1;
    try {
      if (ctrl.isLoadingMore) return;
      ctrl.setIsLoadingMore(true);
      List<UserPackagePurchase> lx = await UserPackageService.getAllPackages(p, kPageSize);
      if (lx.isEmpty) {
        ctrl.setIsLoadingMore(false);
        return;
      }

      ctrl.setPage(p);
      ctrl.setList(lx);
      ctrl.setIsLoadingMore(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoadingMore(false);
      handleLoadError(error, loadMore);
    }

    catch (error) {
      ctrl.setIsLoadingMore(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  void onRescheduleAppointment(UserPackagePurchase data) async {
    try {
      ctrl.setIsLoading(true);
      final branchDetails = DataManager.instance.branchDetails!;
      List<PatientAppointment> lx = await VesaliusService.getPatientVesaliusFutureAppointments(branchDetails.branch!.branchId!, branchDetails.prn!);
      final pa = lx.firstWhereOrNull((x) => x.apptPackagePurchaseNo == data.packagePurchaseNo);
      ctrl.setIsLoading(false);
      if (pa != null) {
        Get.to(() => RescheduleAppointment(patientAppointment: pa));
      }
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, () => onMakeAppointment(data));
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  void onMakeAppointment(UserPackagePurchase data) async {
    try {
      if (data.packageStatus == 'Booked') {
        onRescheduleAppointment(data);
        return;
      }

      selectPatientCtrl.init();
      selectPatientCtrl.setIsFromPackage(true);
      selectPatientCtrl.setUserPackagePurchase(data);
      ctrl.setIsLoading(true);
      UserBranch? branchDetails = DataManager.instance.branchDetails;
      DoctorInfo? o = await PublicVesaliusService.getDoctorByMCR(branchDetails!.branch!.branchId!, data.doctorMcr);
      if (o == null) {
        ctrl.setIsLoading(false);
        showCustomDialog('Error', 'Doctor Not Found', 'Dismiss');
        return;
      }

      await AuthManager.instance.load();
      List<Family> lx = await MyFamilyService.getAllFamilies(1, kPageSize, true, true);
      ctrl.setIsLoading(false);
      selectPatientCtrl.setFamily(null);

      if (lx.length == 1) {
        selectPatientCtrl.setFamily(lx.first);
      }

      if (lx.length < 2) {
        selectPatientCtrl.setSelectPatient(false);
        newAppointmentCtrl.setXCaseType('New Case');
        newAppointmentCtrl.setCaseType(newAppointmentCtrl.xcaseType);
        Get.to(() => NewAppointment2(doctorInfo: o));
      }

      else {
        selectPatientCtrl.setSelectPatient(true);
        Get.to(() => SelectPatient(doctorInfo: o, list: lx));
      }
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, () => onMakeAppointment(data));
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  Widget buildContent() {
    if (!ctrl.isLoading && ctrl.list.isEmpty) {
      return NoPackage(onRefresh: onRefresh);
    }

    return Scrollbar(
      controller: scr,
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Obx(() => 
          ListView.builder(
            controller: scr,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: ctrl.list.length + 1,
            itemBuilder: (context, i) {
              if (i == ctrl.list.length) {
                return Obx(() => ctrl.isLoadingMore ? const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: AppLoadMoreIndicator(),
                ) : Container());
              }
              
              final o = ctrl.list[i];
              return PackageItem(
                key: ValueKey(o.packagePurchaseNo),
                data: o,
                onMakeAppointment: onMakeAppointment,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'My Packages',
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: RefreshIndicator(
              key: refreshIndicatorKey,
              onRefresh: onRefresh,
              color: kPrimaryColor,
              child: buildContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class PackageItem extends StatelessWidget {

  final UserPackagePurchase data;
  final void Function(UserPackagePurchase) onMakeAppointment;

  const PackageItem({
    super.key,
    required this.data,
    required this.onMakeAppointment,
  });

  bool get showButton {
    bool a = data.packageAllowAppt == 'Y';
    bool b = data.packageStatus == 'Purchased' || data.packageStatus == 'Cancelled';
    if (data.expDateTime != null) {
      if (data.expDateTime!.isBefore(DateTime.now()) || data.dateTime1 == formatDate(DateTime.now(), [dd, ' ', M, ' ', yyyy])) {
        b = false;
      }
    }
    
    return b && a;
  }

  bool get showButtonPay {
    bool b = data.packageStatus == 'Awaiting Payment' && data.paymentGateway == 'iPay88';
    return b;
  }

  // bool get showButton000 {
  //   bool b = data.packageStatus == 'Purchased' || data.packageStatus == 'Cancelled';
  //   if (data.expDateTime != null) {
  //     if (data.expDateTime!.isBefore(DateTime.now()) || data.dateTime1 == formatDate(DateTime.now(), [dd, ' ', M, ' ', yyyy])) {
  //       b = false;
  //     }
  //   }

  //   return b;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEBEBEB).withValues(alpha: 0.49),
            blurRadius: 7.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: () {
            Get.to(() => PackageDetail(data: data));
          },
          borderRadius: BorderRadius.circular(5.0),
          child: Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 16.0, bottom: showButton || showButtonPay ? 4.0 : 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: PackageImage(
                    img: data.packageImage,
                    width: 90.0,
                    height: 90.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.packagePurchaseNo,
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        data.packageName,
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Valid until ${data.dateTime1}',
                        style: kTextStyle1.copyWith(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF7C7C7C),
                        ),
                      ),
                      if (showButton == false) ...[
                        const SizedBox(height: 10.0),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PacakgeStatus(status: data.packageStatus),
                          if (showButton) ...[
                            Align(
                              alignment: Alignment.bottomRight,
                              child: OutlinedButton(
                                onPressed: () => onMakeAppointment.call(data),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: kPrimaryColor,
                                  backgroundColor: Colors.white,
                                  minimumSize: const Size(93.0, 26.0),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                  side: const BorderSide(color: kPrimaryColor),
                                ),
                                child: Text(
                                  data.packageStatus == 'Booked' ? 'Reschedule' : 'Book Now',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ] else if (showButtonPay) ...[
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(() => IpaySubmit(data: data.paymentRequestNo, repay: true));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(93.0, 26.0),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                ),
                                child: Text(
                                  'Pay Now',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PacakgeStatus extends StatelessWidget {

  final String status;

  const PacakgeStatus({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    if (status == 'Redeemed' || status == 'Expired') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: const Color(0xFFDADADA),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          status,
          style: kTextStyle1.copyWith(
            fontSize: 10.0,
            fontWeight: FontWeight.w600,
            color: status == 'Expired' ? Colors.red : kTextColor4,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE4FFED),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        status,
        style: kTextStyle1.copyWith(
          fontSize: 10.0,
          fontWeight: FontWeight.w600,
          color: kPrimaryColor,
        ),
      ),
    );
  }
}

class NoPackage extends StatelessWidget {

  final Future<void> Function() onRefresh;

  const NoPackage({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/imgs/empty-cart.png',
            width: 96.0,
            height: 96.0,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              'Your purchase history appears to be blank at the moment. Feel free to browse our products and make your first purchase.',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(0, 0, 0, 0.2),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(
              Icons.refresh,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}