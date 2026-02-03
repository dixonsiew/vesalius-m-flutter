import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

class DoctorQualificationContent extends StatelessWidget {

  final DoctorInfo? doctorInfo;
  final DoctorQualificationContentCtrl ctrl = Get.put(DoctorQualificationContentCtrl());

  DoctorQualificationContent({
    super.key,
    required this.doctorInfo,
  });

  List<Widget> buildQualificationList() {
    List<Widget> ls = [];
    
    if (doctorInfo != null && doctorInfo!.doctorQualifications.isNotEmpty) {
      for (int i = 0; i < doctorInfo!.doctorQualifications.length; i++) {
        final o = doctorInfo!.doctorQualifications[i];
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
        ls.addAll([
          w,
          const SizedBox(height: 10.0),
        ]);
      }

      ls.add(const SizedBox(height: 10.0));
    }

    return ls;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Obx(() =>
        Text(
          'Qualifications',
          style: kTextStyle1.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: ctrl.isExpanded ? kTextColor1 : kTextColor2,
          ),
        ),
      ),
      iconColor: kTextColor1,
      collapsedIconColor: kTextColor2,
      children: buildQualificationList(),
      onExpansionChanged: (bool expanded) {
        ctrl.setIsExpanded(expanded);
      },
    );
  }
}

class DoctorQualificationContentCtrl extends GetxController {

  final _isExpanded = false.obs;

  void setIsExpanded(bool b) {
    _isExpanded.value = b;
  }

  bool get isExpanded => _isExpanded.value;
}