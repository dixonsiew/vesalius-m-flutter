import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

import 'doctor_detail_content.dart';

class DoctorQualificationContent extends StatefulWidget {

  final DoctorInfo? doctorInfo;

  const DoctorQualificationContent({
    Key? key,
    required this.doctorInfo,
  }) : super(key: key);

  @override
  State<DoctorQualificationContent> createState() => _DoctorQualificationContentState();
}

class _DoctorQualificationContentState extends State<DoctorQualificationContent> {

  bool isQualificationExpanded = false;

  List<Widget> buildQualificationList() {
    List<Widget> ls = [];
    
    if (widget.doctorInfo != null && widget.doctorInfo!.doctorQualifications != null && widget.doctorInfo!.doctorQualifications!.isNotEmpty) {
      for (int i = 0; i < widget.doctorInfo!.doctorQualifications!.length; i++) {
        final o = widget.doctorInfo!.doctorQualifications![i];
        final w = DetailContent(text: o.qualification ?? '');
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
        'Qualifications',
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.bold,
          color: Color(0xFF247CA1),
        ),
      ),
      iconColor: const Color(0xFF247CA1),
      collapsedIconColor: const Color(0xFF247CA1),
      children: buildQualificationList(),
      onExpansionChanged: (bool expanded) {
        setState(() => isQualificationExpanded = expanded);
      },
    );
  }
}