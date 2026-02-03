import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/ui/appointment/new_appointment.dart';
import 'package:vesalius_m_flutter/ui/doctor/doctor_detail.dart';

class DoctorItem extends StatelessWidget {
  
  const DoctorItem({
    Key? key, 
    required this.data,
    required this.isBookmarked,
    required this.onToggleBookmark,
  }) : super(key: key);

  final DoctorInfo data;
  final bool isBookmarked;
  final Future<void> Function(bool, String, DoctorInfo) onToggleBookmark;

  List<Widget> buildDoctorContent(BuildContext context, DoctorInfo o) {
    List<DoctorSpecialities>? specialtyList = o.doctorSpecialities;

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

    if (specialtyList != null) {
      for (int i = 0; i < specialtyList.length; i++) {
        Widget w = Text(
          specialtyList[i].specialities!,
          style: kTextStyle1.copyWith(
            fontSize: 10.0,
            fontWeight: FontWeight.w400,
            color: kTextColor4,
          ),
        );
        ls.add(w);
        ls.add(const SizedBox(height: 5.0));
      }
    }

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
          'Room 212, Level 2',
          style: kTextStyle1.copyWith(
            fontSize: 10.0,
            fontWeight: FontWeight.w400,
            color: kTextColor4,
          ),
        ),
      ],
    );
    ls.add(l);

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

  ImageProvider<Object> getDoctorImage(DoctorInfo o) {
    String? image = o.image;
    ImageProvider<Object> im = const AssetImage('images/imgs/no_image.png');
    if (image != null && image != '') {
      int i = image.indexOf('base64,');
      String data = image;
      if (i < 0) {
        data = image.trim();
      }

      else {
        data = image.substring(i + 7).trim();
      }
      im = MemoryImage(
        base64Decode(data),
      );
    }

    return im;
  }

  List<Widget> buildContents(BuildContext context) {
    String mcr = data.mcr!;

    List<Widget> ls = [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 64.0,
                  height: 64.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: getDoctorImage(data),
                      fit: BoxFit.cover,
                    ),
                  ),
                  margin: const EdgeInsets.only(top: 17.0),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: buildDoctorContent(context, data),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark_sharp : Icons.bookmark_outline_sharp,
              color: kMainColor,
            ),
            onPressed: () async {
              await onToggleBookmark(isBookmarked, mcr, data);
            },
          ),
        ],
      ),
    ];

    if (AuthManager.isLogin) {
      final r = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: OutlinedButton(
              onPressed: () {
          
              }, 
              style: OutlinedButton.styleFrom(
                foregroundColor: kMainColor,
                backgroundColor: Colors.white,
                minimumSize: const Size(80.0, 32.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                side: const BorderSide(
                  color: kMainColor,
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
                      color: kMainColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => NewAppointment(doctorInfo: data));
              },
              style: ElevatedButton.styleFrom(
                elevation: 5.0,
                backgroundColor: kMainColor,
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
            ),
          ),
        ],
      );
      final p = Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: r,
      );
      ls.add(p);
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
            padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildContents(context),
            ),
          ),
        ),
      ),
    );
  }
}