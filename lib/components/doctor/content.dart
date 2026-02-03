import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/ui/appointment/add_appointment.dart';
import 'package:vesalius_m_flutter/ui/doctor/doctor_detail.dart';

class DoctorItem extends StatelessWidget {
  
  const DoctorItem({
    super.key, 
    required this.data,
    required this.isBookmarked,
    required this.onToggleBookmark,
  });

  final DoctorInfo data;
  final bool isBookmarked;
  final Future<void> Function(bool, String, DoctorInfo) onToggleBookmark;

  List<Widget> buildDoctorContent(BuildContext context, DoctorInfo o) {
    List<DoctorSpecialities>? specialtyList = o.doctorSpecialities;

    List<Widget> ls = [
      Text(
        '${o.name}'.trim(),
        style: const TextStyle(
          fontSize: 20.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8E9093),
        ),
      ),
    ];

    if (specialtyList != null) {
      for (int i = 0; i < specialtyList.length; i++) {
        Widget w = Text(
          specialtyList[i].specialities ?? '',
          style: const TextStyle(
            fontSize: 17.0,
            fontFamily: kBodyFont,
            color: Color(0xFF949494),
          ),
        );
        ls.add(w);
      }
    }

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
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    margin: EdgeInsets.only(top: data.image != null && data.image != '' ? 10.0 : 0.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: getDoctorImage(data),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                color: kSearchDoctorBgColor,
              ),
              onPressed: () async {
                await onToggleBookmark(isBookmarked, mcr, data);
              },
            ),
          ],
        ),
      ),
    ];

    if (AuthManager.isLogin) {
      ls.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DoctorDetail(mcr: mcr)));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF097099),
                    minimumSize: const Size(double.maxFinite, 50.0),
                    shape: const BeveledRectangleBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.list,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: kBodyFont,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 2.0,
                color: const Color(0xFFE0E0E0),
              ),
              Expanded(
                flex: 2,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddAppointment(doctorInfo: data)));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFC81E5D),
                    minimumSize: const Size(double.maxFinite, 50.0),
                    shape: const BeveledRectangleBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        'Make Appointment',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: kBodyFont,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      );
    }

    else {
      ls.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DoctorDetail(mcr: mcr),
                )
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF097099),
              minimumSize: const Size(double.maxFinite, 50.0),
              shape: const BeveledRectangleBorder(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.list,
                  color: Colors.white,
                ),
                SizedBox(width: 5.0),
                Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontFamily: kBodyFont,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        )
      );
    }

    return ls;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buildContents(context),
      ),
    );
  }

  Widget build000(BuildContext context) {
    String mcr = data.mcr!;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color.fromRGBO(224, 224, 224, 0.596),
          ),
          bottom: BorderSide(
            color: Color.fromRGBO(224, 224, 224, 0.599),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark_sharp : Icons.bookmark_outline_sharp,
                color: kSearchDoctorBgColor,
              ),
              onPressed: () async {
                await onToggleBookmark(isBookmarked, mcr, data);
              },
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: buildDoctorContent(context, data),
                ),
              ),
            ),
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: getDoctorImage(data),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}