import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/select_patient_ctrl.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/ui/appointment/new_appointment.dart';

class SelectPatient extends StatelessWidget {

  final DoctorInfo doctorInfo;
  final bool isEdit;
  final SelectPatientCtrl ctrl = Get.put(SelectPatientCtrl());
  final List<PatientRef> list = [
    PatientRef(id: 0, first: 'E', name: 'Abu bin Ahmad', type: 'Self'),
    PatientRef(id: 1, first: 'R', name: 'Raja Abu bin Ahmad', type: 'Father'),
    PatientRef(id: 2, first: 'N', name: 'Nadia binti Mohammad', type: 'Spouse'),
    PatientRef(id: 3, first: 'A', name: 'Alia binti Abu', type: 'Daughter'),
  ];

  SelectPatient({
    super.key,
    required this.doctorInfo,
    this.isEdit = false,
  });

  void onNext() {
    if (isEdit) {
      Get.back();
    }

    else {
      Get.to(() => NewAppointment(doctorInfo: doctorInfo));
    }
  }

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 144.0),
          child: Scrollbar(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 24.0),
                  Text(
                    'Who is this appointment for?',
                    style: kTextStyle1.copyWith(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  for (int i = 0; i < list.length; i++) ...[
                    PatientItem(name: list[i].name, type: list[i].type, first: list[i].first),
                  ],
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() =>
                  AppElevatedButton(
                    text: 'Next',
                    onPressed: ctrl.name.isEmpty ? null : onNext,
                  ),
                ),
                const SizedBox(height: 16.0),
                AppOutlinedButton(
                  text: 'Cancel',
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
        ),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Select Patient',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class PatientItem extends StatelessWidget {

  final String name;
  final String type;
  final String first;

  final SelectPatientCtrl ctrl = Get.put(SelectPatientCtrl());

  PatientItem({
    super.key,
    required this.name,
    required this.type,
    required this.first,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
      Container(
        margin: const EdgeInsets.only(bottom: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: ctrl.name == name ? kTextColor1 : const Color(0xFFDBDBDB).withOpacity(0.45)),
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
            onTap: () {
              ctrl.setName(name);
            },
            borderRadius: BorderRadius.circular(5.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F2FF),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Text(
                        first,
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: kTextColor1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        type,
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}