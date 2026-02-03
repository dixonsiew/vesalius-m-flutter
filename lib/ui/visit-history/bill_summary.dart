import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/medical_info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class BillSummary extends StatelessWidget {
  
  final PatientVisit patientVisit;

  const BillSummary({
    Key? key, 
    required this.patientVisit,
  }) : super(key: key);

  List<Widget> buildList() {
    List<Widget> lx = [
      MedicalInfo(patientVisit: patientVisit),
      Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 30.0, bottom: 16.0),
        child: Text(
          'Bill Summary',
          style: kMainTextStyle.copyWith(
            color: kMainColor,
          ),
        ),
      ),
    ];
    for (int i = 0; i < patientVisit.novaBills!.length; i++) {
      final o = patientVisit.novaBills![i];
      final w = BillSummaryItem(novaBill: o);
      lx.add(w);
    }

    return lx;
  }

  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: buildList(),
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
          'Bill Summary',
          style: kTitleTextStyle,
        ),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: buildContent(),
          ),
        ),
      ),
    );
  }
}

class BillSummaryItem extends StatelessWidget {

  final NovaBill novaBill;

  const BillSummaryItem({
    Key? key, 
    required this.novaBill,
  }) : super(key: key);

  String? get amount {
    double? a = novaBill.amount?.toDouble();
    return a?.toStringAsFixed(2);
  }

  String get payer {
    String s = novaBill.payer ?? '';
    if (novaBill.invoiceType == 'PATIENT') {
      s = 'Self Pay';
    }

    return s;
  }

  String get billTime {
    String? t = novaBill.billTime;
    if (t == null || t == '') {
      return 'NA';
    }

    List<String> a = t.split(':');
    int hour = int.parse(a[0]);
    int min = int.parse(a[1]);
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, min);
    return formatDate(dt, [h, ':', nn, ' ', am]);
  }

  String get billDate {
    DateTime dt = DateTime.parse(novaBill.billDate!);
    return formatDate(dt.toLocal(), [dd, ' ', M, ' ', yyyy]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(229, 229, 229, 0.7),
            offset: Offset(0, 4.0),
            blurRadius: 7.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Invoice Number',
                  style: kBodyTextStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7C7C7C),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  novaBill.invoiceNumber ?? '',
                  style: kLabelTextStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Amount',
                  style: kBodyTextStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7C7C7C),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'RM $amount',
                  style: kLabelTextStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Payer',
                  style: kBodyTextStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7C7C7C),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  payer,
                  style: kLabelTextStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Bill Date',
                  style: kBodyTextStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7C7C7C),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '$billDate $billTime',
                  style: kLabelTextStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}