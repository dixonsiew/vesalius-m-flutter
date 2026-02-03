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
      title: Text(
        'Suite No. / Floor',
        style: kTextStyle1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: isSuiteExpanded ? kTextColor1 : kTextColor2,
        ),
      ),
      iconColor: kTextColor1,
      collapsedIconColor: kTextColor2,
      children: buildSuiteList(),
      onExpansionChanged: (bool expanded) {
        setState(() => isSuiteExpanded = expanded);
      },
    );
  }
}