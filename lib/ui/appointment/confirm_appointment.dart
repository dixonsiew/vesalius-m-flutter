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
import 'package:vesalius_m_flutter/controllers/appointment/confirm_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/new_appointment_2_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/new_appointment_3_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/new_appointment_4_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/new_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/select_patient_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/upcoming_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/home_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/main_layout_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/user_package_purchase_data.dart';
import 'package:vesalius_m_flutter/services/guest_service.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';
import 'package:vesalius_m_flutter/ui/appointment/new_appointment.dart';
import 'package:vesalius_m_flutter/ui/appointment/select_patient.dart';
import 'package:vesalius_m_flutter/ui/guest.dart';
import 'package:vesalius_m_flutter/ui/main_layout.dart';

import 'new_appointment_2.dart';

class ConfirmAppointment extends StatelessWidget {

  final DoctorInfo doctorInfo;
  final DoctorAppointmentStatus doctorAppointmentStatus;

  final ConfirmAppointmentCtrl ctrl = Get.put(ConfirmAppointmentCtrl());
  final NewAppointmentCtrl newAppointmentCtrl = Get.put(NewAppointmentCtrl());
  final NewAppointment2Ctrl newAppointment2Ctrl = Get.put(NewAppointment2Ctrl());
  final NewAppointment3Ctrl newAppointment3Ctrl = Get.put(NewAppointment3Ctrl());
  final NewAppointment4Ctrl newAppointment4Ctrl = Get.put(NewAppointment4Ctrl());
  final SelectPatientCtrl selectPatientCtrl = Get.put(SelectPatientCtrl());
  final MainLayoutCtrl mainLayoutCtrl = Get.put(MainLayoutCtrl());
  final UpcomingAppointmentCtrl upcomingAppointmentCtrl = Get.put(UpcomingAppointmentCtrl());
  final HomeCtrl homeCtrl = Get.put(HomeCtrl());

