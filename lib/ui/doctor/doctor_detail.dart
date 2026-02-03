import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_detail_content.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_detail_header.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

class DoctorDetail extends StatefulWidget {

  static const String routeName = 'DoctorDetail';

  final String mcr;

  const DoctorDetail({
    super.key, 
    this.mcr = '',
  });

  @override
  State<DoctorDetail> createState() => _DoctorDetailState();
}

class _DoctorDetailState extends State<DoctorDetail> {

  DoctorInfo? doctorInfo;
  bool isLoading = false;

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
      final dlg = CustomDialog.of(context);
      var branchDetails = DataManager.branchDetails;
      var o = await getDoctorByMCR(branchDetails!.branch!.branchId!, widget.mcr);
      if (o == null) {
        setState(() {
          isLoading = false;
        });
        dlg.showCustomDialog('Failed', 'Doctor Not Found', 'Dismiss');
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
    final dlg = CustomDialog.of(context);
    if (o.contactType == 'Contact No') {
      v = o.contactValue.replaceWhitespacesUsingRegex('');
    }

    String url = '$s:$v';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }

    else {
      dlg.showCustomDialog('Failed', 'Unable to launch contact: ${o.contactValue}', 'Dismiss');
    }
  }

  List<Widget> buildContactList() {
    List<Widget> ls = [
      const DetailHeader(title: 'Contact Information'),
    ];

    for (int i = 0; i < doctorInfo!.doctorContact!.length; i++) {
      final o = doctorInfo!.doctorContact![i];
      final w = Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  launchAction(o);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  elevation: 5.0,
                ),
                child: Row(
                  children: [
                    Icon(
                      o.contactType == 'Contact No' ? Icons.call : Icons.email,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      o.contactValue ?? '',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: kBodyFont,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
      ls.add(w);
    }

    return ls;
  }

  Widget buildContact() {
    if (doctorInfo != null && doctorInfo?.doctorContact != null && doctorInfo!.doctorContact!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0, bottom: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildContactList(),
        ),
      );
    }

    else {
      return Container();
    }
  }

  List<Widget> buildAvailabilityList() {
    List<Widget> ls = [
      const DetailHeader(title: 'Available Hours'),
    ];

    for (int i = 0; i < doctorInfo!.doctorClinicHours!.length; i++) {
      final o = doctorInfo!.doctorClinicHours![i];
      String a = o.byAppointmentOnly ?? false ? '*' : '';
      String s = '${o.dayStartTime} - ${o.dayEndTime}$a';
      final w = Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 5.0,
              height: 5.0,
              margin: const EdgeInsets.only(right: 15.0, top: 8.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
            Flexible(
              child: SizedBox(
                width: 100.0,
                child: Text(
                  o.dayOfTheWeek ?? '',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontFamily: kBodyFont,
                    color: Color(0xFF4B4B4B),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                s,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: kBodyFont,
                  color: Color(0xFF4B4B4B),
                ),
              ),
            ),
          ],
        ),
      );
      ls.add(w);
    }

    ls.add(
      const Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: Text(
          '*By Appointment Basis',
          style: TextStyle(
            fontSize: 14.0,
            fontFamily: kBodyFont,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );

    return ls;
  }

  Widget buildAvailability() {
    if (doctorInfo != null && doctorInfo?.doctorClinicHours != null && doctorInfo!.doctorClinicHours!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildAvailabilityList(),
        ),
      );
    }
    
    else {
      return Container();
    }
  }

  List<Widget> buildSuiteList() {
    List<Widget> ls = [
      const DetailHeader(title: 'Suite No. / Floor'),
    ];

    for (int i = 0; i < doctorInfo!.doctorClinicLocation!.length; i++) {
      final o = doctorInfo!.doctorClinicLocation![i];
      final w = DetailContent(text: o.location ?? '');
      ls.add(w);
    }

    return ls;
  }

  Widget buildSuite() {
    if (doctorInfo != null && doctorInfo?.doctorClinicLocation != null && doctorInfo!.doctorClinicLocation!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildSuiteList(),
        ),
      );
    }
    
    else {
      return Container();
    }
  }

  List<Widget> buildSpecialityList() {
    List<Widget> ls = [
      const DetailHeader(title: 'Specialities'),
    ];

    for (int i = 0; i < doctorInfo!.doctorSpecialities!.length; i++) {
      final o = doctorInfo!.doctorSpecialities![i];
      final w = DetailContent(text: o.specialities ?? '');
      ls.add(w);
    }

    return ls;
  }

  Widget buildSpeciality() {
    if (doctorInfo != null && doctorInfo?.doctorSpecialities != null && doctorInfo!.doctorSpecialities!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildSpecialityList(),
        ),
      );
    }
    
    else {
      return Container();
    }
  }

  List<Widget> buildQualificationList() {
    List<Widget> ls = [
      const DetailHeader(title: 'Qualificatons'),
    ];

    for (int i = 0; i < doctorInfo!.doctorQualifications!.length; i++) {
      final o = doctorInfo!.doctorQualifications![i];
      final w = DetailContent(text: o.qualification ?? '');
      ls.add(w);
    }

    return ls;
  }

  Widget buildQualification() {
    if (doctorInfo != null && doctorInfo?.doctorQualifications != null && doctorInfo!.doctorQualifications!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildQualificationList(),
        ),
      );
    }
    
    else {
      return Container();
    }
  }

  List<Widget> buildLanguageList() {
    List<Widget> ls = [
      const DetailHeader(title: 'Languages Spoken'),
    ];

    for (int i = 0; i < doctorInfo!.doctorSpokenLanguage!.length; i++) {
      final o = doctorInfo!.doctorSpokenLanguage![i];
      final w = DetailContent(text: o.spokenLanguage ?? '');
      ls.add(w);
    }

    return ls;
  }

  Widget buildLanguage() {
    if (doctorInfo != null && doctorInfo?.doctorSpokenLanguage != null && doctorInfo!.doctorSpokenLanguage!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildLanguageList(),
        ),
      );
    }
    
    else {
      return Container();
    }
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: getDoctorImage(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                doctorInfo?.name ?? '',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
        // brightness: Brightness.dark,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kSearchDoctorBgColor),
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kSearchDoctorBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: const BackBtn(color: Colors.white),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(), // AppScalingText('Loading...'),
        child: SafeArea(
          child: isLoading ? Container() : Scrollbar(
            child: ListView(
              children: [
                buildHeader(),
                buildLanguage(),
                buildQualification(),
                buildSpeciality(),
                buildSuite(),
                buildAvailability(),
                buildContact(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}