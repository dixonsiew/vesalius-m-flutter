import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_image.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/package_image.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/confirm_reschedule_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/reschedule_appointment_2_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/reschedule_appointment_3_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/reschedule_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/upcoming_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/home_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/main_layout_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';
import 'package:vesalius_m_flutter/ui/main_layout.dart';

class ConfirmReschedule extends StatelessWidget {

  final PatientAppointment patientAppointment;

  // late final TextEditingController txtreason;
  final ConfirmRescheduleCtrl ctrl = Get.put(ConfirmRescheduleCtrl());
  final RescheduleAppointmentCtrl rescheduleAppointmentCtrl = Get.put(RescheduleAppointmentCtrl());
  final RescheduleAppointment2Ctrl rescheduleAppointment2Ctrl = Get.put(RescheduleAppointment2Ctrl());
  final RescheduleAppointment3Ctrl rescheduleAppointment3Ctrl = Get.put(RescheduleAppointment3Ctrl());
  final MainLayoutCtrl mainLayoutCtrl = Get.put(MainLayoutCtrl());
  final UpcomingAppointmentCtrl upcomingAppointmentCtrl = Get.put(UpcomingAppointmentCtrl());
  final HomeCtrl homeCtrl = Get.put(HomeCtrl());

  ConfirmReschedule({
    super.key,
    required this.patientAppointment,
  });

  String getTime(String s) {
    final ts = '2023-01-01T$s:00';
    return formatDate(DateTime.parse(ts), [h, ':', nn, ' ', am]).toUpperCase();
  }

  String getDate(String s) {
    String x = s.replaceAll('-', ' ');
    return x;
    // int i = x.lastIndexOf(' ');
    // return x.substring(0, i);
  }

  String get apptTime {
    final o = patientAppointment;
    String s = '${getDate(o.apptDate)}, ${getTime(o.apptStartTime)}';
    if (o.apptSlotType == 'Session') {
      String a = getTime(o.sessionStartTime!);
      String b = getTime(o.sessionEndTime!);
      s = '${getDate(o.apptDate)}, ${o.apptSessionType} ($a-$b)';
    }

    return s;
  }

