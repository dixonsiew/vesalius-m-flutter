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
          padding: const EdgeInsets.only(left: 10.0, top: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 5.0,
                height: 5.0,
                margin: const EdgeInsets.only(right: 15.0, top: 8.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
              ),
              Flexible(
                child: SizedBox(
                  width: 100.0,
                  child: Text(
                    o.dayOfTheWeek ?? '',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontFamily: kBodyFont,
                      color: Color(0xFF4B4B4B),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  s,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontFamily: kBodyFont,
                    color: Color(0xFF4B4B4B),
                  ),
                ),
              ),
            ],
          ),
        );
        ls.add(w);
      }

      ls.add(
        const Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 10.0),
          child: Text(
            '*By Appointment Basis',
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: kBodyFont,
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
      title: const Text(
        'Available Hours',
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.bold,
          color: Color(0xFF247CA1),
        ),
      ),
      iconColor: const Color(0xFF247CA1),
      collapsedIconColor: const Color(0xFF247CA1),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: buildAvailabilityList(),
      onExpansionChanged: (bool expanded) {
        setState(() => isAvailabilityExpanded = expanded);
      },
    );
  }
}