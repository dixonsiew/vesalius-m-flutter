import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_image.dart';
import 'package:vesalius_m_flutter/components/package_image.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/upcoming_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';

import 'appointment_detail.dart';
import 'reschedule_appointment.dart';

class UpcomingAppointment extends StatefulWidget {

  const UpcomingAppointment({super.key});

  @override
  State<UpcomingAppointment> createState() => _UpcomingAppointmentState();
}

class _UpcomingAppointmentState extends State<UpcomingAppointment> with AutomaticKeepAliveClientMixin<UpcomingAppointment> {

  late final TextEditingController txtreason;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final UpcomingAppointmentCtrl ctrl = Get.put(UpcomingAppointmentCtrl());

  @override
  void initState() {
    super.initState();
    txtreason = TextEditingController();
    load();
  }

  @override
  void dispose() {
    txtreason.dispose();
    super.dispose();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      await AuthManager.instance.load();
      await ctrl.load();
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

  void onSubmitCancel(PatientAppointment o) async {
    try {
      String s = await showCancel();
      if (s.isEmpty) {
        return;
      }

      ctrl.setIsLoading(true);
      final branchDetails = DataManager.instance.branchDetails!;
      final m = {
        'appointmentNumber': o.apptNo,
        'reason': s,
        'remark': o.apptPackagePurchaseNo != null ? o.apptPackagePurchaseNo! : ''
      };
      await VesaliusService.postVesaliusCancelAppointment(branchDetails.branch!.branchId!, o.apptPatientPrn ?? branchDetails.prn!, m);
      await ctrl.loadSoonest();
      ctrl.remove(o.apptNo);
      ctrl.setIsLoading(false);
      showSuccess();
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleSubmitError(error, 'Unable to cancel appointment at the moment. Please check your internet connection or try again later.', () => onSubmitCancel(o));
    }

    catch (_) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', 'Unable to cancel appointment at the moment. Please check your internet connection or try again later.', 'Dismiss');
    }
  }

