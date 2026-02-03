import 'package:barcode_widget/barcode_widget.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/new_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/select_patient_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/profile/package_detail_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/family_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/models/user_package_purchase_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/services/public_service.dart';
import 'package:vesalius_m_flutter/ui/appointment/new_appointment_2.dart';
import 'package:vesalius_m_flutter/ui/appointment/select_patient.dart';
import 'package:vesalius_m_flutter/ui/health-package/ipay_submit.dart';

class PackageDetail extends StatefulWidget {

  final UserPackagePurchase data;

  const PackageDetail({
    super.key,
    required this.data,
  });

  @override
  State<PackageDetail> createState() => _PackageDetailState();
}

class _PackageDetailState extends State<PackageDetail> {

  ScrollController scr = ScrollController();
  final PackageDetailCtrl ctrl = Get.put(PackageDetailCtrl());
  final SelectPatientCtrl selectPatientCtrl = Get.put(SelectPatientCtrl());
  final NewAppointmentCtrl newAppointmentCtrl = Get.put(NewAppointmentCtrl());

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  bool get showButton {
    bool a = widget.data.packageAllowAppt == 'Y';
    bool b = widget.data.packageStatus == 'Purchased' || widget.data.packageStatus == 'Cancelled';
    if (widget.data.expDateTime != null) {
      if (widget.data.expDateTime!.isBefore(DateTime.now()) || widget.data.dateTime1 == formatDate(DateTime.now(), [dd, ' ', M, ' ', yyyy])) {
        b = false;
      }
    }

    return b && a;
  }

  bool get showButtonPay {
    bool b = widget.data.packageStatus == 'Awaiting Payment' && widget.data.paymentGateway == 'iPay88';
    return b;
  }

  String get statusDate {
    String s = '';
    final r = widget.data.packageStatus;
    if (r == 'Booked') {
      s = 'Appointment Date';
    }

    else if (r == 'Redeemed') {
      s = 'Redeemed On';
    }

    else if (r == 'Cancelled') {
      s = 'Cancelled On';
    }

    return s;
  }

  String get statusDateValue {
    String s = '';
    final r = widget.data.packageStatus;
    if (r == 'Booked') {
      s = widget.data.appointmentDateTimes;
    }

    else if (r == 'Redeemed') {
      s = widget.data.redeemedDateTimes;
    }

    else if (r == 'Cancelled') {
      s = widget.data.cancelledDateTimes;
    }

    return s;
  }