  ConfirmAppointment({
    super.key,
    required this.doctorInfo,
    required this.doctorAppointmentStatus,
  });

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
              'Request Submitted Successfully',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            // const SizedBox(height: 8.0),
            // RichText(
            //   text: TextSpan(
            //     children: [
            //       TextSpan(
            //         text: 'Your appointment has been booked for\n',
            //         style: kTextStyle1.copyWith(
            //           fontSize: 14.0,
            //           fontWeight: FontWeight.w400,
            //           color: kTextColor6,
            //         ),
            //       ),
            //       TextSpan(
            //         text: newAppointment3Ctrl.appointmentSession == null ? newAppointment4Ctrl.slot.toString() : dateTimeSession,
            //         style: kTextStyle1.copyWith(
            //           fontSize: 14.0,
            //           fontWeight: FontWeight.w400,
            //           color: kTextColor2,
            //         ),
            //       ),
            //       TextSpan(
            //         text: '.',
            //         style: kTextStyle1.copyWith(
            //           fontSize: 14.0,
            //           fontWeight: FontWeight.w400,
            //           color: kTextColor2,
            //         ),
            //       ),
            //     ],
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            const SizedBox(height: 8.0),
            Text(
              'We have received your appointment request and will process it within 3 working days. Please wait for our call/email for your booking confirmation.',
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
              onPressed: () {
                Get.back();
                if (AuthManager.instance.isLogin) {
                  Get.until((route) => Get.currentRoute == MainLayout.routeName);
                }

                else {
                  Get.until((route) => Get.currentRoute == Guest.routeName);
                }
              },
            ),
          ],
        ),
      ),
    ));
  }

  void onConfirm() async {
    try {
      ctrl.setIsLoading(true);
      String? slotNumber = newAppointment3Ctrl.appointmentSessionList.isEmpty ? newAppointment4Ctrl.slot?.slotNumber : newAppointment3Ctrl.appointmentSession?.slot?.slotNumber;
      String date = formatDate(newAppointment2Ctrl.date!, [yyyy, '-', mm, '-', dd]);
      String sessionType = 'Normal';
      if (newAppointment3Ctrl.appointmentSession != null) {
        sessionType = newAppointment3Ctrl.appointmentSession!.session;
      }

      final m = {
        'caseType': newAppointmentCtrl.caseTypeCode,
        'slotNumber': slotNumber,
        'doctorMcr': doctorInfo.mcr,
        'apptDate': date,
        'apptSessionType': sessionType,
        'remark': selectPatientCtrl.isFromPackage ? selectPatientCtrl.userPackagePurchase?.packagePurchaseNo : ''
      };
      if (AuthManager.instance.isLogin) {
        final branchDetails = DataManager.instance.branchDetails!;
        await VesaliusService.postVesaliusMakeAppointment(branchDetails.branch!.branchId!, selectPatientCtrl.family?.prn ?? branchDetails.prn!, m);
      }

      else {
        await GuestModeService.postVesaliusMakeAppointment(newAppointmentCtrl.patient?.prn ?? '', m);
      }

      if (AuthManager.instance.isLogin) {
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
      }

      ctrl.setIsLoading(false);
      showSuccess();
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleSubmitError(error, 'Unable to create new appointment at the moment. Please check your internet connection or try again later.', onConfirm);
    }

    catch (_) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', 'Unable to create new appointment at the moment. Please check your internet connection or try again later.', 'Dismiss');
    }
  }

  void onSubmit() async {
    try {
      ctrl.setIsLoading(true);
      String date = formatDate(newAppointment2Ctrl.date!, [yyyy, '-', mm, '-', dd]);
      String dt = date;
      String sessionType = 'Normal';
      if (newAppointment3Ctrl.appointmentSession != null) {
        sessionType = newAppointment3Ctrl.appointmentSession!.session;
        String ts = '2023-01-01T${newAppointment3Ctrl.appointmentSession!.startTime}:00';
        String time = formatDate(DateTime.parse(ts), [HH, ':', nn]);
        dt = '$date $time';
      }

      else {
        String time = formatDate(newAppointment3Ctrl.date!, [HH, ':', nn]);
        dt = '$date $time';
      }

      final m = {
        'apptDate': dt,
        'apptSessionType': sessionType
      };
      bool b = false;
      if (AuthManager.instance.isLogin) {
        final branchDetails = DataManager.instance.branchDetails!;
        b = await VesaliusService.postCheckAppointment(branchDetails.branch!.branchId!, selectPatientCtrl.family?.prn ?? branchDetails.prn!, m);
      }

      else {
        String prn = newAppointmentCtrl.patient?.prn ?? '';
        b = await GuestModeService.postCheckAppointment(prn, m);
      }
      
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
      handleSubmitError(error, 'Unable to create new appointment at the moment. Please check your internet connection or try again later.', onSubmit);
    }

    catch (_) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', 'Unable to create new appointment at the moment. Please check your internet connection or try again later.', 'Dismiss');
    }
  }

  List<Widget> buildDoctorContent() {
    List<DoctorSpecialities>? specialtyList = doctorInfo.doctorSpecialities;
    List<DoctorClinicLocation>? locationList = doctorInfo.doctorClinicLocation;

    List<Widget> ls = [
      Text(
        '${doctorInfo.name}'.trim(),
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
      building = null;
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
              loc,
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
    return '${newAppointment2Ctrl.getDate()}, ${newAppointment3Ctrl.time}';
  }

  String get dateTimeSession {
    return '${newAppointment2Ctrl.getDate()}, ${newAppointment3Ctrl.appointmentSession.toString()}';
  }

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 250.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (selectPatientCtrl.isFromPackage) ...[
                PackageContent(data: selectPatientCtrl.userPackagePurchase!),
              ] else ...[
                Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 19.0, bottom: 21.0),
                  color: kBgColor1,
                  child: Row(
                    children: [
                      ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(36.0), // Image radius
                          child: DoctorImage(img: doctorInfo.image),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Patient',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: kTextColor2,
                                ),
                              ),
                              if (selectPatientCtrl.selectPatient) ...[
                                GestureDetector(
                                  onTap: () {
                                    selectPatientCtrl.setXFamily(selectPatientCtrl.family);
                                    Get.to(() => SelectPatient(
                                      doctorInfo: doctorInfo,
                                      isEdit: true,
                                    ));
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: kPrimaryColor2,
                                    size: 24.0,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: kColor10),
                              boxShadow: [
                                BoxShadow(
                                  color: kBgColor2.withValues(alpha: 0.1),
                                  offset: const Offset(0.0, 4.0),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: AuthManager.instance.isLogin ? Obx(() =>
                              Text(
                                selectPatientCtrl.family?.fullname ?? '',
                                style: kTextStyle1.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: kTextColor1,
                                ),
                              ),
                            ) : Text(
                              newAppointmentCtrl.patient?.name ?? '',
                              style: kTextStyle1.copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                          if (selectPatientCtrl.isFromPackage == false) ...[
                            const SizedBox(height: 24.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Visit Type',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: kTextColor2,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    newAppointmentCtrl.setXCaseType(newAppointmentCtrl.caseType);
                                    Get.to(() => NewAppointment(
                                      doctorInfo: doctorInfo,
                                      isEdit: true,
                                    ));
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: kPrimaryColor2,
                                    size: 24.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: kColor10),
                                boxShadow: [
                                  BoxShadow(
                                    color: kBgColor2.withValues(alpha: 0.1),
                                    offset: const Offset(0.0, 4.0),
                                    blurRadius: 4.0,
                                  ),
                                ],
                              ),
                              child: Obx(() =>
                                Text(
                                  newAppointmentCtrl.caseType,
                                  style: kTextStyle1.copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    color: kTextColor1,
                                  ),
                                ),
                              ),
                            ), 
                          ],
                          
                          const SizedBox(height: 24.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Appointment Date & Time',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: kTextColor2,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  newAppointment2Ctrl.setXDate(newAppointment2Ctrl.date);
                                  Get.to(() => NewAppointment2(
                                    doctorInfo: doctorInfo,
                                    isEdit: true,
                                  ));
                                  // Get.to(() => NewAppointment3(
                                  //   selectedCaseType: selectedCaseType,
                                  //   selectedDate: selectedDate,
                                  //   doctorInfo: doctorInfo,
                                  //   doctorAppointmentStatus: doctorAppointmentStatus,
                                  //   appointmentSessions: appointmentSessions,
                                  //   isEdit: true,
                                  // ));
                                },
                                child: const Icon(
                                  Icons.edit,
                                  color: kPrimaryColor2,
                                  size: 24.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: kColor10),
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
                                  child: Obx(() =>
                                    Text(
                                      newAppointment3Ctrl.appointmentSession == null ? newAppointment4Ctrl.slot.toString() : dateTimeSession,
                                      style: kTextStyle1.copyWith(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        color: kTextColor1,
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
                    '*Please ensure all the appointment details are correct before you proceed',
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
                  text: 'Confirm Appointment',
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
      title: 'Confirm Appointment',
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
    );
  }
}

class PackageContent extends StatelessWidget {

  final UserPackagePurchase data;

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
              ],
            ),
          ),
        ],
      ),
    );
  }
}