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
      title: const Text(
        'Specialities',
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.bold,
          color: Color(0xFF247CA1),
        ),
      ),
      iconColor: const Color(0xFF247CA1),
      collapsedIconColor: const Color(0xFF247CA1),
      children: buildSpecialityList(),
      onExpansionChanged: (bool expanded) {
        setState(() => isSpecialityExpanded = expanded);
      },
    );
  }
}