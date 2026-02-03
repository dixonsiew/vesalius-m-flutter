import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

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
        final w = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  o.qualification ?? '',
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
        ls.add(w);
        ls.add(const SizedBox(height: 10.0));
      }

      ls.add(const SizedBox(height: 10.0));
    }

    return ls;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        'Qualifications',
        style: kTextStyle1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: isQualificationExpanded ? kTextColor1 : kTextColor2,
        ),
      ),
      iconColor: kTextColor1,
      collapsedIconColor: kTextColor2,
      children: buildQualificationList(),
      onExpansionChanged: (bool expanded) {
        setState(() => isQualificationExpanded = expanded);
      },
    );
  }
}