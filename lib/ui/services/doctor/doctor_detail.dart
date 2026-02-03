import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_availability_content.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_contact_content.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_language_content.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_qualification_content.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/doctor/doctor_detail_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/ui/appointment/select_patient.dart';

class DoctorDetail extends StatefulWidget {

  static const String routeName = '/DoctorDetail';

  final String mcr;

  const DoctorDetail({
    super.key,
    required this.mcr,
  });

  @override
  State<DoctorDetail> createState() => _DoctorDetailState();
}

class _DoctorDetailState extends State<DoctorDetail> {

  final DoctorDetailCtrl ctrl = Get.put(DoctorDetailCtrl());

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      UserBranch? branchDetails = DataManager.branchDetails;
      DoctorInfo? o = await PublicVesaliusService.getDoctorByMCR(branchDetails!.branch!.branchId!, widget.mcr);
      if (o == null) {
        ctrl.setIsLoading(false);
        showCustomDialog('Failed', 'Doctor Not Found', 'Dismiss');
        return;
      }

      ctrl.setDoctorInfo(o);
      ctrl.setIsLoading(false);
    }

    catch (error) {
      ctrl.setIsLoading(false);
    }
  }

  Image getDoctorImage() {
    String? image = ctrl.doctorInfo?.image;
    Image im = Image.asset('images/imgs/no_image.png', fit: BoxFit.cover);
    if (image != null && image != '') {
      int i = image.indexOf('base64,');
      String data = image;
      if (i < 0) {
        data = image.trim();
      }

      else {
        data = image.substring(i + 7).trim();
      }
      im = Image.memory(
        base64Decode(data),
        fit: BoxFit.cover,
      );
    }

    return im;
  }

  Widget buildDivider() {
    return const Divider(
      color: Color(0xFFE5E5E5),
      height: 1.0,
      thickness: 1.0,
    );
  }

  List<Widget> buildDoctorContent(BuildContext context) {
    List<DoctorSpecialities>? specialtyList = ctrl.doctorInfo!.doctorSpecialities;
    List<DoctorClinicLocation>? locationList = ctrl.doctorInfo!.doctorClinicLocation;

    List<Widget> ls = [
      Text(
        '${ctrl.doctorInfo!.name}'.trim(),
        style: kTextStyle1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: kTextColor1,
        ),
      ),
      const SizedBox(height: 8.0),
    ];

    for (int i = 0; i < specialtyList.length; i++) {
      Widget w = Text(
        specialtyList[i].specialities ?? '',
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: kTextColor4,
        ),
      );
      ls.addAll([
        w,
        const SizedBox(height: 8.0),
      ]);
    }

    for (int i = 0; i < locationList.length; i++) {
      Widget w = Row(
        children: [
          Image.asset(
            'images/icon/location5.png',
            width: 16.0,
            height: 16.0,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 5.0),
          Text(
            locationList[i].location ?? '',
            style: kTextStyle1.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: kTextColor4,
            ),
          ),
        ],
      );
      ls.addAll([
        w,
        const SizedBox(height: 8.0),
      ]);
    }

    if (specialtyList.isNotEmpty || locationList.isNotEmpty) {
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

  List<Widget> buildContentList() {
    return [
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
              child: getDoctorImage(),
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
    return ctrl.isLoading ? Container() : 
    Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: ctrl.doctorInfo?.allowAppointment == 'Y' ? 80.0 : 0),
          child: Scrollbar(
            child: ListView(
              shrinkWrap: true,
              children: [
                buildHeader(),
                ...buildContentList(),
              ],
            ),
          ),
        ),
        if (ctrl.doctorInfo?.allowAppointment == 'Y' && AuthManager.isLogin) ...[
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: kBgColor1,
              padding: const EdgeInsets.all(16.0),
              child: AppElevatedButton(
                text: 'Make An Appointment',
                onPressed: () {
                  Get.to(() => SelectPatient(doctorInfo: ctrl.doctorInfo!));
                },
              ),
            ),
          ),
        ]
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
            progressIndicator: const AppActivityIndicator(),
            child: buildContent(),
          ),
        ),
      ),
    );
  }
}