import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

class DoctorContactContent extends StatefulWidget {

  final DoctorInfo? doctorInfo;

  const DoctorContactContent({
    Key? key,
    required this.doctorInfo,
  }) : super(key: key);

  @override
  State<DoctorContactContent> createState() => _DoctorContactContentState();
}

class _DoctorContactContentState extends State<DoctorContactContent> {

  bool isContactExpanded = false;

  void launchAction(DoctorContact o) async {
    String s = o.contactType == 'Contact No' ? 'tel' : 'mailto';
    String? v = o.contactValue;
    if (o.contactType == 'Contact No') {
      v = o.contactValue?.replaceWhitespacesUsingRegex('');
    }

    String url = '$s:$v';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }

    else {
      await showCustomDialog('Failed', 'Unable to launch contact: ${o.contactValue}', 'Dismiss');
    }
  }

  List<Widget> buildContactList() {
    List<Widget> ls = [];

    if (widget.doctorInfo != null && widget.doctorInfo!.doctorContact != null && widget.doctorInfo!.doctorContact!.isNotEmpty) {
      for (int i = 0; i < widget.doctorInfo!.doctorContact!.length; i++) {
        final o = widget.doctorInfo!.doctorContact![i];
        final w = InkWell(
          onTap: () {
            launchAction(o);
          },
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
      title: Text(
        'Contact Information',
        style: kTextStyle1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: isContactExpanded ? kTextColor1 : kTextColor2,
        ),
      ),
      iconColor: kTextColor1,
      collapsedIconColor: kTextColor2,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      onExpansionChanged: (bool expanded) {
        setState(() => isContactExpanded = expanded);
      },
      children: buildContactList(),
    );
  }
}