import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/medical-history/medical_info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/ui/services/medical-history/bill_summary/bill_summary.dart';

class Investigation extends StatefulWidget {

  static const String routeName = '/Investigation';
  
  final PatientVisit patientVisit;
  final String date;

  const Investigation({
    super.key,
    required this.patientVisit,
    required this.date,
  });

  @override
  State<Investigation> createState() => _InvestigationState();
}

class _InvestigationState extends State<Investigation> {

  Map<String, List<NovaVisitInvestigationDetail>> map = {};
  List<String> investigationTypeList = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    final lx = widget.patientVisit.novaVisitInvestigationDetailList;
    for (int i = 0; i < lx.length; i++) {
      final NovaVisitInvestigationDetail o = lx[i];
      String s = o.investigationType!.toLowerCase();
      if (map.containsKey(s)) {
        List<NovaVisitInvestigationDetail> ls = map[s]!;
        ls.add(o);
      }

      else {
        List<NovaVisitInvestigationDetail> ls = [o];
        map[s] = ls;
        investigationTypeList.add(s);
      }
    }
  }

  List<Widget> buildContentList() {
    List<Widget> lx = [];
    for (int i = 0; i < investigationTypeList.length; i++) {
      if (investigationTypeList[i] == 'clincial measurement') {
        lx.add(ClinicalMeasurement(date: widget.date, map: map));
      }

      if (investigationTypeList[i] == 'radiology services') {
        lx.add(RadiologyService(date: widget.date, map: map));
      }

      if (investigationTypeList[i] == 'diagnostic investigation') {
        lx.add(DiagnosticInvest(date: widget.date, map: map));
      }

      if (investigationTypeList[i] == 'lab services') {
        lx.add(LabService(date: widget.date, map: map));
      }
    }

    return lx;
  }

  Widget buildContent() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          MedicalInfo(patientVisit: widget.patientVisit),
          const SizedBox(height: 32.0),
          ...buildContentList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Investigation',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class RowHeader extends StatelessWidget {

  final String title;

  const RowHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        title,
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: kPrimaryColor,
        ),
      ),
    );
  }
}

class ContentBox extends StatelessWidget {

  final List<Widget> lk;

  const ContentBox({
    super.key,
    required this.lk,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: const Color(0xFFDBDBDB).withOpacity(0.3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: lk,
      ),
    );
  }
}

class DiagnosticInvest extends StatelessWidget {

  final String date;
  final Map<String, List<NovaVisitInvestigationDetail>> map;

  const DiagnosticInvest({
    super.key,
    required this.date,
    required this.map,
  });

  @override
  Widget build(BuildContext context) {
    final ls = map['diagnostic investigation']!;
    List<Widget> lk = [
      Text(
        date,
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: kTextColor1,
        ),
      ),
      const SizedBox(height: 16.0),
    ];
    for (int i = 0; i < ls.length; i++) {
      final NovaVisitInvestigationDetail o = ls[i];
      lk.addAll([
        const SizedBox(height: 10.0),
        Text(
          o.description ?? '',
          style: kTextStyle1.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: kTextColor1,
          ),
        ),
        const SizedBox(height: 5.0),
        Html(
          data: o.resultValue == null && o.resultClob == null ? 'Result in PDF format. Unable to view now' : o.resultClob,
          style: {
            'html': Style(
              fontSize: FontSize(15.0),
              fontFamily: kBodyFont,
            ),
          },
        ),
      ]);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RowHeader(title: 'Diagnostic Investigation'),
        ContentBox(lk: lk),
      ],
    );
  }
}

class ClinicalMeasurement extends StatelessWidget {

  final String date;
  final Map<String, List<NovaVisitInvestigationDetail>> map;

  const ClinicalMeasurement({
    super.key,
    required this.date,
    required this.map,
  });

