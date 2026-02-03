import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

class DoctorAvailabilityContent extends StatelessWidget {

  final DoctorInfo? doctorInfo;
  final DoctorAvailabilityContentCtrl ctrl = Get.put(DoctorAvailabilityContentCtrl());

  DoctorAvailabilityContent({
    super.key,
    required this.doctorInfo,
  });

  List<Widget> buildAvailabilityList() {
    List<Widget> ls = [];

    if (doctorInfo != null && doctorInfo!.doctorClinicHours.isNotEmpty) {
      for (int i = 0; i < doctorInfo!.doctorClinicHours.length; i++) {
        final o = doctorInfo!.doctorClinicHours[i];
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
        ls.addAll([
          w,
          const SizedBox(height: 10.0),
        ]);
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
      title: Obx(() =>
        Text(
          'Available Hours',
          style: kTextStyle1.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: ctrl.isExpanded ? kTextColor1 : kTextColor2,
          ),
        ),
      ),
      iconColor: kTextColor1,
      collapsedIconColor: kTextColor2,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      onExpansionChanged: (bool expanded) {
        ctrl.setIsExpanded(expanded);
      },
      children: buildAvailabilityList(),
    );
  }
}

class DoctorAvailabilityContentCtrl extends GetxController {

  final _isExpanded = false.obs;

  void setIsExpanded(bool b) {
    _isExpanded.value = b;
  }

  bool get isExpanded => _isExpanded.value;
}