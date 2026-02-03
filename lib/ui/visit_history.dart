import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/ui/visit-history/vital_signs.dart';

import 'visit-history/visit_history_group.dart';

class VisitHistory extends StatelessWidget {
  
  static const String routeName = '/VisitHistory';

  const VisitHistory({Key? key}) : super(key: key);

  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 35.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.toNamed(VitalSigns.routeName);
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    padding: const EdgeInsets.only(top: 31.0, bottom: 32.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(236, 238, 255, 0.8),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/imgs/healthcare.png',
                          width: 48.0,
                          height: 48.0,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 17.0),
                        Text(
                          'Vital Signs',
                          style: kMainTextStyle.copyWith(
                            color: const Color(0xFF002E50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 27.0),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(() => const VisitHistoryGroup(
                      title: 'Prescription',
                      pageId: 2,
                    ));
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    padding: const EdgeInsets.only(top: 31.0, bottom: 32.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(236, 238, 255, 0.8),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/imgs/drugs.png',
                          width: 48.0,
                          height: 48.0,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 17.0),
                        Text(
                          'Prescription',
                          style: kMainTextStyle.copyWith(
                            color: const Color(0xFF002E50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(() => const VisitHistoryGroup(
                      title: 'Investigation',
                      pageId: 3,
                    ));
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    padding: const EdgeInsets.only(top: 31.0, bottom: 32.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(236, 238, 255, 0.8),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/imgs/lab-tool.png',
                          width: 48.0,
                          height: 48.0,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 17.0),
                        Text(
                          'Investigation',
                          style: kMainTextStyle.copyWith(
                            color: const Color(0xFF002E50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 27.0),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(() => const VisitHistoryGroup(
                      title: 'Bill Summary',
                      pageId: 4,
                    ));
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    padding: const EdgeInsets.only(top: 31.0, bottom: 32.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(236, 238, 255, 0.8),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/imgs/bill.png',
                          width: 48.0,
                          height: 48.0,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 17.0),
                        Text(
                          'Bill Summary',
                          style: kMainTextStyle.copyWith(
                            color: const Color(0xFF002E50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(() => const VisitHistoryGroup(
                      title: 'Referral Letter',
                      pageId: 6,
                    ));
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    padding: const EdgeInsets.only(top: 31.0, bottom: 32.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(236, 238, 255, 0.8),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/imgs/email.png',
                          width: 48.0,
                          height: 48.0,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 17.0),
                        Text(
                          'Referral Letter',
                          style: kMainTextStyle.copyWith(
                            color: const Color(0xFF002E50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 27.0),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(() => const VisitHistoryGroup(
                      title: 'Health Screening Report',
                      pageId: 7,
                    ));
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    padding: const EdgeInsets.only(top: 31.0, bottom: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(236, 238, 255, 0.8),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/imgs/medical-checkup.png',
                          width: 48.0,
                          height: 48.0,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 17.0),
                        Text(
                          'Health Screening Report',
                          style: kMainTextStyle.copyWith(
                            color: const Color(0xFF002E50),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
        title: const Text(
          'Visit History',
          style: kTitleTextStyle,
        ),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: buildContent(context),
      ),
    );
  }
}