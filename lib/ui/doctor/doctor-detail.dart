import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vesalius_m_flutter/components/app-shared.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor-detail-content.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/models/doctor-data.dart';
import 'package:vesalius_m_flutter/services/data-service.dart';

class DoctorDetail extends StatefulWidget {

  static const String routeName = 'DoctorDetail';

  final String mcr;

  DoctorDetail({
    required this.mcr,
  });

  @override
  _DoctorDetailState createState() => _DoctorDetailState();
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
        showCustomDialog('Failed', 'Doctor Not Found', 'Dismiss', context);
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
    ImageProvider<Object> im = AssetImage('images/imgs/no_image.png');
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
      v = o.contactValue.replaceWhitespacesUsingRegex('');
    }

    String url = '$s:$v';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }

    else {
      await showCustomDialog('Failed', 'Unable to launch contact: ${o.contactValue}', 'Dismiss', context);
    }
  }

  List<Widget> buildContactList() {
    List<Widget> ls = [];

    if (doctorInfo != null && doctorInfo!.doctorContact != null && doctorInfo!.doctorContact!.isNotEmpty) {
      for (int i = 0; i < doctorInfo!.doctorContact!.length; i++) {
        final o = doctorInfo!.doctorContact![i];
        final w = Expanded(
          child: ElevatedButton(
            onPressed: () {
              launchAction(o);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  o.contactType == 'Contact No' ? Icons.call : Icons.email,
                  color: Colors.white,
                ),
                SizedBox(width: 5.0),
                Text(
                  o.contactType == 'Contact No' ? 'Call' : 'Email',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: kBodyFont,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              primary: kHomeBgColor,
              elevation: 5.0,
              minimumSize: Size(double.maxFinite, 50.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
            ),
          ),
        );
        ls.add(w);
        if (i < doctorInfo!.doctorContact!.length - 1) {
          ls.add(SizedBox(width: 15.0));
        }
      }
    }

    return ls;
  }

  Widget buildContact() {
    return Expanded(
      child: Container(
        color: Color(0xFFF2F2F2),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
              child: Row(
                children: buildContactList(),
              ),
            ),
          ],
        ),
      ),
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
          padding: EdgeInsets.only(left: 10.0, top: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 5.0,
                height: 5.0,
                margin: EdgeInsets.only(right: 15.0, top: 8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
              ),
              Flexible(
                child: SizedBox(
                  width: 100.0,
                  child: Text(
                    o.dayOfTheWeek ?? '',
                    style: TextStyle(
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
                  style: TextStyle(
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
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 10.0),
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
    }

    return ls;
  }

  Widget buildAvailability() {
    return ExpansionTile(
      title: Text(
        'Available Hours',
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.bold,
          color: Color(0xFF247CA1),
        ),
      ),
      iconColor: Color(0xFF247CA1),
      collapsedIconColor: Color(0xFF247CA1),
      children: buildAvailabilityList(),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      onExpansionChanged: (bool expanded) {
        setState(() => isAvailabilityExpanded = expanded);
      },
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
        SizedBox(height: 10.0)
      );
    }

    return ls;
  }

  Widget buildSuite() {
    return ExpansionTile(
      title: Text(
        'Suite No. / Floor',
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.bold,
          color: Color(0xFF247CA1),
        ),
      ),
      iconColor: Color(0xFF247CA1),
      collapsedIconColor: Color(0xFF247CA1),
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
        SizedBox(height: 10.0)
      );
    }

    return ls;
  }

  Widget buildSpeciality() {
    return ExpansionTile(
      title: Text(
        'Specialities',
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.bold,
          color: Color(0xFF247CA1),
        ),
      ),
      iconColor: Color(0xFF247CA1),
      collapsedIconColor: Color(0xFF247CA1),
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
        final w = DetailContent(text: o.qualification ?? '');
        ls.add(w);
      }

      ls.add(
        SizedBox(height: 10.0)
      );
    }

    return ls;
  }

  Widget buildQualification() {
    return ExpansionTile(
      title: Text(
        'Qualifications',
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.bold,
          color: Color(0xFF247CA1),
        ),
      ),
      iconColor: Color(0xFF247CA1),
      collapsedIconColor: Color(0xFF247CA1),
      children: buildQualificationList(),
      onExpansionChanged: (bool expanded) {
        setState(() => isQualificationExpanded = expanded);
      },
    );
  }

  List<Widget> buildLanguageList() {
    List<Widget> ls = [];

    if (doctorInfo != null && doctorInfo!.doctorSpokenLanguage != null && doctorInfo!.doctorSpokenLanguage!.isNotEmpty) {
      for (int i = 0; i < doctorInfo!.doctorSpokenLanguage!.length; i++) {
        final o = doctorInfo!.doctorSpokenLanguage![i];
        final w = DetailContent(text: o.spokenLanguage ?? '');
        ls.add(w);
      }

      ls.add(
        SizedBox(height: 10.0)
      );
    }

    return ls;
  }

  Widget buildLanguage() {
    return ExpansionTile(
      title: Text(
        'Languages Spoken',
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.bold,
          color: Color(0xFF247CA1),
        ),
      ),
      iconColor: Color(0xFF247CA1),
      collapsedIconColor: Color(0xFF247CA1),
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
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: kTitleFont,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];

    if (specialtyList != null) {
      for (int i = 0; i < specialtyList.length; i++) {
        Widget w = Text(
          specialtyList[i].specialities ?? '',
          style: TextStyle(
            fontSize: 14.0,
            fontFamily: kBodyFont,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        );
        ls.add(w);
      }
    }

    return ls;
  }

  Widget buildContentList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 320,
      child: Scrollbar(
        child: ListView(
          children: [
            buildLanguage(),
            Divider(
              color: Color(0xFFE0E0E0),
              height: 1.0,
              thickness: 1.0,
            ),
            buildQualification(),
            Divider(
              color: Color(0xFFE0E0E0),
              height: 1.0,
              thickness: 1.0,
            ),
            buildSpeciality(),
            Divider(
              color: Color(0xFFE0E0E0),
              height: 1.0,
              thickness: 1.0,
            ),
            buildSuite(),
            Divider(
              color: Color(0xFFE0E0E0),
              height: 1.0,
              thickness: 1.0,
            ),
            buildAvailability(),
            Divider(
              color: Color(0xFFE0E0E0),
              height: 1.0,
              thickness: 1.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      color: kSearchDoctorBgColor,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: getDoctorImage(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.0, top: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: buildDoctorContent(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kSearchDoctorBgColor),
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kSearchDoctorBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: BackBtn(color: Colors.white),
        elevation: 0.0,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: AppActivityIndicator(), // AppScalingText('Loading...'),
        child: SafeArea(
          child: isLoading ? Container() : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildHeader(),
              buildContentList(),
              buildContact(),
            ],
          ),
        ),
      ),
    );
  }
}