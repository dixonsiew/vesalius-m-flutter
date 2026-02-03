import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class BypassSurveryOverview extends StatelessWidget {
  const BypassSurveryOverview({super.key});

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0, 
                  vertical: 16.0,
                ),
                child: Text(
                  'Bypass Surgery Overview',
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
Coronary artery bypass graft surgery, also known as CABG or bypass surgery, can help to restore blood flow to an area of the heart. However, surgery does not stop the progression of atherosclerosis (coronary heart disease), which deposits fatty material into artery walls, narrowing them and eventually limiting blood flow at other sites in the bypassed arteries or in previously normal coronary arteries.

Patients and healthcare providers must work together after surgery to treat the underlying atherosclerosis and the factors that can cause progression of heart disease. (See 'Reduce cardiac risk factors' below.)

This topic review discusses treatments that are recommended after coronary artery bypass graft surgery. These treatments can help to:

●Reduce the risk of developing complications of coronary heart disease, including having a subsequent heart attack or dying.

●Help a person to feel better and have more energy.

An overview of coronary artery bypass graft surgery is discussed in detail separately. (See "Patient education: Coronary artery bypass graft surgery (Beyond the Basics)".)
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