  String get apptNewTime {
    return rescheduleAppointment2Ctrl.appointmentSession == null ? rescheduleAppointment3Ctrl.slot.toString() : dateTimeSession;
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
              'Appointment Rescheduled',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'You have rescheduled your appointment originally on\n$apptTime\nto\n',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor6,
                    ),
                  ),
                  TextSpan(
                    text: apptNewTime,
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  TextSpan(
                    text: '.',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor2,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Kindly register upon arrival. Your registration is based on first come first serve',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Done',
              onPressed: () {
                Get.back();
                Get.until((route) => Get.currentRoute == MainLayout.routeName);
              },
            ),
          ],
        ),
      ),
    ));
  }

  Future<String> showReason() async {
    return await Get.dialog(AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Are you sure want to reschedule this appointment?',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            /* const SizedBox(height: 16.0),
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
                    borderSide: BorderSide(color: const Color(0xFFDBDBDB).withValues(alpha: 0.7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: const Color(0xFFDBDBDB).withValues(alpha: 0.7)),
                  ),
                ),
              ),
            ), */
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
                    onPressed: () => Get.back(result: 'No reason provided'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )) ?? '';
  }

  void onConfirm() async {
    try {
      String s = await showReason();
      if (s.isEmpty) {
        return;
      }

      ctrl.setIsLoading(true);
      final branchDetails = DataManager.instance.branchDetails!;
      String? slotNumber = rescheduleAppointment2Ctrl.appointmentSessionList.isEmpty ? rescheduleAppointment3Ctrl.slot?.slotNumber : rescheduleAppointment2Ctrl.appointmentSession?.slot?.slotNumber;
      String date = formatDate(rescheduleAppointmentCtrl.date!, [yyyy, '-', mm, '-', dd]);
      String sessionType = 'Normal';
      if (rescheduleAppointment2Ctrl.appointmentSession != null) {
        sessionType = rescheduleAppointment2Ctrl.appointmentSession!.session;
      }

      final m = {
        'appointmentNumber': patientAppointment.apptNo,
        'reason': s,
        'remark': patientAppointment.apptPackagePurchaseNo != null ? patientAppointment.apptPackagePurchaseNo! : '',
        'slotNumber': slotNumber,
        'apptDate': date,
        'apptSessionType': sessionType
      };
      await VesaliusService.postVesaliusChangeAppointment(branchDetails.branch!.branchId!, patientAppointment.apptPatientPrn ?? branchDetails.prn!, m);
      if (mainLayoutCtrl.index == 1) {
        await upcomingAppointmentCtrl.load();
        await upcomingAppointmentCtrl.loadSoonest();
      }

      else {
        await upcomingAppointmentCtrl.load();
        await upcomingAppointmentCtrl.loadSoonest();
        mainLayoutCtrl.setIndex(1);
        mainLayoutCtrl.pageController.jumpToPage(1);
      }

      ctrl.setIsLoading(false);
      showSuccess();
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleSubmitError(error, 'Unable to reschedule appointment at the moment. Please check your internet connection or try again later.', onConfirm);
    }

    catch (_) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', 'Unable to reschedule appointment at the moment. Please check your internet connection or try again later.', 'Dismiss');
    }
  }

  void onSubmit() async {
    try {
      ctrl.setIsLoading(true);
      final branchDetails = DataManager.instance.branchDetails!;
      String date = formatDate(rescheduleAppointmentCtrl.date!, [yyyy, '-', mm, '-', dd]);
      String dt = date;
      String sessionType = 'Normal';
      if (rescheduleAppointment2Ctrl.appointmentSession != null) {
        sessionType = rescheduleAppointment2Ctrl.appointmentSession!.session;
        String ts = '2023-01-01T${rescheduleAppointment2Ctrl.appointmentSession!.startTime}:00';
        String time = formatDate(DateTime.parse(ts), [HH, ':', nn]);
        dt = '$date $time';
      }

      else {
        String time = formatDate(rescheduleAppointment2Ctrl.date!, [HH, ':', nn]);
        dt = '$date $time';
      }

      final m = {
        'apptDate': dt,
        'apptSessionType': sessionType
      };
      bool b = await VesaliusService.postCheckAppointment(branchDetails.branch!.branchId!, patientAppointment.apptPatientPrn ?? branchDetails.prn!, m);
      ctrl.setIsLoading(false);
      if (b) {
        bool r = await showConfirmSubmitAppointment();
        if (r) {
          onConfirm();
        }
      }

      else {
        onConfirm();
      }
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleSubmitError(error, 'Unable to reschedule appointment at the moment. Please check your internet connection or try again later.', onSubmit);
    }

    catch (_) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', 'Unable to reschedule appointment at the moment. Please check your internet connection or try again later.', 'Dismiss');
    }
  }

  List<Widget> buildDoctorContent() {
    List<DoctorSpecialities>? specialtyList = rescheduleAppointmentCtrl.doctorInfo?.doctorSpecialities ?? [];
    List<DoctorClinicLocation>? locationList = rescheduleAppointmentCtrl.doctorInfo?.doctorClinicLocation ?? [];

    List<Widget> ls = [
      Text(
        '${rescheduleAppointmentCtrl.doctorInfo?.name}'.trim(),
        style: kTextStyle1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: kTextColor1,
        ),
      ),
      const SizedBox(height: 10.0),
    ];

    for (int i = 0; i < specialtyList.length; i++) {
      Widget w = Text(
        specialtyList[i].toString(),
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: kTextColor4,
        ),
      );
      ls.addAll([w, const SizedBox(height: 5.0)]);
    }

    if (locationList.isNotEmpty) {
      String? building = locationList.first.building;
      String loc = locationList.first.location ?? '';
      Widget l = Row(
        children: [
          Image.asset(
            'images/icon/location5.png',
            width: 16.0,
            height: 16.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 8.0),
          if (building == null) ...[
            Text(
              locationList.first.toString(),
              style: kTextStyle1.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
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
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: building == 'Peel Wing' ? kPeelWingColor : kOthersColor,
                  ),
                ),
                Text(
                  loc,
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: kTextColor4,
                  ),
                ),
              ],
            ),
          ],
        ],
      );
      ls.addAll([const SizedBox(height: 7.0), l]);
    }

    else {
      ls.removeLast();
    }

    return ls;
  }

  String get dateTimeNormal {
    return '${rescheduleAppointmentCtrl.getDate()}, ${rescheduleAppointment2Ctrl.time}';
  }

  String get dateTimeSession {
    return '${rescheduleAppointmentCtrl.getDate()}, ${rescheduleAppointment2Ctrl.appointmentSession.toString()}';
  }

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 250.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (patientAppointment.apptPackagePurchaseNo != null) ...[
                PackageContent(data: patientAppointment),
              ] else ...[
                Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 19.0, bottom: 21.0),
                  color: kBgColor1,
                  child: Row(
                    children: [
                      ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(36.0), // Image radius
                          child: DoctorImage(img: rescheduleAppointmentCtrl.doctorInfo?.image),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: buildDoctorContent(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /* Text(
                            'Patient',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor2,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: const Color(0xFFC7CCD6)),
                              boxShadow: [
                                BoxShadow(
                                  color: kBgColor2.withValues(alpha: 0.1),
                                  offset: const Offset(0.0, 4.0),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: Text(
                              'Raja Abu bin Ahmad',
                              style: kTextStyle1.copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24.0), */
                          if (patientAppointment.apptPackagePurchaseNo == null) ...[
                            Text(
                              'Visit Type',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor2,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: const Color(0xFFC7CCD6)),
                                boxShadow: [
                                  BoxShadow(
                                    color: kBgColor2.withValues(alpha: 0.1),
                                    offset: const Offset(0.0, 4.0),
                                    blurRadius: 4.0,
                                  ),
                                ],
                              ),
                              child: Text(
                                patientAppointment.apptCaseType == 'NC' ? 'New Case' : 'Follow Up',
                                style: kTextStyle1.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: kTextColor1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24.0),
                          ],
                          Text(
                            'New Appointment Date & Time',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor2,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: const Color(0xFFC7CCD6)),
                              boxShadow: [
                                BoxShadow(
                                  color: kBgColor2.withValues(alpha: 0.1),
                                  offset: const Offset(0.0, 4.0),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'images/icon/clock3.png',
                                  width: 16.0,
                                  height: 16.0,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 11.0),
                                Expanded(
                                  child: Text(
                                    rescheduleAppointment2Ctrl.appointmentSession == null ? rescheduleAppointment3Ctrl.slot.toString() : dateTimeSession,
                                    style: kTextStyle1.copyWith(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
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
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    '**Please ensure all the appointment details are correct before you proceed',
                    style: kTextStyle1.copyWith(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: kTextColor4,
                      fontStyle: FontStyle.italic
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: kBgColor2.withValues(alpha: 0.1),
                        offset: const Offset(0.0, 4.0),
                        blurRadius: 4.0,
                      ),
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
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          'Please note that appointment times may vary, as the doctor may be addressing the urgent cases. Your patience and understanding are valued.',
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
                const SizedBox(height: 16.0),
                AppElevatedButton(
                  text: 'Confirm Reschedule',
                  onPressed: onSubmit,
                ),
                const SizedBox(height: 16.0),
                AppOutlinedButton(
                  text: 'Cancel',
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Confirm Reschedule',
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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
    );
  }
}

class PackageContent extends StatelessWidget {

  final PatientAppointment data;

  const PackageContent({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 19.0, bottom: 21.0),
      color: kBgColor1,
      child: Row(
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
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  data.apptPackageName ?? '-',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}