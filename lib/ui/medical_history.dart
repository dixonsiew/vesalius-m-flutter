import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';

import 'medical-history/medical_history_group.dart';
import 'medical-history/vital_signs.dart';

class MedicalHistory extends StatefulWidget {
  
  static const String routeName = 'MedicalHistory';

  const MedicalHistory({super.key});

  @override
  State<MedicalHistory> createState() => _MedicalHistoryState();
}

class _MedicalHistoryState extends State<MedicalHistory> {

  Widget buildList() {
    return ListView(
      shrinkWrap: true,
      children: [
        MedicalHistoryItem(
          name: 'Vital Signs',
          onTap: () {
            Navigator.of(context).pushNamed(VitalSigns.routeName);
          },
        ),
        const Divider(
          color: Color(0xFFE2E2E2),
          height: 1.0,
          thickness: 1.0,
        ),
        MedicalHistoryItem(
          name: 'Prescription',
          onTap: () {
            Navigator.of(context).push( 
              MaterialPageRoute(
                builder: (context) => const MedicalHistoryGroup(
                  title: 'Prescription',
                  pageId: 2,
                ),
              )
            );
          },
        ),
        const Divider(
          color: Color(0xFFE2E2E2),
          height: 1.0,
          thickness: 1.0,
        ),
        MedicalHistoryItem(
          name: 'Investigation',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MedicalHistoryGroup(
                  title: 'Investigation',
                  pageId: 3,
                ),
              )
            );
          },
        ),
        const Divider(
          color: Color(0xFFE2E2E2),
          height: 1.0,
          thickness: 1.0,
        ),
        MedicalHistoryItem(
          name: 'Bill Summary',
          onTap: () {
            Navigator.of(context).push( 
              MaterialPageRoute(
                builder: (context) => const MedicalHistoryGroup(
                  title: 'Bill Summary',
                  pageId: 4,
                ),
              )
            );
          },
        ),
        const Divider(
          color: Color(0xFFE2E2E2),
          height: 1.0,
          thickness: 1.0,
        ),
        MedicalHistoryItem(
          name: 'Referral Letter',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MedicalHistoryGroup(
                  title: 'Referral Letter',
                  pageId: 6,
                ),
              )
            );
          },
        ),
        const Divider(
          color: Color(0xFFE2E2E2),
          height: 1.0,
          thickness: 1.0,
        ),
        MedicalHistoryItem(
          name: 'Health Screening Report',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MedicalHistoryGroup(
                  title: 'Health Screening Report',
                  pageId: 7,
                ),
              )
            );
          },
        ),
      ],
    );
  }

  Widget buildContent() {
    return Flexible(
      child: Container(
        margin: const EdgeInsets.only(top: 40.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(133, 133, 133, 0.29),
              offset: Offset(5, 4),
              blurRadius: 10.0,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Scrollbar(
          child: buildList(),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset(
            'images/icon/page-header-icon/medical-record.png',
            width: 65.0,
            height: 50.0,
            fit: BoxFit.contain,
          ),
          const Flexible(
            child: Text(
              'View Your Visit History',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: kTitleFont,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLayer2() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
          buildHeader(),
          buildContent(),
        ],
      ),
    );
  }

  Widget buildLayer1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          height: 160.0,
          color: kMedicalRecordBgColor,
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            color: const Color(0xFFF5F5F5),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kMedicalRecordBgColor),
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kMedicalRecordBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: const BackBtn(color: Colors.white),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            buildLayer1(),
            buildLayer2(),
          ],
        ),
      ),
    );
  }
}

class MedicalHistoryItem extends StatelessWidget {
  
  final String name;
  final void Function() onTap;

  const MedicalHistoryItem({
    super.key, 
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 25.0, bottom: 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: kBodyFont,
                color: Color(0xFF727272),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: kMedicalRecordBgColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}