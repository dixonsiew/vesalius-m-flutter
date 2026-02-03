import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_availability_content.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_contact_content.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_image.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_language_content.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_qualification_content.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/select_patient_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/services/doctor/doctor_detail_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/family_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/services/public_service.dart';
import 'package:vesalius_m_flutter/ui/appointment/new_appointment.dart';
import 'package:vesalius_m_flutter/ui/appointment/patient_info.dart';
import 'package:vesalius_m_flutter/ui/appointment/select_patient.dart';

class DoctorDetail extends StatefulWidget {

  final String mcr;

  const DoctorDetail({
    super.key,
    required this.mcr,
  });

  @override
  State<DoctorDetail> createState() => _DoctorDetailState();
}

class _DoctorDetailState extends State<DoctorDetail> {

  ScrollController scr = ScrollController();
  final DoctorDetailCtrl ctrl = Get.put(DoctorDetailCtrl());
  final SelectPatientCtrl selectPatientCtrl = Get.put(SelectPatientCtrl());

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      UserBranch? branchDetails = DataManager.instance.branchDetails;
      DoctorInfo? o = await PublicVesaliusService.getDoctorByMCR(branchDetails!.branch!.branchId!, widget.mcr);
      if (o == null) {
        ctrl.setIsLoading(false);
        showCustomDialog('Error', 'Doctor Not Found', 'Dismiss');
        return;
      }

