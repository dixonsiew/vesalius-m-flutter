import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class OurStory extends StatelessWidget {
  
  static const String routeName = '/OurStory';

  const OurStory({super.key});

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Scrollbar(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
                  child: Text(
                    '''
    The desire/intention to establish a medical faculty in Universiti Sains Malaysia has existed as early as April 1974 but the plan was delayed until it was officially announced in early 1979 by the Deputy Prime Minister at that time.  The project was then named the medical complex project.

    In accordance with that decision, the government has decided that a complex for the School of Medical Sciences to be built at Kubang Kerian and a hospital that was under construction since 1977, by the Ministry of Health was taken over by USM. The hospital that cost RM29.5 million was then established as a teaching hospital. Since then, USM has expedite the construction work as well as hastened the acquisition of 72.84 hectare (180 per square acre)  of the land area that has been provided by the Kelantan state government for the establishment of a medical complex.

    During the era of the Third Malaysia Plan and Fourth Malaysia Plan, the focus for the development of PKP was constructing the hospital building which completed in 1993. At the same time, auxiliary/support buildings for example, nursing/intern doctor’s hostel, medical students’ hostels L/Block 1, students’ cafeteria, medical library, Jerteh general hospital’s medical students’ hostels, games court, desa rakyat, HUSM central store, students’ hostels L/Block 2, students center and multipurpose hall were also constructed.

    In addition, a few houses had also been purchased for staff’s accommodation. The total units of houses acquired were:

    -42 units of single storey terrace at Pasir Tumboh

    -10 units of double storey terrace at Pengkalan Chepa

    -15 units of single storey bungalow at Pasir Tumboh

    -43 units of double storey terrace at Pasir Tumboh

    During the Fifth Malaysia Plan, development project progressed rapidly with the construction of few other buildings.  The buildings constructed during that time were animal house, sports complex, Desa Murni, the School of Medical Sciences including the  administration block, lecture halls, multipurpose laboratories, tutorial rooms and cafeteria.

    Development project during the Sixth Malaysia Plan was a bit slow-moving due to financial constraints. Only block  11 and block 31 were built during that period.

    However, development projects continued to progress  during the Seventh Malaysia Plan and many other buildings were also built. The buildings built at that time were the School of Health Sciences (PPSK), School of Dental Sciences (PPSG), students’ hostel that can accommodate 100 students, multipurpose hall, Students’ Affair office, USM prayer hall, lecture halls, clinical skills laboratories, guest house, block 9 PPSP, MTD building, Registrar and Development department.

    Unfortunately during the Eighth Malaysia Plan, further development had to be put on hold as no allocation was approved for USM and development was continued in the Ninth Malaysia Plan.

    The planning of the development of USM Hospital and medical complex was done by international experienced professionals in the field of Health Care Design .
                    ''',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor1,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppElevatedButton(
              text: 'Read More',
              onPressed: () {
                // Get.to(() => const ExternalHospital());
                // await launch(
                //   'https://www.islandhospital.com/en/about-us',
                //   forceSafariVC: true,
                //   forceWebView: true,
                //   enableJavaScript: true,
                // );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Our Story',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}