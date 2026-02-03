import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class WoundCare extends StatelessWidget {
  const WoundCare({super.key});

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
                  'Wound Care',
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
After discharge from the hospital, the patient is usually given instructions about how to care for their chest and/or leg wounds. It is important to follow these instructions closely and to notify a healthcare provider immediately if there are questions or concerns.

● Avoid heavy lifting and extremes of shoulder movement (eg, as in tennis, baseball, and golf) for six to eight weeks after surgery to allow for complete healing of the breast bone (sternum)
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
