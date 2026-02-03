import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_availability_content.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_contact_content.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_detail_content.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_language_content.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_qualification_content.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/ui/appointment/new_appointment.dart';

class DoctorDetail extends StatefulWidget {

  static const String routeName = '/DoctorDetail';

  final String mcr;

  const DoctorDetail({
    Key? key, 
    required this.mcr,
  }) : super(key: key);

  @override
  State<DoctorDetail> createState() => _DoctorDetailState();
}

class _DoctorDetailState extends State<DoctorDetail> {

  DoctorInfo? doctorInfo;
  bool isLoading = false;
  bool isSpecialityExpanded = false;
  bool isSuiteExpanded = false;
  bool isAvailabilityExpanded = false;
  bool isContactExpanded = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      setState(() {
        isLoading = true;
      });
      UserBranch? branchDetails = DataManager.branchDetails;
      DoctorInfo? o = await getDoctorByMCR(branchDetails!.branch!.branchId!, widget.mcr);
      if (o == null) {
        setState(() {
          isLoading = false;
        });
        showCustomDialog('Failed', 'Doctor Not Found', 'Dismiss');
        return;
      }

      setState(() {
        doctorInfo = o;
        isLoading = false;
      });
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  ImageProvider<Object> getDoctorImage() {
    String? image = doctorInfo?.image;
    ImageProvider<Object> im = const AssetImage('images/imgs/no_image.png');
    if (image != null && image != '') {
      int i = image.indexOf('base64,');
      String data = image;
      if (i < 0) {
        data = image.trim();
      }

      else {
        data = image.substring(i + 7).trim();
      }
      im = MemoryImage(
        base64Decode(data),
      );
    }

    return im;
  }

  Widget buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      child: Divider(
        color: Color(0xFFE5E5E5),
        height: 1.0,
        thickness: 1.0,
      ),
    );
  }

  List<Widget> buildSuiteList() {
    List<Widget> ls = [];

    if (doctorInfo != null && doctorInfo!.doctorClinicLocation != null && doctorInfo!.doctorClinicLocation!.isNotEmpty) {
      for (int i = 0; i < doctorInfo!.doctorClinicLocation!.length; i++) {
        final o = doctorInfo!.doctorClinicLocation![i];
        final w = DetailContent(text: o.location ?? '');
        ls.add(w);
      }

      ls.add(
        const SizedBox(height: 10.0)
      );
    }

    return ls;
  }

  Widget buildSuite() {
    return ExpansionTile(
      title: const Text(
        'Suite No. / Floor',
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.bold,
          color: Color(0xFF247CA1),
        ),
      ),
      iconColor: const Color(0xFF247CA1),
      collapsedIconColor: const Color(0xFF247CA1),
      children: buildSuiteList(),
      onExpansionChanged: (bool expanded) {
        setState(() => isSuiteExpanded = expanded);
      },
    );
  }

  List<Widget> buildDoctorContent(BuildContext context) {
    List<DoctorSpecialities>? specialtyList = doctorInfo!.doctorSpecialities;

    List<Widget> ls = [
      Text(
        '${doctorInfo!.name}'.trim(),
        style: kTextStyle1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: kTextColor1,
        ),
      ),
      const SizedBox(height: 8.0),
    ];

    if (specialtyList != null) {
      for (int i = 0; i < specialtyList.length; i++) {
        Widget w = Text(
          specialtyList[i].specialities ?? '',
          style: kTextStyle1.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: kTextColor4,
          ),
        );
        ls.add(w);
        ls.add(const SizedBox(height: 8.0));
      }
    }

    Widget l = Row(
      children: [
        Image.asset(
          'images/icon/location5.png',
          width: 16.0,
          height: 16.0,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 5.0),
        Text(
          'Room 212, Level 2',
          style: kTextStyle1.copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
            color: kTextColor4,
          ),
        ),
      ],
    );
    ls.add(l);

    return ls;
  }

  Widget buildContentList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 320,
      child: Scrollbar(
        child: ListView(
          children: [
            DoctorQualificationContent(doctorInfo: doctorInfo),
            buildDivider(),
            DoctorLanguageContent(doctorInfo: doctorInfo),
            buildDivider(),
            DoctorAvailabilityContent(doctorInfo: doctorInfo),
            buildDivider(),
            DoctorContactContent(doctorInfo: doctorInfo),
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
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        children: [
          Container(
            width: 64.0,
            height: 64.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: getDoctorImage(),
                fit: BoxFit.cover,
              ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: kBgColor1,
        leading: const BackBtn(color: kTextColor1),
        centerTitle: true,
        title: Text(
          'Doctor Profile',
          style: kTextStyle1.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: kTextColor1,
          ),
        ),
        elevation: 0.0,
      ),
      backgroundColor: kBgColor1,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(),
        child: SafeArea(
          child: isLoading ? Container() : Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeader(),
                  buildContentList(),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  color: const Color(0xFFF8F8F8),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => NewAppointment(doctorInfo: doctorInfo));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      backgroundColor: kMainColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    ),
                    child: Text(
                      'Make An Appointment',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}