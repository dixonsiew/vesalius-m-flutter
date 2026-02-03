import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';

class Hospital extends StatelessWidget {

  const Hospital({super.key});

  Widget ourStoryContent(String title, String content) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        // gradient: LinearGradient(
        //   colors: [Color.fromRGBO(0, 0, 0, 0.3), Color.fromRGBO(0, 0, 0, 0.3)],
        // ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0, bottom: 5.0),
            child: Text(
              title,
              style: const TextStyle(
                color: kPrimaryColor3,
                fontSize: 24.0,
                fontFamily: kBodyFont,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
            child: Text(
              content,
              style: const TextStyle(
                color: kPrimaryColor3,
                fontSize: 14.0,
                fontFamily: kBodyFont,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVision() {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          // gradient: LinearGradient(
          //   colors: [Color.fromRGBO(0, 0, 0, 0.3), Color.fromRGBO(0, 0, 0, 0.3)],
          // ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 18.0, bottom: 5.0),
              child: Text(
                'Vision, Mission & Values',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 24.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
              child: const Text(
                'Vision',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
              child: const Text(
                'To be the hospital of choice for cardiac, cardiothoracic and vascular care in Malaysia and the region.',
                style: TextStyle(
                  height: 1.5,
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
              child: const Text(
                'Mission',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: const Text(
                'At CVSKL, the three pillars of our mission govern the way we live:',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 16.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: const Text(
                '- To build a partnership of leaders in cardiovascular medicine',
                style: TextStyle(
                  height: 1.5,
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: const Text(
                '- To provide the best patient experience and outcome for every patient every time',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: const Text(
                '- To provide the best environment to work and practice medicine for our staff',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
              child: const Text(
                'Values',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: const Text(
                'CVSKL’s culture is shaped by five core values, known as EQUIP, shared among everyone within the organisation. The core values establish the foundation for decision-making, actions and a sense of community in both our personal and professional lives. We seek to create a workforce that is continuously aligned with the values, resulting in creating pleasurable patient experiences.',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 40.0, right: 10.0, top: 15.0),
              child: const Text(
                'Excellence',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 40.0, right: 10.0, top: 10.0),
              child: const Text(
                'We lead by example, rising above the ordinary through personal effort and those of the team.',
                style: TextStyle(
                  height: 1.5,
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 40.0, right: 10.0, top: 15.0),
              child: const Text(
                'Quality',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 40.0, right: 10.0, top: 10.0),
              child: const Text(
                'We continually strive to improve the care of our patients to ensure quality and safety.',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 40.0, right: 10.0, top: 15.0),
              child: const Text(
                'Unity',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 40.0, right: 10.0, top: 10.0),
              child: const Text(
                'We work together with the spirit of active participation and individual initiative.',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 40.0, right: 10.0, top: 15.0),
              child: const Text(
                'Integrity',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 40.0, right: 10.0, top: 10.0),
              child: const Text(
                'We conduct ourselves in a fair and trustworthy manner, and uphold professional and ethical standards.',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 40.0, right: 10.0, top: 15.0),
              child: const Text(
                'Patient Centered',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 40.0, right: 10.0, top: 10.0, bottom: 20.0),
              child: const Text(
                'We focus on the patient and their family, with their best interests, comfort and well-being as our utmost priority.',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOurStory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: ourStoryContent('Our Story',
          '''Cardiac Vascular Sentral Kuala Lumpur (CVSKL) is an integrated cardiac and vascular hospital that opened its doors in November 2017. Specialising in comprehensive modern care for patients with cardiac and vascular diseases, CVSKL is backed by a sterling track record of achievements and expertise. Our hand-picked team of dedicated specialists ensures the highest standards of evidence-based and professional care.
Comprising of a 60-bedded hospital equipped with modern facilities, CVSKL houses a full range of cardiology, cardiothoracic and vascular diagnostic, therapeutic and preventive services. Situated in the transportation hub of the city, Kuala Lumpur Sentral offers unparalleled accessibility by LRT, MRT, train, bus, taxi or KLIA Ekspres within the city’s thriving heart. For added convenience, visitors can find within walking distance a wealth of hotels, service apartments and a shopping mall.
Driven by 6 COE programmes: cardiac diagnostics, arrhythmia programme, heart and lung, structural heart programme, vascular & endovascular and, CHIP (complex high-risk indicated procedures)  programme; it is aimed at amplifying CVSKL as the dedicated centre of excellence for cardiovascular care.
Having all this expertise in a single place — focused on you — means that you are not just getting one opinion. In CVSKL, specialists work together for you.'''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Hospital Information',
      body: SafeArea(
        child: Scrollbar(
          child: ListView(
            shrinkWrap: true,
            children: [
              buildOurStory(),
              buildVision(),
              Container(
                color: const Color(0xFFF5F5F5),
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: AppElevatedButton(
                  onPressed: () async {
                    // Navigator.pushNamed(context, ExternalHospital.routeName);
                    launchURL('https://www.cvskl.com/news-events-packages/e-bulletin/');
                  },
                  text: 'Click to view the latest updates',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