  void onMakeAppointment() async {
    try {
      selectPatientCtrl.init();
      selectPatientCtrl.setIsFromPackage(true);
      selectPatientCtrl.setUserPackagePurchase(widget.data);
      ctrl.setIsLoading(true);
      UserBranch? branchDetails = DataManager.instance.branchDetails;
      DoctorInfo? o = await PublicVesaliusService.getDoctorByMCR(branchDetails!.branch!.branchId!, widget.data.doctorMcr);
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
      handleLoadError(error, onMakeAppointment);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  void onMakePayment() {
    // Get.to(() => const IpaySubmitTest());
    Get.to(() => IpaySubmit(data: widget.data.paymentRequestNo, repay: true));
  }

  Widget buildDetail() {
    return Padding(
      padding: EdgeInsets.only(bottom: showButton || showButtonPay ? 80.0 : 0.0),
      child: Scrollbar(
        controller: scr,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            controller: scr,
            shrinkWrap: true,
            children: [
              const SizedBox(height: 24.0),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: BarcodeWidget(
                        barcode: Barcode.code128(), // Barcode type and settings
                        data: widget.data.packagePurchaseNo, // Content
                        width: double.infinity,
                        height: 68.0,
                        drawText: false,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        '#${widget.data.packagePurchaseNo}',
                        style: kTextStyle1.copyWith(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: kTextColor4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40.0),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Package Details',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        widget.data.packageName,
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Date of Purchase',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor6,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Valid until',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.data.purchasedDateTimes,
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.data.dateTime1,
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Status',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor6,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              statusDate,
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.data.packageStatus == 'Redeemed' || widget.data.packageStatus == 'Expired') ...[
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                    decoration: BoxDecoration(
                                      color: kColor3,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Text(
                                      widget.data.packageStatus,
                                      style: kTextStyle1.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: widget.data.packageStatus == 'Expired' ? Colors.red : kTextColor4,
                                      ),
                                    ),
                                  ),
                                  Container(),
                                ],
                              ),
                            ),
                          ] else ...[
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                    decoration: BoxDecoration(
                                      color: kColor23,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Text(
                                      widget.data.packageStatus,
                                      style: kTextStyle1.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ),
                                  Container(),
                                ],
                              ),
                            ),
                          ],
                          Expanded(
                            child: Text(
                              statusDateValue,
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor1,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    //   child: Text(
                    //     'Status',
                    //     style: kTextStyle1.copyWith(
                    //       fontSize: 14.0,
                    //       fontWeight: FontWeight.w400,
                    //       color: kTextColor6,
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 7.0),
                    // if (widget.data.packageStatus == 'Redeemed' || widget.data.packageStatus == 'Expired') ...[
                    //   Container(
                    //     margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    //     padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    //     decoration: BoxDecoration(
                    //       color: kColor3,
                    //       borderRadius: BorderRadius.circular(30.0),
                    //     ),
                    //     child: Text(
                    //       widget.data.packageStatus,
                    //       style: kTextStyle1.copyWith(
                    //         fontSize: 14.0,
                    //         fontWeight: FontWeight.w600,
                    //         color: widget.data.packageStatus == 'Expired' ? Colors.red : kTextColor4,
                    //       ),
                    //     ),
                    //   ),
                    // ] else ...[
                    //   Container(
                    //     margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    //     padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    //     decoration: BoxDecoration(
                    //       color: kColor23,
                    //       borderRadius: BorderRadius.circular(4.0),
                    //     ),
                    //     child: Text(
                    //       widget.data.packageStatus,
                    //       style: kTextStyle1.copyWith(
                    //         fontSize: 14.0,
                    //         fontWeight: FontWeight.w600,
                    //         color: kPrimaryColor,
                    //       ),
                    //     ),
                    //   ),
                    // ],
                    // const SizedBox(height: 24.0),
                    // if (widget.data.packageStatus == 'Booked' || widget.data.packageStatus == 'Redeemed' || widget.data.packageStatus == 'Cancelled') ...[
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    //     child: Text(
                    //       statusDate,
                    //       style: kTextStyle1.copyWith(
                    //         fontSize: 14.0,
                    //         fontWeight: FontWeight.w400,
                    //         color: kTextColor6,
                    //       ),
                    //     ),
                    //   ),
                    //   const SizedBox(height: 8.0),
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    //     child: Text(
                    //       statusDateValue,
                    //       style: kTextStyle1.copyWith(
                    //         fontSize: 14.0,
                    //         fontWeight: FontWeight.w600,
                    //         color: kTextColor1,
                    //       ),
                    //       textAlign: TextAlign.left,
                    //     ),
                    //   ),
                    //   const SizedBox(height: 24.0),
                    // ],

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: kColor13.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0.0, 4.0),
                            blurRadius: 4.0,
                            color: kBgColor2.withValues(alpha: 0.01),
                          )
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'images/icon/info1.png',
                            width: 16.0,
                            height: 16.0,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              'Please present this voucher to the counter during registration. Appointment is needed for all health screening.',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Payment Details',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Payment Reference ID',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor6,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Payment Mode',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.data.paymentRequestNo,
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.data.paymentGateway,
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Payment Date',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor6,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Payment Amount',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.data.purchasedDateTimes,
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.data.paymentAmountCollecteds,
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Payor Name',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        widget.data.billingFullname,
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent()  {
    return Stack(
      children: [
        buildDetail(),
        if (showButton) ...[
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: kBgColor1,
              child: AppElevatedButton(
                text: widget.data.packageStatus == 'Booked' ? 'Reschedule Appointment' : 'Make Appointment',
                onPressed: onMakeAppointment,
              ),
            ),
          ),
        ] else if (showButtonPay) ...[
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: kBgColor1,
              child: AppElevatedButton(
                text: 'Pay Now',
                onPressed: onMakePayment,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Package Details',
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: buildContent(),
          ),
        ),
      ),
    );
  }
}