  void showSuccess() {
    Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/icon/tick.png',
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Appointment Cancel Successfully',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Your appointment has been cancelled.',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kPrimaryColor3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Done',
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    ));
  }

  Future<String> showCancel() async {
    return await Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Are you sure want to cancel this appointment?',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              // padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 17.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: TextField(
                controller: txtreason,
                cursorColor: kTextColor1,
                style: const TextStyle(
                  fontFamily: kBodyFont,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15.0),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Share your reason with us',
                  hintStyle: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor5,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: kColor1.withValues(alpha: 0.7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: kColor1.withValues(alpha: 0.7)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: AppOutlinedButton(
                    text: 'Cancel',
                    onPressed: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 18.0),
                Expanded(
                  child: AppElevatedButton(
                    text: 'Sure',
                    onPressed: () => Get.back(result: txtreason.text),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )) ?? '';
  }

  Future<void> onRefresh() async {
    load();
  }

  Widget buildContent() {
    if (!ctrl.isLoading && ctrl.list.isEmpty) {
      return NoAppointment(onRefresh: onRefresh);
    }
    
    return Scrollbar(
      child: Obx(() =>
        Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: ctrl.list.length,
            itemBuilder: (context, i) {
              final o = ctrl.list[i];
              return AppointmentItem(
                key: ValueKey(o.apptNo),
                data: o,
                onCancel: (PatientAppointment o) {
                  onSubmitCancel(o);
                },
                onReschedule: (PatientAppointment o) {
                  Get.to(() => RescheduleAppointment(
                    patientAppointment: o,
                  ));
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // Widget buildContent0() {
  //   if (isLoading) {
  //     return Container();
  //   }

  //   if (list.isEmpty) {
  //     return const NoAppointment();
  //   }

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Container(
  //         color: kBgColor1,
  //         height: MediaQuery.of(context).size.height - 320,
  //         child: Scrollbar(
  //           child: buildList(),
  //         ),
  //       ),
  //       Container(
  //         height: 80.0,
  //         margin: const EdgeInsets.only(left: 25.0, right: 25.0),
  //         padding: const EdgeInsets.all(10.0),
  //         decoration: BoxDecoration(
  //           color: kSecondaryColor2,
  //           borderRadius: BorderRadius.circular(5.0),
  //           boxShadow: const [
  //             BoxShadow(
  //               color: Color.fromRGBO(229, 229, 229, 0.1),
  //               offset: Offset(0.0, 4.0),
  //               blurRadius: 4.0,
  //             ),
  //           ],
  //         ),
  //         child: Row(
  //           children: [
  //             Image.asset(
  //               'images/icon/info1.png',
  //               width: 16.0,
  //               height: 16.0,
  //               fit: BoxFit.cover,
  //             ),
  //             const SizedBox(width: 9.0),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'Need to reschedule / cancel appointment?',
  //                     style: kTextStyle1.copyWith(
  //                       fontWeight: FontWeight.w400,
  //                     ),
  //                   ),
  //                   Text(
  //                     'Call Customer Service.',
  //                     style: kTextStyle1.copyWith(
  //                       decoration: TextDecoration.underline,
  //                       decorationColor: kColor20,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() =>
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
    );
  }
  
  @override
  bool get wantKeepAlive => false;
}

class AppointmentItem extends StatelessWidget {

  final PatientAppointment data;
  final void Function(PatientAppointment) onCancel;
  final void Function(PatientAppointment) onReschedule;

  const AppointmentItem({
    super.key,
    required this.data,
    required this.onCancel,
    required this.onReschedule,
  });

  String getTime(String s) {
    final ts = '2023-01-01T$s:00';
    return formatDate(DateTime.parse(ts), [h, ':', nn, ' ', am]).toUpperCase();
  }

  String getDate(String s) {
    return s.replaceAll('-', ' ');
  }

  String get apptTime {
    String s = '${getDate(data.apptDate)}, ${getTime(data.apptStartTime)}';
    if (data.apptSlotType == 'Session') {
      String a = getTime(data.sessionStartTime!);
      String b = getTime(data.sessionEndTime!);
      s = '${getDate(data.apptDate)}, ${data.apptSessionType} ($a-$b)';
    }

    return s;
  }

  List<Widget> buildDoctorContent() {
    List<DoctorSpecialities> specialtyList = data.doctorSpecialities;
    List<DoctorClinicLocation> locationList = data.doctorClinicLocation;

    List<Widget> ls = [
      Text(
        '${data.name}'.trim().capitalize ?? '',
        style: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: kTextColor4,
        ),
      ),
      const SizedBox(height: 8.0),
    ];

    for (int i = 0; i < specialtyList.length; i++) {
      Widget w = Text(
        specialtyList[i].toString(),
        style: kTextStyle1.copyWith(
          fontSize: 10.0,
          fontWeight: FontWeight.w400,
          color: kTextColor4,
        ),
      );
      ls.addAll([w, const SizedBox(height: 8.0)]);
    }

    if (locationList.isNotEmpty) {
      String? building = locationList.first.building;
      String loc = locationList.first.location ?? '';
      building = null;
      Widget l = Row(
        children: [
          Image.asset(
            'images/icon/location1.png',
            width: 10.0,
            height: 10.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 6.0),
          if (building == null) ...[
            Text(
              loc,
              style: kTextStyle1.copyWith(
                fontSize: 10.0,
                fontWeight: FontWeight.w400,
                color: kTextColor4,
              ),
            ),
          ] else ...[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  building,
                  style: kTextStyle1.copyWith(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    color: building == 'Peel Wing' ? kPeelWingColor : kOthersColor,
                  ),
                ),
                Text(
                  loc,
                  style: kTextStyle1.copyWith(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor4,
                  ),
                ),
              ],
            ),
          ],
        ],
      );
      ls.add(l);
    }

    else {
      ls.removeLast();
    }

    return ls;
  }

  Widget buildPackageItem() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: PackageImage(
            img: data.apptPackageImage,
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
                data.apptPackagePurchaseNo ?? '-',
                style: kTextStyle1.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: kTextColor4,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                data.apptPackageName ?? '-',
                style: kTextStyle1.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: kTextColor4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDoctorItem() {
    List<DoctorContact> contactList = data.doctorContact;
    final List<DoctorContact> lc = contactList.where((x) => x.contactType == 'Contact No').toList();
    final contact = lc.isEmpty ? null : lc.first;

    return Row(
      children: [
        ClipOval(
          child: SizedBox.fromSize(
            size: const Size.fromRadius(32.0),
            child: DoctorImage(img: data.image),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildDoctorContent(),
          ),
        ),
        if (contact != null) ...[
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: IconButton(
              onPressed: () {
                makePhoneCall(contact);
              },
              splashRadius: 22.0,
              icon: Container(
                width: 22.0,
                height: 22.0,
                decoration: const BoxDecoration(
                  color: kSecondaryColor3,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.call,
                    color: kPrimaryColor2,
                    size: 12.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: kColor1.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: kBgColor2.withValues(alpha: 0.4),
            blurRadius: 7.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: () {
            Get.to(() => AppointmentDetail(patientAppointment: data));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: kSecondaryColor2,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'images/icon/clock5.png',
                              width: 10.0,
                              height: 10.0,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 4.0),
                            Flexible(
                              child: Text(
                                apptTime,
                                //'12 Dec, 3:30 PM',
                                style: kTextStyle1.copyWith(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                  color: kTextColor7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: kSecondaryColor2,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'images/icon/user.png',
                              width: 10.0,
                              height: 10.0,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 4.0),
                            Flexible(
                              child: Text(
                                data.apptPatientName ?? '',
                                style: kTextStyle1.copyWith(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                  color: kTextColor7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                if (data.apptPackagePurchaseNo != null) ...[
                  buildPackageItem(),
                ] else ...[
                  buildDoctorItem(),
                ],
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // if (data.apptPackagePurchaseNo == null) ...[
                      //   Expanded(
                      //     child: AppOutlinedButtonSm(
                      //       onPressed: () async {
                      //         onCancel.call(data);
                      //       },
                      //       text: 'Cancel',
                      //     ),
                      //   ),
                      //   const SizedBox(width: 11.0),
                      // ],
                      Expanded(
                        child: AppOutlinedButtonSm(
                          onPressed: () async {
                            onCancel.call(data);
                          },
                          text: 'Cancel',
                        ),
                      ),
                      const SizedBox(width: 11.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            onReschedule.call(data);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor2,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 32.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                          ),
                          child: Text(
                            'Reschedule',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                            ),
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
      ),
    );
  }
}

class NoAppointment extends StatelessWidget {

  final Future<void> Function() onRefresh;

  const NoAppointment({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/imgs/medical-record.png',
            width: 73.61,
            height: 96.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              'You do not have any upcoming appointment at the moment.',
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