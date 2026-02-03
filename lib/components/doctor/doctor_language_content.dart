import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

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
    List<String> lx = [];

    if (widget.doctorInfo != null && widget.doctorInfo!.doctorSpokenLanguage != null && widget.doctorInfo!.doctorSpokenLanguage!.isNotEmpty) {
      for (int i = 0; i < widget.doctorInfo!.doctorSpokenLanguage!.length; i++) {
        final o = widget.doctorInfo!.doctorSpokenLanguage![i];
        if (o.spokenLanguage != null && o.spokenLanguage != '') {
          lx.add(o.spokenLanguage!);
        }
      }
    }

    String s = lx.isEmpty ? '' : lx.join(', ');
    if (s.isNotEmpty) {
      final w = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                s,
                style: kTextStyle1.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor4,
                ),
              ),
            ),
          ],
        ),
      );
      ls.addAll([
        w,
        const SizedBox(height: 20.0),
      ]);
    }

    return ls;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        'Languages Spoken',
        style: kTextStyle1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: isLanguageExpanded ? kTextColor1 : kTextColor2,
        ),
      ),
      iconColor: kTextColor1,
      collapsedIconColor: kTextColor2,
      children: buildLanguageList(),
      onExpansionChanged: (bool expanded) {
        setState(() => isLanguageExpanded = expanded);
      },
    );
  }
}