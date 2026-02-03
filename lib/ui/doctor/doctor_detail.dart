import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_detail_content.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
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
  bool isLanguageExpanded = false;
  bool isQualificationExpanded = false;
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
      var branchDetails = DataManager.branchDetails;
      var o = await getDoctorByMCR(branchDetails!.branch!.branchId!, widget.mcr);
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

  void launchAction(DoctorContact o) async {
    String s = o.contactType == 'Contact No' ? 'tel' : 'mailto';
    String? v = o.contactValue;
    if (o.contactType == 'Contact No') {
      v = o.contactValue?.replaceWhitespacesUsingRegex('');
    }

    String url = '$s:$v';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }

    else {
      await showCustomDialog('Failed', 'Unable to launch contact: ${o.contactValue}', 'Dismiss');
    }
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

  List<Widget> buildContactList() {
    List<Widget> ls = [];

    if (doctorInfo != null && doctorInfo!.doctorContact != null && doctorInfo!.doctorContact!.isNotEmpty) {
      for (int i = 0; i < doctorInfo!.doctorContact!.length; i++) {
        final o = doctorInfo!.doctorContact![i];
        final w = InkWell(
          onTap: () {
            launchAction(o);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 18, top: 10.0, bottom: 10.0),
            child: Row(
              children: [
                o.contactType == 'Contact No' ? Image.asset(
                  'images/icon/call1.png',
                  width: 16.0,
                  height: 16.0,
                  fit: BoxFit.cover,
                ) : Image.asset(
                  'images/icon/email.png',
                  width: 16.0,
                  height: 11.44,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    o.contactValue!,
                    style: kBodyTextStyle.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        ls.add(w);
      }
    }

    return ls;
  }

  Widget buildContact() {
    return ExpansionTile(
      title: Text(
        'Contact Information',
        style: kBodyTextStyle.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: isAvailabilityExpanded ? kMainColor : const Color(0xFF002E50),
        ),
      ),
      iconColor: kMainColor,
      collapsedIconColor: const Color(0xFF002E50),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      onExpansionChanged: (bool expanded) {
        setState(() => isAvailabilityExpanded = expanded);
      },
      children: buildContactList(),
    );
  }

  List<Widget> buildAvailabilityList() {
    List<Widget> ls = [];

    if (doctorInfo != null && doctorInfo!.doctorClinicHours != null && doctorInfo!.doctorClinicHours!.isNotEmpty) {
      for (int i = 0; i < doctorInfo!.doctorClinicHours!.length; i++) {
        final o = doctorInfo!.doctorClinicHours![i];
        String a = o.byAppointmentOnly ?? false ? '*' : '';
        String s = '${o.dayStartTime} - ${o.dayEndTime}$a';
        final w = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  o.dayOfTheWeek ?? '',
                  style: kBodyTextStyle.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  s,
                  style: kBodyTextStyle.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
        ls.add(w);
        ls.add(const SizedBox(height: 10.0));
      }

      ls.add(
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 20.0),
          child: Text(
            '*By Appointment Basis',
            style: kBodyTextStyle.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return ls;
  }

  Widget buildAvailability() {
    return ExpansionTile(
      title: Text(
        'Available Hours',
        style: kBodyTextStyle.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: isAvailabilityExpanded ? kMainColor : const Color(0xFF002E50),
        ),
      ),
      iconColor: kMainColor,
      collapsedIconColor: const Color(0xFF002E50),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      onExpansionChanged: (bool expanded) {
        setState(() => isAvailabilityExpanded = expanded);
      },
      children: buildAvailabilityList(),
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

  List<Widget> buildSpecialityList() {
    List<Widget> ls = [];

    if (doctorInfo != null && doctorInfo!.doctorSpecialities != null && doctorInfo!.doctorSpecialities!.isNotEmpty) {
      for (int i = 0; i < doctorInfo!.doctorSpecialities!.length; i++) {
        final o = doctorInfo!.doctorSpecialities![i];
        final w = DetailContent(text: o.specialities ?? '');
        ls.add(w);
      }

      ls.add(
        const SizedBox(height: 10.0)
      );
    }

    return ls;
  }

  Widget buildSpeciality() {
    return ExpansionTile(
      title: const Text(
        'Specialities',
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.bold,
          color: Color(0xFF247CA1),
        ),
      ),
      iconColor: const Color(0xFF247CA1),
      collapsedIconColor: const Color(0xFF247CA1),
      children: buildSpecialityList(),
      onExpansionChanged: (bool expanded) {
        setState(() => isSpecialityExpanded = expanded);
      },
    );
  }

  List<Widget> buildQualificationList() {
    List<Widget> ls = [];
    
    if (doctorInfo != null && doctorInfo!.doctorQualifications != null && doctorInfo!.doctorQualifications!.isNotEmpty) {
      for (int i = 0; i < doctorInfo!.doctorQualifications!.length; i++) {
        final o = doctorInfo!.doctorQualifications![i];
        final w = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  o.qualification ?? '',
                  style: kBodyTextStyle.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
        ls.add(w);
        ls.add(const SizedBox(height: 10.0));
      }

      ls.add(const SizedBox(height: 10.0));
    }

    return ls;
  }

  Widget buildQualification() {
    return ExpansionTile(
      title: Text(
        'Qualifications',
        style: kBodyTextStyle.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: isQualificationExpanded ? kMainColor : const Color(0xFF002E50),
        ),
      ),
      iconColor: kMainColor,
      collapsedIconColor: const Color(0xFF002E50),
      children: buildQualificationList(),
      onExpansionChanged: (bool expanded) {
        setState(() => isQualificationExpanded = expanded);
      },
    );
  }

  List<Widget> buildLanguageList() {
    List<Widget> ls = [];
    List<String> lx = [];

    if (doctorInfo != null && doctorInfo!.doctorSpokenLanguage != null && doctorInfo!.doctorSpokenLanguage!.isNotEmpty) {
      for (int i = 0; i < doctorInfo!.doctorSpokenLanguage!.length; i++) {
        final o = doctorInfo!.doctorSpokenLanguage![i];
        if (o.spokenLanguage != null && o.spokenLanguage != '') {
          lx.add(o.spokenLanguage!);
        }
      }
    }

    String s = lx.isEmpty ? '' : lx.join(', ');
    if (s.isNotEmpty) {
      final w = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                s,
                style: kBodyTextStyle.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      );
      ls.addAll([
        w,
        const SizedBox(height: 20.0),
      ]);
    }

    return ls;
  }

  Widget buildLanguage() {
    return ExpansionTile(
      title: Text(
        'Languages Spoken',
        style: kBodyTextStyle.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: isLanguageExpanded ? kMainColor : const Color(0xFF002E50),
        ),
      ),
      iconColor: kMainColor,
      collapsedIconColor: const Color(0xFF002E50),
      children: buildLanguageList(),
      onExpansionChanged: (bool expanded) {
        setState(() => isLanguageExpanded = expanded);
      },
    );
  }

  List<Widget> buildDoctorContent(BuildContext context) {
    List<DoctorSpecialities>? specialtyList = doctorInfo!.doctorSpecialities;

    List<Widget> ls = [
      Text(
        '${doctorInfo!.name}'.trim(),
        style: kTitleTextStyle.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF4E4E4E),
        ),
      ),
      const SizedBox(height: 8.0),
    ];

    if (specialtyList != null) {
      for (int i = 0; i < specialtyList.length; i++) {
        Widget w = Text(
          specialtyList[i].specialities ?? '',
          style: kBodyTextStyle.copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8C8C8C),
          ),
        );
        ls.add(w);
        ls.add(const SizedBox(height: 8.0));
      }
    }

    Widget l = Row(
      children: [
        Image.asset(
          'images/icon/location1.png',
          width: 16.0,
          height: 16.0,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 5.0),
        Text(
          'Room 212, Level 2',
          style: kBodyTextStyle.copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: kMainColor,
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
            buildQualification(),
            buildDivider(),
            buildLanguage(),
            buildDivider(),
            buildAvailability(),
            buildDivider(),
            buildContact(),
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
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: const Color(0xFFF8F8F8),
        leading: const BackBtn(color: Color(0xFF002E50)),
        centerTitle: true,
        title: Text(
          'Doctor Profile',
          style: kMainTextStyle.copyWith(
            fontSize: 16.0,
            color: const Color(0xFF002E50),
          ),
        ),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
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
                  padding: const EdgeInsets.only(left: 33.0, right: 33.0, bottom: 42.0),
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
                      style: kMainTextStyle.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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