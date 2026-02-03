import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/helpers.dart';

class MedicalInfo extends StatelessWidget {

  final PatientVisit patientVisit;

  const MedicalInfo({
    Key? key, 
    required this.patientVisit,
  }) : super(key: key);

  String get registrationTime {
    String? t = patientVisit.novaVisit?.registrationTime;
    if (t == null || t == '') {
      return 'NA';
    }

    List<String> a = t.split(':');
    int hour = int.parse(a[0]);
    int min = int.parse(a[1]);
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, min);
    return formatDate(dt, [h, ':', nn, ' ', am]);
  }

  String get registrationDate {
    DateTime dt = DateTime.parse(patientVisit.novaVisit!.registrationDate!);
    return formatDate(dt.toLocal(), [dd, ' ', M, ' ', yyyy]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
        color: kMainColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Registration Date',
                  style: kLabelTextStyle.copyWith(
                    fontSize: 10.0,
                    color: const Color.fromRGBO(255, 255, 255, 0.8),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Registration Time',
                  style: kLabelTextStyle.copyWith(
                    fontSize: 10.0,
                    color: const Color.fromRGBO(255, 255, 255, 0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  registrationDate,
                  style: kBodyTextStyle.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  registrationTime,
                  style: kBodyTextStyle.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Visit Type',
                  style: kLabelTextStyle.copyWith(
                    fontSize: 10.0,
                    color: const Color.fromRGBO(255, 255, 255, 0.8),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Primary Doctor',
                  style: kLabelTextStyle.copyWith(
                    fontSize: 10.0,
                    color: const Color.fromRGBO(255, 255, 255, 0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${patientVisit.novaVisit?.visitType?.titleCase()} (${patientVisit.novaVisit?.caseType?.titleCase()})',
                  style: kBodyTextStyle.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  patientVisit.novaVisit?.primaryDoctor ?? '',
                  style: kBodyTextStyle.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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