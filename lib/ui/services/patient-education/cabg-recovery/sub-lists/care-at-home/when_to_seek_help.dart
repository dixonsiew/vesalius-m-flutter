import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class WhenToSeekHelp extends StatefulWidget {

  const WhenToSeekHelp({super.key});

  @override
  State<WhenToSeekHelp> createState() => _WhenToSeekHelpState();
}

class _WhenToSeekHelpState extends State<WhenToSeekHelp> {

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
                  'When To Seek Help',
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
If the patient develops any of the following signs or symptoms of wound infection, a healthcare provider should be contacted immediately. Most wound infections develop within 14 days of the surgery.

● Fever greater than 100.4º F (38º C)

● New or worsened pain in the chest or around the incision

● A rapid heart rate

● Reddened skin, bleeding or pus-like drainage from the incision
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
