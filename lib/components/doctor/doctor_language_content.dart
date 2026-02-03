import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

import 'doctor_detail_content.dart';

class DoctorLanguageContent extends StatefulWidget {

  final DoctorInfo? doctorInfo;

  const DoctorLanguageContent({
    Key? key,
    required this.doctorInfo,
  }) : super(key: key);

  @override
  State<DoctorLanguageContent> createState() => _DoctorLanguageContentState();
}

class _DoctorLanguageContentState extends State<DoctorLanguageContent> {

  bool isLanguageExpanded = false;

  List<Widget> buildLanguageList() {
    List<Widget> ls = [];

    if (widget.doctorInfo != null && widget.doctorInfo!.doctorSpokenLanguage != null && widget.doctorInfo!.doctorSpokenLanguage!.isNotEmpty) {
      for (int i = 0; i < widget.doctorInfo!.doctorSpokenLanguage!.length; i++) {
        final o = widget.doctorInfo!.doctorSpokenLanguage![i];
        final w = DetailContent(text: o.spokenLanguage ?? '');
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
        'Languages Spoken',
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.bold,
          color: Color(0xFF247CA1),
        ),
      ),
      iconColor: const Color(0xFF247CA1),
      collapsedIconColor: const Color(0xFF247CA1),
      children: buildLanguageList(),
      onExpansionChanged: (bool expanded) {
        setState(() => isLanguageExpanded = expanded);
      },
    );
  }
}