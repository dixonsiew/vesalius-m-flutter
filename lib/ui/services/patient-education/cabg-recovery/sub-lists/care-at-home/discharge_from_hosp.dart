import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class DischargeFromTheHospital extends StatefulWidget {

  const DischargeFromTheHospital({super.key});

  @override
  State<DischargeFromTheHospital> createState() => _DischargeFromTheHospitalState();
}

class _DischargeFromTheHospitalState extends State<DischargeFromTheHospital> {

  ScrollController scr = ScrollController();

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }
  
  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: ListView(
            controller: scr,
            shrinkWrap: true,
            children: [
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0, 
                  vertical: 16.0,
                ),
                child: Text(
                  'Discharge From The Hospital',
                  style: kTextStyle1.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: kTextColor1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0, 
                ),
                child: Text(
                  '''
Patients with an uncomplicated CABG usually go home after about five days in the hospital. In some cases, the hospital stay is longer. If complications have occurred, discharge is delayed until the person's condition is stable.

Before leaving the hospital, it is important for the patient and family to participate in and understand the discharge plan. Make sure all questions are answered and obtain written directions for how to take all medications (new and old). After bypass surgery, it is common to start new medications and stop or adjust the doses of previous medications.
                  ''',
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: '',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}
