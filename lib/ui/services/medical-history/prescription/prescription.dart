import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/medical-history/medical_info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/ui/services/medical-history/bill_summary/bill_summary.dart';

class Prescription extends StatefulWidget {

  final PatientVisit patientVisit;

  const Prescription({
    super.key,
    required this.patientVisit,
  });

  @override
  State<Prescription> createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {

  ScrollController scr = ScrollController();
  Map<String, List<NovaVisitPatientRx>> map = {};
  List<String> doctorList = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  void load() {
    var lx = widget.patientVisit.novaVisitPatientRxList;
    for (int i = 0; i < lx.length; i++) {
      final o = lx[i];
      String s = o.doctorName ?? '';
      if (map.containsKey(s)) {
        var ls = map[s]!;
        ls.add(o);
      }

      else {
        List<NovaVisitPatientRx> ls = [o];
        map[s] = ls;
        doctorList.add(s);
      }
    }
  }

  List<Widget> _buildContentList() {
    List<Widget> lx = [];
    for (int i = 0; i < doctorList.length; i++) {
      String doctorName = doctorList[i];
      final ls = map[doctorName];
      lx.add(PrescriptionInfo(doctorName: doctorName, list: ls ?? []));
    }

    return lx;
  }

  List<Widget> buildContentList() {
    return [
      Padding(
        padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
        child: Text(
          'Prescription',
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
      controller: scr,
      child: ListView(
        controller: scr,
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
      title: 'Prescription',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class PrescriptionInfo extends StatelessWidget {

  final String doctorName;
  final List<NovaVisitPatientRx> list;

  const PrescriptionInfo({
    super.key,
    required this.doctorName,
    required this.list,
  });

  List<Widget> buildContentList() {
    List<Widget> lx = [];
    for (int i = 0; i < list.length; i++) {
      final NovaVisitPatientRx o = list[i];
      lx.addAll([
        const SizedBox(height: 16.0),
        BillData(
          label: 'Medications',
          data: o.description ?? '',
        ),
        const SizedBox(height: 16.0),
        BillData(
          label: 'Instruction',
          data: o.instruction ?? '',
        ),
      ]);
    }

    return lx;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: kColor1.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0.0, 4.0),
            blurRadius: 8.0,
            color: kColor1.withValues(alpha: 0.3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          BillData(
            label: 'Doctor',
            data: doctorName,
          ),
          ...buildContentList(),
        ],
      ),
    );
  }
}