  @override
  Widget build(BuildContext context) {
    final ls = map['clincial measurement']!;
    List<Widget> lk = [
      Text(
        date,
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: kTextColor1,
        ),
      ),
      const SizedBox(height: 16.0),
      Row(
        children: [
          Expanded(
            child: Text(
              'Description',
              style: kTextStyle1.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: kTextColor2,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Result/Unit',
              style: kTextStyle1.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: kTextColor2,
              ),
            ),
          ),
        ],
      ),
    ];
    for (int i = 0; i < ls.length; i++) {
      final NovaVisitInvestigationDetail o = ls[i];
      lk.addAll([
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: Text(
                o.description ?? '',
                style: kTextStyle1.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: kTextColor1,
                ),
                softWrap: false,
                overflow: TextOverflow.visible,
              ),
            ),
            Expanded(
              child: Text(
                o.resultValue == null ? '-' : '${o.resultValue} ${o.resultUnit}',
                style: kTextStyle1.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: kTextColor1,
                ),
              ),
            ),
          ],
        ),
      ]);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RowHeader(title: 'Clinical Measurement'),
        ContentBox(lk: lk),
      ],
    );
  }
}

class LabService extends StatelessWidget {

  final String date;
  final Map<String, List<NovaVisitInvestigationDetail>> map;

  const LabService({
    super.key,
    required this.date,
    required this.map,
  });

  @override
  Widget build(BuildContext context) {
    final ls = map['lab services']!;
    List<Widget> lk = [
      Text(
        date,
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: kTextColor1,
        ),
      ),
      const SizedBox(height: 16.0),
      Row(
        children: [
          Expanded(
            child: Text(
              'Test',
              style: kTextStyle1.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: kTextColor2,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Result/Unit',
              style: kTextStyle1.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: kTextColor2,
              ),
            ),
          ),
          Flexible(
            child: Text(
              'Ref Range',
              style: kTextStyle1.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: kTextColor2,
              ),
            ),
          ),
        ],
      ),
    ];
    for (int i = 0; i < ls.length; i++) {
      final NovaVisitInvestigationDetail o = ls[i];
      lk.addAll([
        const SizedBox(height: 16.0),
        if (o.description != null) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  o.description ?? '',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  o.resultValue == null ? '-' : '${o.resultValue} ${o.resultUnit}',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  o.referenceRange ?? '-',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ]);
      if (o.panelDescription != null) {
        lk.addAll([
          const SizedBox(height: 10.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
            decoration: BoxDecoration(
              color: kTextColor1,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Text(
              o.panelDescription ?? '',
                style: kTextStyle1.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ]);
      }

      if (o.panelDetail.isNotEmpty) {
        for (int j = 0; j < o.panelDetail.length; j++) {
          final PanelDetail x = o.panelDetail[j];
          lk.addAll([
            const SizedBox(height: 10.0),
            BillData(
              label: 'Description',
              data: x.description ?? '',
            ),
            const SizedBox(height: 5.0),
          ]);
          if (x.resultClob != null) {
            lk.add(
              Html(
                data: x.resultClob ?? '',
                style: {
                  'html': Style(
                    fontSize: FontSize(15.0),
                    fontFamily: kBodyFont,
                  ),
                },
              ),
            );
          }

          if (x.resultClob == null) {
            lk.addAll([
              BillData(
                label: 'Result / Unit',
                data: x.resultValue == null ? '-' : '${x.resultValue} ${x.resultUnit}',
              ),
              const SizedBox(height: 5.0),
              BillData(
                label: 'Ref. Range',
                data: x.referenceRange ?? '-',
              ),
              const SizedBox(height: 10.0),
            ]);
          }
        }
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RowHeader(title: 'Lab Services'),
        ContentBox(lk: lk),
      ],
    );
  }
}

class RadiologyService extends StatelessWidget {

  final String date;
  final Map<String, List<NovaVisitInvestigationDetail>> map;

  const RadiologyService({
    super.key,
    required this.date,
    required this.map,
  });

  @override
  Widget build(BuildContext context) {
    final ls = map['radiology services']!;
    List<Widget> lk = [
      Text(
        date,
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: kTextColor1,
        ),
      ),
      const SizedBox(height: 16.0),
    ];
    for (int i = 0; i < ls.length; i++) {
      final NovaVisitInvestigationDetail o = ls[i];
      lk.addAll([
        const SizedBox(height: 10.0),
        Text(
          o.description ?? '',
          style: kTextStyle1.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: kTextColor1,
          ),
        ),
        const SizedBox(height: 5.0),
        Html(
          data: o.resultValue == null && o.resultClob == null ? 'Result in PDF format. Unable to view now' : o.resultClob,
          style: {
            'html': Style(
              fontSize: FontSize(15.0),
              fontFamily: kBodyFont,
            ),
          },
        ),
      ]);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RowHeader(title: 'Radiology Services'),
        ContentBox(lk: lk),
      ],
    );
  }
}