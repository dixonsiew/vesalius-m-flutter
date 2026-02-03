import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/ui/services/medical-history/allergies.dart';
import 'package:vesalius_m_flutter/ui/services/medical-history/health_dashboard.dart';
import 'package:vesalius_m_flutter/ui/services/medical-history/medical_history_group.dart';
import 'package:vesalius_m_flutter/ui/services/medical-history/vital_signs.dart';

class MedicalHistory extends StatefulWidget {

  const MedicalHistory({super.key});

  @override
  State<MedicalHistory> createState() => _MedicalHistoryState();
}

class _MedicalHistoryState extends State<MedicalHistory> {

  ScrollController scr = ScrollController();

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }
  
  Widget buildContent() {
    return Scrollbar(
      controller: scr,
      child: ListView(
        controller: scr,
        shrinkWrap: true,
        children: [
          const SizedBox(height: 26.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                Expanded(
                  child: MedicalHistoryItem(
                    image: 'health-dashboard.png',
                    title: 'Health\nDashboard',
                    onTap: () {
                      Get.to(() => const HealthDashboard());
                    },
                  ),
                ),
                const SizedBox(width: 27.0),
                Expanded(
                  child: MedicalHistoryItem(
                    image: 'allergies.png',
                    title: 'Allergies &\nReactions',
                    onTap: () {
                      Get.to(() => const Allergies());
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                Expanded(
                  child: MedicalHistoryItem(
                    image: 'vital-signs.png',
                    title: 'Vital Signs',
                    onTap: () {
                      Get.to(() => const VitalSigns());
                    },
                  ),
                ),
                const SizedBox(width: 27.0),
                Expanded(
                  child: MedicalHistoryItem(
                    image: 'prescription.png',
                    title: 'Prescription',
                    onTap: () {
                      Get.to(() => const MedicalHistoryGroup(
                        title: 'Prescription',
                        pageId: 2,
                      ));
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                Expanded(
                  child: MedicalHistoryItem(
                    image: 'investigation.png',
                    title: 'Investigation',
                    onTap: () {
                      Get.to(() => const MedicalHistoryGroup(
                        title: 'Investigation',
                        pageId: 3,
                      ));
                    },
                  ),
                ),
                const SizedBox(width: 27.0),
                Expanded(
                  child: MedicalHistoryItem(
                    image: 'bill-summary.png',
                    title: 'Bill Summary',
                    onTap: () {
                      Get.to(() => const MedicalHistoryGroup(
                        title: 'Bill Summary',
                        pageId: 4,
                      ));
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                Expanded(
                  child: MedicalHistoryItem(
                    image: 'referral-letter.png',
                    title: 'Referral Letter\n',
                    onTap: () {
                      Get.to(() => const MedicalHistoryGroup(
                        title: 'Referral Letter',
                        pageId: 6,
                      ));
                    },
                  ),
                ),
                const SizedBox(width: 27.0),
                Expanded(
                  child: MedicalHistoryItem(
                    image: 'health-screen-rpt.png',
                    title: 'Health Screening\nReport',
                    onTap: () {
                      Get.to(() => const MedicalHistoryGroup(
                        title: 'Health Screening Report',
                        pageId: 7,
                      ));
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Medical History',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class MedicalHistoryItem extends StatelessWidget {

  final String image;
  final String title;
  final void Function() onTap;

  const MedicalHistoryItem({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: const Color(0xFFDADADA).withValues(alpha: 0.35),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/imgs/$image',
                  width: 48.0,
                  height: 48.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 18.0),
                Text(
                  title,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: kTextColor1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}