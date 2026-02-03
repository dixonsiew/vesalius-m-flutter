import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

import 'doctor_detail_content.dart';

class DoctorSpecialityContent extends StatefulWidget {

  final DoctorInfo? doctorInfo;

  const DoctorSpecialityContent({
    Key? key,
    required this.doctorInfo,
  }) : super(key: key);

  @override
  State<DoctorSpecialityContent> createState() => _DoctorSpecialityContentState();
}

class _DoctorSpecialityContentState extends State<DoctorSpecialityContent> {

  bool isSpecialityExpanded = false;

  List<Widget> buildSpecialityList() {
    List<Widget> ls = [];

    if (widget.doctorInfo != null && widget.doctorInfo!.doctorSpecialities != null && widget.doctorInfo!.doctorSpecialities!.isNotEmpty) {
      for (int i = 0; i < widget.doctorInfo!.doctorSpecialities!.length; i++) {
        final o = widget.doctorInfo!.doctorSpecialities![i];
        final w = DetailContent(text: o.specialities ?? '');
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
        'Specialities',
        style: kTextStyle1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: isSpecialityExpanded ? kTextColor1 : kTextColor2,
        ),
      ),
      iconColor: kTextColor1,
      collapsedIconColor: kTextColor2,
      children: buildSpecialityList(),
      onExpansionChanged: (bool expanded) {
        setState(() => isSpecialityExpanded = expanded);
      },
    );
  }
}