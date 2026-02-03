import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';

class MedicalHistory extends StatelessWidget {

  static const String routeName = '/MedicalHistory';

  const MedicalHistory({Key? key}) : super(key: key);

  Widget buildContent() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: MedicalHistoryItem(
                    image: 'health-dashboard.png',
                    title: 'Health\nDashboard',
                    onTap: () {
                      
                    },
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: MedicalHistoryItem(
                    image: 'allergies.png',
                    title: 'Allergies &\nReactions',
                    onTap: () {
                      
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: MedicalHistoryItem(
                    image: 'vital-signs.png',
                    title: 'Vital Signs',
                    onTap: () {
                      
                    },
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: MedicalHistoryItem(
                    image: 'prescription.png',
                    title: 'Prescription',
                    onTap: () {
                      
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: MedicalHistoryItem(
                    image: 'investigation.png',
                    title: 'Investigation',
                    onTap: () {
                      
                    },
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: MedicalHistoryItem(
                    image: 'bill-summary.png',
                    title: 'Bill Summary',
                    onTap: () {
                      
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: MedicalHistoryItem(
                    image: 'referral-letter.png',
                    title: 'Referral Letter\n',
                    onTap: () {
                      
                    },
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: MedicalHistoryItem(
                    image: 'health-screen-rpt.png',
                    title: 'Health Screening\nReport',
                    onTap: () {
                      
                    },
                  ),
                ),
              ],
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
          'Medical History',
          style: kTextStyle1.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: kTextColor1,
          ),
        ),
        elevation: 0.0,
      ),
      backgroundColor: kBgColor1,
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
    Key? key,
    required this.image,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: const Color(0xFFDADADA).withOpacity(0.35),
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
                const SizedBox(height: 8.0),
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