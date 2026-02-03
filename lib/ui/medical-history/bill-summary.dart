import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/components/medical-info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient-data.dart';

class BillSummary extends StatelessWidget {
  
  static const String routeName = 'BillSummary';

  final PatientVisit patientVisit;

  BillSummary({
    required this.patientVisit,
  });

  List<Widget> buildBillContent() {
    List<Widget> lx = [];
    for (int i = 0; i < patientVisit.novaBills!.length; i++) {
      lx.add(
        BillInfo(
          novaBill: patientVisit.novaBills![i],
        )
      );
      if (i < patientVisit.novaBills!.length - 1) {
        lx.add(
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
            child: Divider(
              color: Color(0xFFC9C9C9),
              height: 1.0,
              thickness: 1.0,
            ),
          )
        );
      }
    }

    return lx;
  }

  Widget buildContent() {
    List<Widget> lx = [
      Container(
        padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 15.0, right: 15.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromRGBO(224, 224, 224, 0.599),
            ),
            bottom: BorderSide(
              color: Color.fromRGBO(224, 224, 224, 0.599),
            ),
          ),
        ),
        child: Text(
          'Bill Summary',
          style: TextStyle(
            color: kPrimaryBtnBgColor,
            fontSize: 16.0,
            fontFamily: kBodyFont,
          ),
        ),
      ),
    ];
    lx.addAll(buildBillContent());

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: lx,
      ),
    );
  }

  Widget buildHeader() {
    return MedicalInfo(
      patientVisit: patientVisit,
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
        centerTitle: true,
        title: Text(
          'Bill Summary',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontFamily: kTitleFont,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildHeader(),
                buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BillInfo extends StatelessWidget {

  final NovaBill novaBill;

  BillInfo({
    required this.novaBill,
  });

  String? getAmount() {
    double? a = novaBill.amount?.toDouble();
    return a?.toStringAsFixed(2);
  }

  String getPayer() {
    String s = novaBill.payer ?? '';
    if (novaBill.invoiceType == 'PATIENT') {
      s = 'Self Pay';
    }

    return s;
  }

  String getBillTime() {
    String? t = novaBill.billTime;
    if (t == null || t == '') {
      return 'NA';
    }

    var a = t.split(':');
    int hour = int.parse(a[0]);
    int min = int.parse(a[1]);
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, min);
    return formatDate(dt, [h, ':', nn, ' ', am]);
  }

  String getBillDate() {
    DateTime dt = DateTime.parse(novaBill.billDate!);
    return formatDate(dt.toLocal(), [dd, ' ', M, ' ', yyyy]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 3.0),
        Padding(
          padding: EdgeInsets.only(top: 15.0, left: 30.0),
          child: Text(
            'Invoice No',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 14.0,
              fontFamily: kBodyFont,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0, left: 30.0),
          child: Text(
            novaBill.invoiceNumber ?? '',
            style: TextStyle(
              color: Color(0xFF777777),
              fontSize: 16.0,
              fontFamily: kBodyFont,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40.0, left: 30.0),
          child: Text(
            'Amount',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 14.0,
              fontFamily: kBodyFont,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0, left: 30.0),
          child: Text(
            "RM ${getAmount()}",
            style: TextStyle(
              color: Color(0xFF777777),
              fontSize: 16.0,
              fontFamily: kBodyFont,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40.0, left: 30.0),
          child: Text(
            'Payer',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 14.0,
              fontFamily: kBodyFont,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0, left: 30.0),
          child: Text(
            getPayer(),
            style: TextStyle(
              color: Color(0xFF777777),
              fontSize: 16.0,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40.0, left: 30.0),
          child: Text(
            'Bill Date',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 14.0,
              fontFamily: kBodyFont,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 20.0, left: 30.0),
          child: Text(
            '${getBillDate()} ${getBillTime()}',
            style: TextStyle(
              color: Color(0xFF777777),
              fontSize: 16.0,
              fontFamily: kBodyFont,
            ),
          ),
        ),
      ],
    );
  }
}