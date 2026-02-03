import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_availability_content.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_language_content.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_qualification_content.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_speciality_content.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_suite_content.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

class DoctorDetail extends StatefulWidget {

  static const String routeName = 'DoctorDetail';

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
      CustomDialog dlg = CustomDialog.of(context);
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
    CustomDialog dlg = CustomDialog.of(context);
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
      await dlg.showCustomDialog('Failed', 'Unable to launch contact: ${o.contactValue}', 'Dismiss');
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
            style: ElevatedButton.styleFrom(
              backgroundColor: kHomeBgColor,
              elevation: 5.0,
              minimumSize: const Size(double.maxFinite, 50.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  o.contactType == 'Contact No' ? Icons.call : Icons.email,
                  color: Colors.white,
                ),
                const SizedBox(width: 5.0),
                Text(
                  o.contactType == 'Contact No' ? 'Call' : 'Email',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontFamily: kBodyFont,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
        ls.add(w);
        if (i < doctorInfo!.doctorContact!.length - 1) {
          ls.add(const SizedBox(width: 15.0));
        }
      }
    }

    return ls;
  }

  Widget buildContact() {
    return Expanded(
      child: Container(
        color: const Color(0xFFF2F2F2),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
              child: Row(
                children: buildContactList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildDoctorContent(BuildContext context) {
    List<DoctorSpecialities>? specialtyList = doctorInfo!.doctorSpecialities;

    List<Widget> ls = [
      Text(
        '${doctorInfo!.name}'.trim(),
        style: const TextStyle(
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
          style: const TextStyle(
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
            DoctorLanguageContent(doctorInfo: doctorInfo),
            const Divider(
              color: Color(0xFFE0E0E0),
              height: 1.0,
              thickness: 1.0,
            ),
            DoctorQualificationContent(doctorInfo: doctorInfo),
            const Divider(
              color: Color(0xFFE0E0E0),
              height: 1.0,
              thickness: 1.0,
            ),
            DoctorSpecialityContent(doctorInfo: doctorInfo),
            const Divider(
              color: Color(0xFFE0E0E0),
              height: 1.0,
              thickness: 1.0,
            ),
            DoctorSuiteContent(doctorInfo: doctorInfo),
            const Divider(
              color: Color(0xFFE0E0E0),
              height: 1.0,
              thickness: 1.0,
            ),
            DoctorAvailabilityContent(doctorInfo: doctorInfo),
            const Divider(
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
        padding: const EdgeInsets.all(15.0),
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
                      padding: const EdgeInsets.only(left: 15.0, top: 10.0),
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