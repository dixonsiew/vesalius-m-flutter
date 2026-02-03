import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/ui/hospital/external_hospital.dart';

class OurStory extends StatelessWidget {
  
  static const String routeName = '/OurStory';

  const OurStory({Key? key}) : super(key: key);

  Widget buildContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '''
Based in Penang, Malaysia and founded in 1996, Island Hospital is a 300-bed hospital and one of the leading tertiary care providers in Malaysia. Island Hospital has over 50 full-time specialists across 9 Centres of Excellence.

At Island Hospital, patients have access to some of the most highly respected specialists in Malaysia, most of which have been trained in the United Kingdom, United States of America, and Australia. Our specialists are highly experienced and renowned in their dedicated fields and are supported by a dedicated team of nursing and allied health staff.

Besides boasting a stellar team of medical professionals, Island Hospital offers a wide range of treatment services that are supported by advanced medical equipment and technology, including the HD 3D Tomosynthesis Mammography, 3 Tesla MRI, Fibroscan for liver diagnosis, 3D Laparoscopic Surgery, Anti-Gravity Treadmill, and an exceptionally modern Laboratory Pathology Centre.

Our medical infrastructure allows us to offer services such as same-day results for health screening and other clinical investigations. We invite you to partner with our hospital in managing your medical concerns.
            ''',
            style: kBodyTextStyle.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 33.0, right: 33.0, bottom: 10.0),
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(ExternalHospital.routeName);
                // await launch(
                //   'https://www.islandhospital.com/en/about-us',
                //   forceSafariVC: true,
                //   forceWebView: true,
                //   enableJavaScript: true,
                // );
              },
              style: ElevatedButton.styleFrom(
                elevation: 5.0,
                backgroundColor: kMainColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
              ),
              child: Text(
                'Read More',
                style: kBodyTextStyle.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
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
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: const Color(0xFFF8F8F8),
        leading: const BackBtn(color: Color(0xFF002E50)),
        centerTitle: true,
        title: Text(
          'Our Story',
          style: kMainTextStyle.copyWith(
            fontSize: 16.0,
            color: const Color(0xFF002E50),
          ),
        ),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: buildContent(context),
          ),
        ),
      ),
    );
  }
}