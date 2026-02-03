import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/doctor/doctor_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/ui/appointment/select_patient.dart';
import 'package:vesalius_m_flutter/ui/services/doctor/doctor_detail.dart';

class DoctorItem extends StatelessWidget {

  final DoctorInfo data;
  final Future<void> Function(bool, String, DoctorInfo) onToggleBookmark;

  final DoctorCtrl ctrl = Get.put(DoctorCtrl());
  
  DoctorItem({
    super.key, 
    required this.data,
    required this.onToggleBookmark,
  });

  List<Widget> buildDoctorContent(DoctorInfo o) {
    List<DoctorSpecialities> specialtyList = o.doctorSpecialities;
    List<DoctorClinicLocation> locationList = o.doctorClinicLocation;

    List<Widget> ls = [
      Text(
        '${o.name}'.trim(),
        style: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: kTextColor4,
        ),
      ),
      const SizedBox(height: 8.0),
    ];

    for (int i = 0; i < specialtyList.length; i++) {
      Widget w = Text(
        specialtyList[i].specialities ?? '',
        style: kTextStyle1.copyWith(
          fontSize: 10.0,
          fontWeight: FontWeight.w400,
          color: kTextColor4,
        ),
      );
      ls.addAll([
        w,
        const SizedBox(height: 5.0),
      ]);
    }

    if (locationList.isNotEmpty) {
      Widget l = Row(
        children: [
          Image.asset(
            'images/icon/location1.png',
            width: 10.0,
            height: 10.0,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8.0),
          Text(
            locationList.first.location ?? '',
            style: kTextStyle1.copyWith(
              fontSize: 10.0,
              fontWeight: FontWeight.w400,
              color: kTextColor4,
            ),
          ),
        ],
      );
      ls.add(l);
    }

    else {
      ls.removeLast();
    }

    // final r = Row(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Image.asset(
    //       'images/imgs/star.png',
    //       width: 8.0,
    //       height: 7.67,
    //       fit: BoxFit.cover,
    //     ),
    //     SizedBox(width: 4.0),
    //     Text(
    //       '4.9 (120 Reviews)',
    //       style: kBodyTextStyle.copyWith(
    //         fontSize: 10.0,
    //         fontWeight: FontWeight.w600,
    //         color: Color(0xFF4E4E4E),
    //       ),
    //     ),
    //   ],
    // );
    //ls.add(r);

    return ls;
  }

  Image getDoctorImage(DoctorInfo o) {
    String? image = o.image;
    Image im = Image.asset('images/imgs/no_image.png', fit: BoxFit.cover);
    if (image != null && image != '') {
      int i = image.indexOf('base64,');
      String data = image;
      if (i < 0) {
        data = image.trim();
      }

      else {
        data = image.substring(i + 7).trim();
      }
      im = Image.memory(
        base64Decode(data),
        fit: BoxFit.cover,
      );
    }

    return im;
  }

  List<Widget> buildContents() {
    String mcr = data.mcr!;
    List<DoctorContact> contactList = data.doctorContact;
    final List<DoctorContact> lc = contactList.where((x) => x.contactType == 'Contact No').toList();
    final contact = lc.isEmpty ? null : lc.first;

    List<Widget> ls = [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(32.0), // Image radius
                      child: getDoctorImage(data),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: buildDoctorContent(data),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await onToggleBookmark.call(ctrl.hasBookmarkedInfoId(mcr), mcr, data);
            },
            splashRadius: 24.0,
            icon: Obx(() => 
              Icon(
                ctrl.hasBookmarkedInfoId(mcr) ? Icons.bookmark_sharp : Icons.bookmark_outline_sharp,
                color: kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    ];

    final callBtn = OutlinedButton(
      onPressed: () {
        makePhoneCall(contact!);
      }, 
      style: OutlinedButton.styleFrom(
        foregroundColor: kPrimaryColor,
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 32.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        side: const BorderSide(
          color: kPrimaryColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/icon/call.png',
            width: 12.0,
            height: 12.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 6.0),
          Text(
            'Call',
            style: kTextStyle1.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );

    final makeApptBtn = ElevatedButton(
      onPressed: () {
        Get.to(() => SelectPatient(doctorInfo: data));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 32.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/icon/calendar.png',
            width: 12.0,
            height: 12.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 6.0),
          Text(
            'Make Appointment',
            style: kTextStyle1.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );

    if (AuthManager.isLogin) {
      if (data.allowAppointment == 'Y') {
        if (contact != null) {
          final r = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: callBtn,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                flex: 2,
                child: makeApptBtn,
              ),
            ],
          );
          ls.add(
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: r,
            ),
          );
        }

        else {
          ls.add(
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: makeApptBtn,
            ),
          );
        }
      }

      else {
        if (contact != null) {
          ls.add(
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: callBtn,
            ),
          );
        }
      }
    }

    else {
      if (contact != null) {
        ls.add(
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: callBtn,
          ),
        );
      }
    }

    return ls;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDBDBDB).withOpacity(0.3),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(5.0),
          onTap: () {
            Get.to(() => DoctorDetail(mcr: data.mcr!));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildContents(),
            ),
          ),
        ),
      ),
    );
  }
}