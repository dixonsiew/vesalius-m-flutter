import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

import 'doctor_detail_content.dart';

class DoctorSuiteContent extends StatefulWidget {

  final DoctorInfo? doctorInfo;

  const DoctorSuiteContent({
    Key? key,
    required this.doctorInfo,
  }) : super(key: key);

  @override
  State<DoctorSuiteContent> createState() => _DoctorSuiteContentState();
}

class _DoctorSuiteContentState extends State<DoctorSuiteContent> {

  bool isSuiteExpanded = false;

  List<Widget> buildSuiteList() {
    List<Widget> ls = [];

    if (widget.doctorInfo != null && widget.doctorInfo!.doctorClinicLocation != null && widget.doctorInfo!.doctorClinicLocation!.isNotEmpty) {
      for (int i = 0; i < widget.doctorInfo!.doctorClinicLocation!.length; i++) {
        final o = widget.doctorInfo!.doctorClinicLocation![i];
        final w = DetailContent(text: o.location ?? '');
        ls.add(w);
      }

      ls.add(
        const SizedBox(height: 10.0)
      );
    }

    return ls;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text(
        'Suite No. / Floor',
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.bold,
          color: Color(0xFF247CA1),
        ),
      ),
      iconColor: const Color(0xFF247CA1),
      collapsedIconColor: const Color(0xFF247CA1),
      children: buildSuiteList(),
      onExpansionChanged: (bool expanded) {
        setState(() => isSuiteExpanded = expanded);
      },
    );
  }
}