import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';

class Hospital extends StatelessWidget {

  static const String routeName = 'Hospital';

  const Hospital({super.key});

  Widget ourStoryContent(String title, String content) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        gradient: LinearGradient(
          colors: [Color.fromRGBO(0, 0, 0, 0.3), Color.fromRGBO(0, 0, 0, 0.3)],
        ),
        color: Colors.grey,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0, bottom: 5.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontFamily: kBodyFont,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
            child: Text(
              content,
              style: const TextStyle(
                height: 1.5,
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: kBodyFont,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOurStory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: ourStoryContent('About Us',
'''Healthcare organisations around the world are striving to decrease costs, improve efficiency without compromising on the quality of care.

VESALIUS is designed to facilitate 
info-communications and to streamline processes between departments. Developed on a single integrated platform, it serves the wide-ranging needs of hospital administrators, caregivers, paraclinicals and most importantly, patients. VESALIUS’ unique architecture allows healthcare groups to implement a centralised system that is intelligently deployed to multiple hospitals – sharing critical information such as medical records and restricting data access to a need-only basis.'''
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      height: 90.0,
      color: kSearchHospitalBgColor,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0, top: 20.0, bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(
              'images/icon/page-header-icon/search-hospital.png',
              width: 65.0,
              height: 50.0,
              fit: BoxFit.contain,
            ),
            const Text(
              'View Hospital Information',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: kTitleFont,
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
        systemOverlayStyle: Platform.isAndroid ? const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light, statusBarColor: kSearchHospitalBgColor) : SystemUiOverlayStyle.light,
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kSearchHospitalBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: const BackBtn(color: Colors.white),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Scrollbar(
          child: ListView(
            shrinkWrap: true,
            children: [
              buildHeader(),
              buildOurStory(),
              // buildVision(),
            ],
          ),
        ),
      ),
    );
  }
}