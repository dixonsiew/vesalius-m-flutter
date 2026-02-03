import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/ui/services/patient-education/cabg-recovery/sub-lists/bypass_survery.dart';
import 'package:vesalius_m_flutter/ui/services/patient-education/cabg-recovery/sub-lists/care-at-home/discharge_from_hosp.dart';
import 'package:vesalius_m_flutter/ui/services/patient-education/cabg-recovery/sub-lists/care-at-home/medications.dart';
import 'package:vesalius_m_flutter/ui/services/patient-education/cabg-recovery/sub-lists/care-at-home/when_to_seek_help.dart';
import 'package:vesalius_m_flutter/ui/services/patient-education/cabg-recovery/sub-lists/care-at-home/wound_care.dart';

class CABGRecovery extends StatefulWidget {

  final String? keyword;

  const CABGRecovery({
    super.key,
    this.keyword,
  });

  @override
  State<CABGRecovery> createState() => _CABGRecoveryState();
}

class _CABGRecoveryState extends State<CABGRecovery> {

  ScrollController scr = ScrollController();
  final CABGRecoveryContentCtrl ctrl = Get.put(CABGRecoveryContentCtrl());

  late final TextEditingController txtsearch;

  @override
  void initState() {
    super.initState();
    txtsearch = TextEditingController();
    String s = widget.keyword != null ? widget.keyword! : '';
    txtsearch.text = s;
    load();
  }

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  void load() async {
    await AuthManager.instance.load();
  }

  void onSearchTopic(String s) {
    load();
  }

  Widget buildContent() {
    return Scrollbar(
      controller: scr,
      child: ListView(
        controller: scr,
        shrinkWrap: true,
        children: [
          const SizedBox(height: 32),
          buildSearch(),
          const SizedBox(height: 28),
          buildList()
        ],
      ),
    );
  }

  Widget buildSearch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEAEAEA).withValues(alpha: 0.21),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: TextField(
        controller: txtsearch,
        autofocus: false,
        cursorColor: kPrimaryColor,
        style: const TextStyle(
          fontFamily: kBodyFont,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: kTextColor1,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15.0),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search By Topics',
          hintStyle: kTextStyle1.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: kTextColor5,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 15.0),
            child: Icon(
              Icons.search,
              color: kTextColor2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide:
                BorderSide(color: const Color(0xFFDBDBDB).withValues(alpha: 0.35)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide:
                BorderSide(color: const Color(0xFFDBDBDB).withValues(alpha: 0.35)),
          ),
        ),
        onSubmitted: onSearchTopic,
      ),
    );
  }

  Widget buildList() {
    return Column(
      children: [
        InkWell(
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 16.0,
                      ),
                      child: Text(
                        "Bypass Surgery Overview",
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Image.asset(
                  'images/icon/plus4.png',
                  width: 12.0,
                  height: 12.0,
                ),
              ),
            ],
          ),
          onTap: () {
            Get.to(() => const BypassSurveryOverview());
          },
        ),
        ExpansionTile(
          title: Text(
            "Care At Home After Bypass Surgery",
            style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1),
          ),
          trailing: Obx(
            () => Image.asset(
              ctrl.isExpanded
                  ? 'images/icon/minus2.png'
                  : 'images/icon/plus4.png',
              width: 12.0,
              height: 12.0,
            ),
          ),
          onExpansionChanged: (bool expanded) {
            ctrl.setIsExpanded(expanded);
          },
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                          child: Text(
                            "Discharge From The Hospital",
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor2,
                            ),
                          ),
                        ),
                        onTap: () {
                          Get.to(() => const DischargeFromTheHospital());
                        },
                      ),
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                          child: Text(
                            "Medications",
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor2,
                            ),
                          ),
                        ),
                        onTap: () {
                          Get.to(() => const Medications());
                        },
                      ),
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                          child: Text(
                            "Wound Care",
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor2,
                            ),
                          ),
                        ),
                        onTap: () {
                          Get.to(() => const WoundCare());
                        },
                      ),
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                          child: Text(
                            "When To Seek Help",
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor2,
                            ),
                          ),
                        ),
                        onTap: () {
                          Get.to(() => const WhenToSeekHelp());
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 16.0,
                    ),
                    child: Text(
                      "Cardiac Rehabilitation",
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Image.asset(
                'images/icon/plus4.png',
                width: 12.0,
                height: 12.0,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 16.0,
                    ),
                    child: Text(
                      "Reduce Cardiac Risk Factors",
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Image.asset(
                'images/icon/plus4.png',
                width: 12.0,
                height: 12.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Patient Education',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class CABGRecoveryContentCtrl extends GetxController {
  final _isExpanded = false.obs;

  void setIsExpanded(bool b) {
    _isExpanded.value = b;
  }

  bool get isExpanded => _isExpanded.value;
}
