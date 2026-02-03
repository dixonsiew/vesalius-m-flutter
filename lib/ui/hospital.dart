import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/constants.dart';

class Hospital extends StatelessWidget {

  static final String routeName = 'Hospital';

  Widget ourStoryContent(String title, String content) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 18.0, bottom: 5.0),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
            child: Text(
              content,
              style: TextStyle(
                height: 1.5,
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        gradient: LinearGradient(
          colors: [Color.fromRGBO(0, 0, 0, 0.3), Color.fromRGBO(0, 0, 0, 0.3)],
        ),
        color: Colors.grey,
      ),
    );
  }

  Widget buildVision() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child:  Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 18.0, bottom: 5.0),
              child: Text(
                'Vision, Mission & Values',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
              child: Text(
                'Vision',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
              child: Text(
                'To be the hospital of choice for cardiac, cardiothoracic and vascular care in Malaysia and the region.',
                style: TextStyle(
                  height: 1.5,
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
              child: Text(
                'Mission',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                'At CVSKL, the three pillars of our mission govern the way we live:',
                style: TextStyle(
                  height: 1.5,
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Text(
                '- To build a partnership of leaders in cardiovascular medicine',
                style: TextStyle(
                  height: 1.5,
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Text(
                '- To provide the best patient experience and outcome for every patient every time',
                style: TextStyle(
                  height: 1.5,
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Text(
                '- To provide the best environment to work and practice medicine for our staff',
                style: TextStyle(
                  height: 1.5,
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
              child: Text(
                'Values',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                'CVSKL’s culture is shaped by five core values, known as EQUIP, shared among everyone within the organisation. The core values establish the foundation for decision-making, actions and a sense of community in both our personal and professional lives. We seek to create a workforce that is continuously aligned with the values, resulting in creating pleasurable patient experiences.',
                style: TextStyle(
                  height: 1.5,
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 40.0, right: 10.0, top: 15.0),
              child: Text(
                'Excellence',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 40.0, right: 10.0, top: 10.0),
              child: Text(
                'We lead by example, rising above the ordinary through personal effort and those of the team.',
                style: TextStyle(
                  height: 1.5,
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 40.0, right: 10.0, top: 15.0),
              child: Text(
                'Quality',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 40.0, right: 10.0, top: 10.0),
              child: Text(
                'We continually strive to improve the care of our patients to ensure quality and safety.',
                style: TextStyle(
                  height: 1.5,
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 40.0, right: 10.0, top: 15.0),
              child: Text(
                'Unity',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 40.0, right: 10.0, top: 10.0),
              child: Text(
                'We work together with the spirit of active participation and individual initiative.',
                style: TextStyle(
                  height: 1.5,
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 40.0, right: 10.0, top: 15.0),
              child: Text(
                'Integrity',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 40.0, right: 10.0, top: 10.0),
              child: Text(
                'We conduct ourselves in a fair and trustworthy manner, and uphold professional and ethical standards.',
                style: TextStyle(
                  height: 1.5,
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 40.0, right: 10.0, top: 15.0),
              child: Text(
                'Patient Centered',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 40.0, right: 10.0, top: 10.0, bottom: 20.0),
              child: Text(
                'We focus on the patient and their family, with their best interests, comfort and well-being as our utmost priority.',
                style: TextStyle(
                  height: 1.5,
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          gradient: LinearGradient(
            colors: [Color.fromRGBO(0, 0, 0, 0.3), Color.fromRGBO(0, 0, 0, 0.3)],
          ),
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget buildOurStory() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: ourStoryContent('Our Story',
'''Cardiac Vascular Sentral Kuala Lumpur (CVSKL) is an integrated cardiac and vascular hospital that opened its doors in November 2017. Specialising in comprehensive modern care for patients with cardiac and vascular diseases, CVSKL is backed by a sterling track record of achievements and expertise. Our hand-picked team of dedicated specialists ensures the highest standards of evidence-based and professional care.
Comprising of a 60-bedded hospital equipped with modern facilities, CVSKL houses a full range of cardiology, cardiothoracic and vascular diagnostic, therapeutic and preventive services. Situated in the transportation hub of the city, Kuala Lumpur Sentral offers unparalleled accessibility by LRT, MRT, train, bus, taxi or KLIA Ekspres within the city’s thriving heart. For added convenience, visitors can find within walking distance a wealth of hotels, service apartments and a shopping mall.
Strengthened by 6 centres of excellence: the cardiac diagnostics centre, arrhythmia programme, heart and lung centre, structural heart programme, vascular and endovascular centre and, CHIP programme it is aimed at making CVSKL the dedicated centre of excellence for your heart.
Having all this expertise in a single place — focused on you — means that you are not just getting one opinion. In CVSKL, specialists work together for you.'''
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      height: 120.0,
      color: kSearchHospitalBgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Container(
              width: 80.0,
              height: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: AssetImage('images/icon/page-header-icon/search-hospital.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Text(
              'View Hospital Information',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kSearchHospitalBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: BackBtn(color: Colors.white),
        elevation: 0.0,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Scrollbar(
          child: ListView(
            shrinkWrap: true,
            children: [
              buildHeader(),
              buildOurStory(),
              buildVision(),
            ],
          ),
        ),
      ),
    );
  }
}