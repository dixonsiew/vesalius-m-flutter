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
import 'package:vesalius_m_flutter/controllers/appointment/appointment_detail_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/upcoming_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/home_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/main_layout_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/public_service.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';
import 'package:vesalius_m_flutter/ui/appointment/reschedule_appointment.dart';

class AppointmentDetail extends StatefulWidget {

  final PatientAppointment patientAppointment;

  const AppointmentDetail({
    super.key,
    required this.patientAppointment,
  });

  @override
  State<AppointmentDetail> createState() => _AppointmentDetailState();
}

class _AppointmentDetailState extends State<AppointmentDetail> {
  
  late final TextEditingController txtreason;
  ScrollController scr = ScrollController();
  
  final AppointmentDetailCtrl ctrl = Get.put(AppointmentDetailCtrl());
  final MainLayoutCtrl mainLayoutCtrl = Get.put(MainLayoutCtrl());
  final UpcomingAppointmentCtrl upcomingAppointmentCtrl = Get.put(UpcomingAppointmentCtrl());
  final HomeCtrl homeCtrl = Get.put(HomeCtrl());

  @override
  void initState() {
    super.initState();
    txtreason = TextEditingController();
    load();
  }

  @override
  void dispose() {
    txtreason.dispose();
    scr.dispose();
    super.dispose();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      ctrl.setPatientName(await apptPatientName);
      UserBranch? branchDetails = DataManager.instance.branchDetails;
      DoctorInfo? o = await PublicVesaliusService.getDoctorByMCR(branchDetails!.branch!.branchId!, widget.patientAppointment.mcr!);
      if (o == null) {
        ctrl.setIsLoading(false);
        showCustomDialog('Error', 'Doctor Not Found', 'Dismiss');
        return;
      }

      ctrl.setDocInfo(o);
      ctrl.setIsLoading(false);
    }

