import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/models/patient-data.dart';
import 'package:vesalius_m_flutter/helpers.dart';

class MedicalInfo extends StatelessWidget {

  final PatientVisit patientVisit;

  MedicalInfo({
    @required this.patientVisit,
  });

  String getRegistrationTime() {
    String t = patientVisit.novaVisit.registrationTime;
    if (t == null || t == '') {
      return 'NA';
    }

    var a = t.split(':');
    int hour = int.parse(a[0]);
    int min = int.parse(a[1]);
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, min);
    return formatDate(dt, [h, ':', nn, ' ', am]);
  }

  String getRegistrationDate() {
    DateTime dt = DateTime.parse(patientVisit.novaVisit.registrationDate);
    return formatDate(dt.toLocal(), [dd, ' ', M, ' ', yyyy]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFD6D6D6),
          ),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color.fromRGBO(191, 191, 191, 1),
            offset: Offset(0, 2),
            blurRadius: 7.0,
            spreadRadius: -1,
          ),
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 15.0),
                  child: Text(
                    'Registration Date',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Text(
                    'Registration Time',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 15.0),
                  child: Text(
                    getRegistrationDate(),
                    style: TextStyle(
                      color: Color(0xFF777777),
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Text(
                    getRegistrationTime(),
                    style: TextStyle(
                      color: Color(0xFF777777),
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 30.0, left: 15.0),
                  child: Text(
                    'Visit Type',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Text(
                    'Primary Doctor',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 20.0, left: 15.0),
                  child: Text(
                    '${patientVisit.novaVisit.visitType.titleCase()} (${patientVisit.novaVisit.caseType.titleCase()})',
                    style: TextStyle(
                      color: Color(0xFF777777),
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
                  child: Text(
                    patientVisit.novaVisit.primaryDoctor,
                    style: TextStyle(
                      color: Color(0xFF777777),
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}