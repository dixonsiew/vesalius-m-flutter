import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/constants.dart';

import 'medical-history/medical-history-group.dart';
import 'medical-history/vital-signs.dart';

class MedicalHistory extends StatefulWidget {
  
  static final String routeName = 'MedicalHistory';

  @override
  _MedicalHistoryState createState() => _MedicalHistoryState();
}

class _MedicalHistoryState extends State<MedicalHistory> {

  Widget buildList() {
    return ListView(
      shrinkWrap: true,
      children: [
        MedicalHistoryItem(
          name: 'Vital Signs',
          onTap: () {
            Navigator.pushNamed(context, VitalSigns.routeName);
          },
        ),
        Divider(
          color: Color(0xFFE2E2E2),
          height: 1.0,
          thickness: 1.0,
        ),
        MedicalHistoryItem(
          name: 'Prescription',
          onTap: () {
            Navigator.push(context, 
              MaterialPageRoute(
                builder: (context) => MedicalHistoryGroup(
                  title: 'Prescription',
                  pageId: 2,
                ),
              )
            );
          },
        ),
        Divider(
          color: Color(0xFFE2E2E2),
          height: 1.0,
          thickness: 1.0,
        ),
        MedicalHistoryItem(
          name: 'Investigation',
          onTap: () {
            Navigator.push(context, 
              MaterialPageRoute(
                builder: (context) => MedicalHistoryGroup(
                  title: 'Investigation',
                  pageId: 3,
                ),
              )
            );
          },
        ),
        Divider(
          color: Color(0xFFE2E2E2),
          height: 1.0,
          thickness: 1.0,
        ),
        MedicalHistoryItem(
          name: 'Bill Summary',
          onTap: () {
            Navigator.push(context, 
              MaterialPageRoute(
                builder: (context) => MedicalHistoryGroup(
                  title: 'Bill Summary',
                  pageId: 4,
                ),
              )
            );
          },
        ),
        Divider(
          color: Color(0xFFE2E2E2),
          height: 1.0,
          thickness: 1.0,
        ),
        MedicalHistoryItem(
          name: 'Referral Letter',
          onTap: () {
            Navigator.push(context, 
              MaterialPageRoute(
                builder: (context) => MedicalHistoryGroup(
                  title: 'Referral Letter',
                  pageId: 6,
                ),
              )
            );
          },
        ),
        Divider(
          color: Color(0xFFE2E2E2),
          height: 1.0,
          thickness: 1.0,
        ),
        MedicalHistoryItem(
          name: 'Health Screening Report',
          onTap: () {
            Navigator.push(context, 
              MaterialPageRoute(
                builder: (context) => MedicalHistoryGroup(
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
    return Container(
      margin: EdgeInsets.only(top: 40.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.white,
        boxShadow: <BoxShadow>[
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
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.0, top: 20.0),
          child: Container(
            width: 80.0,
            height: 60.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                image: AssetImage('images/icon/page-header-icon/medical-record.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 20.0, top: 25.0),
            child: Text(
              'View Your Visit History',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLayer2() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            buildHeader(),
            buildContent(),
          ],
        ),
      ),
    );
  }

  Widget buildLayer1() {
    return Container(
      width: double.infinity,
      height: 160.0,
      color: kMedicalRecordBgColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kMedicalRecordBgColor),
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kMedicalRecordBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: BackBtn(color: Colors.white),
        elevation: 0.0,
      ),
      backgroundColor: Color(0xFFF5F5F5),
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

  MedicalHistoryItem({
    @required this.name,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 10.0, top: 25.0, bottom: 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$name',
              style: TextStyle(
                fontSize: 18.0,
                color: Color(0xFF727272),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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