    catch (_) {
      ctrl.setIsLoading(false);
    }
  }

  void onSubmitCancel() async {
    try {
      String s = await showCancel();
      if (s.isEmpty) {
        return;
      }

      ctrl.setIsLoading(true);
      final branchDetails = DataManager.instance.branchDetails!;
      final o = {
        'appointmentNumber': widget.patientAppointment.apptNo,
        'reason': s,
        'remark': widget.patientAppointment.apptPackagePurchaseNo != null ? widget.patientAppointment.apptPackagePurchaseNo! : ''
      };
      await VesaliusService.postVesaliusCancelAppointment(branchDetails.branch!.branchId!, widget.patientAppointment.apptPatientPrn ?? branchDetails.prn!, o);
      await upcomingAppointmentCtrl.loadSoonest();
      upcomingAppointmentCtrl.remove(widget.patientAppointment.apptNo);
      ctrl.setIsLoading(false);
      showSuccessCancel();
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleSubmitError(error, 'Unable to cancel appointment at the moment. Please check your internet connection or try again later.', onSubmitCancel);
    }

    catch (_) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', 'Unable to cancel appointment at the moment. Please check your internet connection or try again later.', 'Dismiss');
    }
  }

  void showSuccessCancel() async {
    Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/icon/tick1.png',
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
                color: kTextColor6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Done',
              onPressed: () {
                Get.back();
                Get.back();
              },
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
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure want to cancel this appointment?',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                    color: kBgColor2.withValues(alpha: 0.1),
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
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: AppOutlinedButton(
                    text: 'Cancel',
                    onPressed: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 16.0),
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

  List<Widget> buildDoctorContent() {
    List<DoctorSpecialities>? specialtyList = ctrl.doctorInfo?.doctorSpecialities ?? [];
    List<DoctorClinicLocation>? locationList = ctrl.doctorInfo?.doctorClinicLocation ?? [];

    List<Widget> ls = [
      Text(
        '${ctrl.doctorInfo?.name}'.trim(),
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
      ls.addAll([w, const SizedBox(height: 10.0)]);
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
          const SizedBox(width: 6.0),
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

  List<Widget> buildPackageContent() {
    List<Widget> ls = [
      Text(
        widget.patientAppointment.apptPackagePurchaseNo ?? '-',
        style: kTextStyle1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: kTextColor1,
        ),
      ),
      const SizedBox(height: 10.0),
      Text(
        widget.patientAppointment.apptPackageName ?? '-',
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: kTextColor4,
        ),
      ),
    ];
    return ls;
  }

  Future<String> get apptPatientName async {
    String s = widget.patientAppointment.apptPatientName ?? '';
    if (s == 'Self') {
      final o = await DataManager.instance.getUserDetails();
      s = '${o?.firstName} ${o?.middleName ?? ''} ${o?.lastName ?? ''}'.trim();
    }

    return s;
  }

  String getTime(String s) {
    final ts = '2023-01-01T$s:00';
    return formatDate(DateTime.parse(ts), [h, ':', nn, ' ', am]).toUpperCase();
  }

  String getDate(String s) {
    return s.replaceAll('-', ' ');
  }

  String get apptTime {
    final PatientAppointment pa = widget.patientAppointment;
    String s = '${getDate(pa.apptDate)}, ${getTime(pa.apptStartTime)}';
    if (pa.apptSlotType == 'Session') {
      String a = getTime(pa.sessionStartTime!);
      String b = getTime(pa.sessionEndTime!);
      s = '${getDate(pa.apptDate)}, ${pa.apptSessionType} ($a-$b)';
    }

    return s;
  }

  Widget buildContent() {
    return ctrl.isLoading ? Container() :
    Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 188.0),
          child: Scrollbar(
            controller: scr,
            child: ListView(
              controller: scr,
              shrinkWrap: true,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 19.0, bottom: 21.0),
                  color: kBgColor1,
                  child: Row(
                    crossAxisAlignment: widget.patientAppointment.apptPackagePurchaseNo == null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                    children: [
                      if (widget.patientAppointment.apptPackagePurchaseNo == null) ...[
                        ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(36.0), // Image radius
                            child: DoctorImage(img: ctrl.doctorInfo?.image),
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: buildDoctorContent(),
                          ),
                        ),
                      ] else ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: PackageImage(
                            img: widget.patientAppointment.apptPackageImage,
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
                            children: buildPackageContent(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  height: 1.0,
                  color: kColor1,
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Patient',
                          style: kTextStyle1.copyWith(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: kTextColor2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        padding: const EdgeInsets.all(16.0),
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
                            ctrl.patientName,
                            style: kTextStyle1.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      if (widget.patientAppointment.apptPackagePurchaseNo == null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Visit Type',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          padding: const EdgeInsets.all(16.0),
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
                          child: Text(
                            widget.patientAppointment.apptCaseType == 'NC' ? 'New Case' : 'Follow Up',
                            style: kTextStyle1.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                      ],
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Appointment Date & Time',
                          style: kTextStyle1.copyWith(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: kTextColor2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        padding: const EdgeInsets.all(16.0),
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
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                apptTime,
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
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 53.0),
                  child: Text(
                    '*Please ensure all the appointment details are correct before you proceed',
                    style: kTextStyle1.copyWith(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: kTextColor4,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AppElevatedButton(
                    text: 'Reschedule',
                    onPressed: () {
                      Get.to(() => RescheduleAppointment(
                        patientAppointment: widget.patientAppointment,
                      ));
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AppOutlinedButton(
                    text: 'Cancel Appointment',
                    onPressed: onSubmitCancel,
                  ),
                ),
                const SizedBox(height: 16.0),
                // if (widget.patientAppointment.apptPackagePurchaseNo == null) ...[
                //   Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //     child: AppOutlinedButton(
                //       text: 'Cancel Appointment',
                //       onPressed: onSubmitCancel,
                //     ),
                //   ),
                //   const SizedBox(height: 16.0),
                // ],
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
      title: 'Appointment Details',
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
