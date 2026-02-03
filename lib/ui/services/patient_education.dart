import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/ui/services/patient-education/cabg-recovery/cabg_recovery.dart';

class PatientEducation extends StatefulWidget {
  static const String routeName = '/PatientEducation';

  final String? keyword;

  const PatientEducation({
    super.key,
    this.keyword,
  });

  @override
  State<PatientEducation> createState() => _PatientEducationState();
}

class _PatientEducationState extends State<PatientEducation> {
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
    txtsearch.dispose();
    super.dispose();
  }

  void load() async {
    await AuthManager.load();
  }

  Future<void> onRefresh() async {
    load();
  }

  void onSearchTopic(String s) {
    load();
  }

  Widget buildContent() {
    return Scrollbar(
      child: ListView(
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
            color: const Color(0xFFEAEAEA).withOpacity(0.21),
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
            color: kTextColor2,
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
                BorderSide(color: const Color(0xFFDBDBDB).withOpacity(0.35)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide:
                BorderSide(color: const Color(0xFFDBDBDB).withOpacity(0.35)),
          ),
        ),
        onSubmitted: onSearchTopic,
      ),
    );
  }

  Widget buildList() {
    const numLists = 4;
    const textConst = [
      "Post Coronary Atery Bypass Graft Surgery (CABG) Recovery",
      "Diabetes Care",
      "Post Covid-19 Care",
      "General Health Tips"
    ];

    Widget buildRow(int index) {
      return InkWell(
        onTap: () {
          if (index == 0) {
            Get.to(() => const CABGRecovery());
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: const BoxDecoration(
                  color: kCircleBgColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Image.asset(
                    'images/icon/comment.png',
                    width: 16.0,
                    height: 16.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textConst[index],
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 22.0),
              Image.asset(
                'images/icon/right-arrow-gray.png',
                width: 12.0,
                height: 12.0,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: numLists,
      itemBuilder: (BuildContext context, int i) {
        return buildRow(i);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Patient Education',
      body: SafeArea(
        child: buildContent(),
      ));
  }
}
