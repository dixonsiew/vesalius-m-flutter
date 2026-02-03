import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

class DoctorLanguageContent extends StatelessWidget {

  final DoctorInfo? doctorInfo;
  final DoctorLanguageContentCtrl ctrl = Get.put(DoctorLanguageContentCtrl());

  DoctorLanguageContent({
    super.key,
    required this.doctorInfo,
  });

  List<Widget> buildLanguageList() {
    List<Widget> ls = [];

    if (doctorInfo != null && doctorInfo!.doctorSpokenLanguage.isNotEmpty) {
      for (int i = 0; i < doctorInfo!.doctorSpokenLanguage.length; i++) {
        final o = doctorInfo!.doctorSpokenLanguage[i];
        final w = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  o.spokenLanguage ?? '',
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
        ls.addAll([w, const SizedBox(height: 10.0)]);
      }

      ls.add(const SizedBox(height: 10.0));
    }

    return ls;
  }

  @override
  Widget build(BuildContext context) {
    if (doctorInfo?.doctorSpokenLanguage.isEmpty ?? true) {
      return Container();
    }

    return ExpansionTile(
      title: Obx(() =>
        Text(
          'Languages Spoken',
          style: kTextStyle1.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: ctrl.isExpanded ? kPrimaryColor : kTextColor2,
          ),
        ),
      ),
      iconColor: kTextColor1,
      collapsedIconColor: kTextColor2,
      initiallyExpanded: ctrl.isExpanded,
      children: buildLanguageList(),
      onExpansionChanged: (bool expanded) {
        ctrl.setIsExpanded(expanded);
      },
    );
  }
}

class DoctorLanguageContentCtrl extends GetxController {

  final _isExpanded = true.obs;

  void setIsExpanded(bool b) {
    _isExpanded.value = b;
  }

  bool get isExpanded => _isExpanded.value;
}