      ctrl.setDoctorInfo(o);
      ctrl.setIsLoading(false);
    }

    catch (_) {
      ctrl.setIsLoading(false);
    }
  }

  void onMakeAppointmentGuest() async {
    Get.to(() => PatientInfo(doctorInfo: ctrl.doctorInfo!));
  }

  void onMakeAppointment() async {
    try {
      selectPatientCtrl.init();
      ctrl.setIsLoading(true);
      await AuthManager.instance.load();
      List<Family> lx = await MyFamilyService.getAllFamilies(1, kPageSize, true, true);
      ctrl.setIsLoading(false);
      selectPatientCtrl.setFamily(null);

      if (lx.length == 1) {
        selectPatientCtrl.setFamily(lx.first);
      }

      if (lx.length < 2) {
        selectPatientCtrl.setSelectPatient(false);
        Get.to(() => NewAppointment(doctorInfo: ctrl.doctorInfo!));
      }

      else {
        selectPatientCtrl.setSelectPatient(true);
        Get.to(() => SelectPatient(doctorInfo: ctrl.doctorInfo!, list: lx));
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

  Widget buildDivider() {
    return const Divider(
      color: Color(0xFFE5E5E5),
      height: 1.0,
      thickness: 1.0,
    );
  }

  List<Widget> buildDoctorContent(BuildContext context) {
    // List<DoctorSpecialities>? specialtyList = ctrl.doctorInfo!.doctorSpecialities;
    List<DoctorClinicLocation>? locationList = ctrl.doctorInfo!.doctorClinicLocation;

    List<Widget> ls = [
      Text(
        '${ctrl.doctorInfo!.name}'.trim(),
        style: kTextStyle1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: kPrimaryColor,
        ),
      ),
      const SizedBox(height: 8.0),
      if (ctrl.doctorInfo!.qualifications?.isNotEmpty ?? false) ...[
        Text(
          '${ctrl.doctorInfo!.qualifications}',
          style: kTextStyle1.copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: kTextColor4,
          ),
        ),
        const SizedBox(height: 8.0),
      ],
    ];

    // for (int i = 0; i < specialtyList.length; i++) {
    //   Widget w = Text(
    //     specialtyList[i].specialities ?? '',
    //     style: kTextStyle1.copyWith(
    //       fontSize: 14.0,
    //       fontWeight: FontWeight.w500,
    //       color: kTextColor4,
    //     ),
    //   );
    //   ls.addAll([w, const SizedBox(height: 8.0)]);
    // }

    if (ctrl.doctorInfo!.registrationNum?.isNotEmpty ?? false) {
      ls.addAll([
        Text(
          ctrl.doctorInfo!.registrationNum ?? '-',
          style: kTextStyle1.copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: kTextColor5,
          ),
        ),
        const SizedBox(height: 8.0),
      ]);
    }

    for (int i = 0; i < locationList.length; i++) {
      String? building = locationList[i].building;
      String loc = locationList[i].location ?? '';
      Widget w = Row(
        children: [
          Image.asset(
            'images/icon/location5.png',
            width: 16.0,
            height: 16.0,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 5.0),
          if (building == null) ...[
            Text(
              locationList[i].toString(),
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
      ls.addAll([w, const SizedBox(height: 8.0)]);
    }

    if (locationList.isNotEmpty) {
      ls.removeLast();
    }

    // Widget l = Row(
    //   children: [
    //     Image.asset(
    //       'images/icon/location5.png',
    //       width: 16.0,
    //       height: 16.0,
    //       fit: BoxFit.contain,
    //     ),
    //     const SizedBox(width: 5.0),
    //     Text(
    //       'Room 212, Level 2',
    //       style: kTextStyle1.copyWith(
    //         fontSize: 12.0,
    //         fontWeight: FontWeight.w500,
    //         color: kTextColor4,
    //       ),
    //     ),
    //   ],
    // );
    // ls.add(l);

    return ls;
  }

  List<Widget> buildSpecialtyList() {
    List<DoctorSpecialities>? specialtyList = ctrl.doctorInfo!.doctorSpecialities;
    List<Widget> ls = [];
    final s = Text(
      'Specialty',
      style: kTextStyle1.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: kPrimaryColor,
      ),
    );
    final sub = Text(
      'Subspecialty',
      style: kTextStyle1.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: kPrimaryColor,
      ),
    );

    for (int i = 0; i < specialtyList.length; i++) {
      Widget w = Text(
        specialtyList[i].specialities ?? '',
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: kTextColor4,
        ),
      );
      Widget wsub = Text(
        specialtyList[i].subspecialty ?? '-',
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: kTextColor4,
        ),
      );
      ls.addAll([
        s,
        const SizedBox(height: 8.0),
        w,
        const SizedBox(height: 24.0),
        sub,
        const SizedBox(height: 8.0),
        wsub,
        const SizedBox(height: 8.0),
      ]);
    }

    ls.removeLast();
    return ls;
  }

  Widget buildSpecialty() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildSpecialtyList(),
      ),
    );
  }

  List<Widget> buildContentList() {
    return [
      if (ctrl.doctorInfo?.doctorSpecialities.isNotEmpty ?? false) ...[
        buildDivider(),
        buildSpecialty(),
      ],
      buildDivider(),
      DoctorQualificationContent(doctorInfo: ctrl.doctorInfo),
      buildDivider(),
      DoctorLanguageContent(doctorInfo: ctrl.doctorInfo),
      buildDivider(),
      DoctorAvailabilityContent(doctorInfo: ctrl.doctorInfo),
      buildDivider(),
      DoctorContactContent(doctorInfo: ctrl.doctorInfo),
      buildDivider(),
      // buildSpeciality(),
      // Divider(
      //   color: Color(0xFFE5E5E5),
      //   height: 1.0,
      //   thickness: 1.0,
      // ),
      // buildSuite(),
      // Divider(
      //   color: Color(0xFFE5E5E5),
      //   height: 1.0,
      //   thickness: 1.0,
      // ),
    ];
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
      child: Row(
        children: [
          ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(32.0), // Image radius
              child: DoctorImage(img: ctrl.doctorInfo?.image),
            ),
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildDoctorContent(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent() {
    return ctrl.isLoading && ctrl.doctorInfo == null ? Container() : 
    Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: ctrl.doctorInfo?.allowAppointment == 'Y' ? 80.0 : 0),
          child: Scrollbar(
            controller: scr,
            child: ListView(
              controller: scr,
              shrinkWrap: true,
              children: [
                buildHeader(),
                ...buildContentList(),
              ],
            ),
          ),
        ),
        if (ctrl.doctorInfo?.allowAppointment == 'Y' && AuthManager.instance.isLogin) ...[
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: kBgColor1,
              padding: const EdgeInsets.all(16.0),
              child: AppElevatedButton(
                text: 'Make An Appointment',
                onPressed: onMakeAppointment,
              ),
            ),
          ),
        ] else if (ctrl.doctorInfo?.showMakeAppointmentButton == 'Y' && !AuthManager.instance.isLogin) ...[
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: kBgColor1,
              padding: const EdgeInsets.all(16.0),
              child: AppElevatedButton(
                text: 'Make An Appointment',
                onPressed: onMakeAppointmentGuest,
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
      title: 'Doctor Profile',
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