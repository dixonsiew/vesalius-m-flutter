import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/medical-history/medical_info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class BillSummary extends StatelessWidget {
  
  static const String routeName = 'BillSummary';

  final PatientVisit patientVisit;

  const BillSummary({
    super.key,
    required this.patientVisit,
  });

  List<Widget> _buildContentList() {
    List<Widget> lx = [];
    for (int i = 0; i < patientVisit.novaBills.length; i++) {
      final NovaBill o = patientVisit.novaBills[i];
      lx.add(BillInfo(novaBill: o));
    }

    return lx;
  }

  List<Widget> buildContentList() {
    return [
      Padding(
        padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
        child: Text(
          'Bill Summary',
          style: kTextStyle1.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: kPrimaryColor,
          ),
        ),
      ),
      ..._buildContentList(),
    ];
  }

  Widget buildContent() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          MedicalInfo(patientVisit: patientVisit),
          const SizedBox(height: 32.0),
          ...buildContentList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Bill Summary',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class BillInfo extends StatelessWidget {

  final NovaBill novaBill;

  const BillInfo({
    super.key,
    required this.novaBill,
  });

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

    var a = t.split(':');
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
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4.0),
            blurRadius: 7.0,
            color: kBgColor2.withOpacity(0.7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          BillData(
            label: 'Invoice Number',
            data: novaBill.invoiceNumber ?? '',
          ),
          const SizedBox(height: 15.0),
          BillData(
            label: 'Amount',
            data: 'RM $amount',
          ),
          const SizedBox(height: 15.0),
          BillData(
            label: 'Payer',
            data: payer,
          ),
          const SizedBox(height: 15.0),
          BillData(
            label: 'Bill Date',
            data: '$billDate $billTime',
          ),
        ],
      ),
    );
  }
}

class BillData extends StatelessWidget {

  final String label;
  final String data;

  const BillData({
    super.key,
    required this.label,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: kTextColor2,
            ),
          ),
        ),
        Expanded(
          child: Text(
            data,
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
          ),
        ),
      ],
    );
  }
}