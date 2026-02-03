import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

class DoctorAvailabilityContent extends StatefulWidget {

  final DoctorInfo? doctorInfo;

  const DoctorAvailabilityContent({
    Key? key,
    required this.doctorInfo,
  }) : super(key: key);

  @override
  State<DoctorAvailabilityContent> createState() => _DoctorAvailabilityContentState();
}

class _DoctorAvailabilityContentState extends State<DoctorAvailabilityContent> {

  bool isAvailabilityExpanded = false;

  List<Widget> buildAvailabilityList() {
    List<Widget> ls = [];

    if (widget.doctorInfo != null && widget.doctorInfo!.doctorClinicHours != null && widget.doctorInfo!.doctorClinicHours!.isNotEmpty) {
      for (int i = 0; i < widget.doctorInfo!.doctorClinicHours!.length; i++) {
        final o = widget.doctorInfo!.doctorClinicHours![i];
        String a = o.byAppointmentOnly ?? false ? '*' : '';
        String s = '${o.dayStartTime} - ${o.dayEndTime}$a';
        final w = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  o.dayOfTheWeek ?? '',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor4,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  s,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor4,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
        ls.add(w);
        ls.add(const SizedBox(height: 10.0));
      }

      ls.add(
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 20.0),
          child: Text(
            '*By Appointment Basis',
            style: kTextStyle1.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: kTextColor4,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return ls;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        'Available Hours',
        style: kTextStyle1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: isAvailabilityExpanded ? kTextColor1 : kTextColor2,
        ),
      ),
      iconColor: kTextColor1,
      collapsedIconColor: kTextColor2,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      onExpansionChanged: (bool expanded) {
        setState(() => isAvailabilityExpanded = expanded);
      },
      children: buildAvailabilityList(),
    );
  }
}