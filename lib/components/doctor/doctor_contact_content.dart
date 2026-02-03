import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

class DoctorContactContent extends StatelessWidget {

  final DoctorInfo? doctorInfo;
  final DoctorContactContentCtrl ctrl = Get.put(DoctorContactContentCtrl());

  DoctorContactContent({
    super.key,
    required this.doctorInfo,
  });

  List<Widget> buildContactList() {
    List<Widget> ls = [];

    if (doctorInfo != null && doctorInfo!.doctorContact.isNotEmpty) {
      for (int i = 0; i < doctorInfo!.doctorContact.length; i++) {
        final o = doctorInfo!.doctorContact[i];
        final w = InkWell(
          onTap: () => launchAction(o),
          child: Padding(
            padding: const EdgeInsets.only(left: 18, top: 10.0, bottom: 10.0),
            child: Row(
              children: [
                o.contactType == 'Contact No' ? Image.asset(
                  'images/icon/call1.png',
                  width: 16.0,
                  height: 16.0,
                  fit: BoxFit.cover,
                ) : Image.asset(
                  'images/icon/email.png',
                  width: 16.0,
                  height: 11.44,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    o.contactValue!,
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        ls.add(w);
      }
    }

    return ls;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Obx(() =>
        Text(
          'Contact Information',
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
      children: buildContactList(),
    );
  }
}

class DoctorContactContentCtrl extends GetxController {

  final _isExpanded = false.obs;

  void setIsExpanded(bool b) {
    _isExpanded.value = b;
  }

  bool get isExpanded => _isExpanded.value;
}