import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class AboutUs extends StatefulWidget {

  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

  ScrollController scr = ScrollController();

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  Widget buildContent() {
    return Scrollbar(
      controller: scr,
      child: ListView(
        controller: scr,
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
            child: Text(
              'Giving you another chance for a better life',
              style: kTextStyle1.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: kTextColor1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              '''Island Hospital, founded in 1996, is a 600-bed hospital located in Penang, Malaysia. The hospital is recognised as one of the leading healthcare providers in Malaysia, serving patients from around the region. Island Hospital offers a wide range of healthcare services and is committed to providing best-in-class care to deliver care in the best interest of the patient and “to comfort always.”

Island Hospital has over 70 full-time specialists across 9 Centres of Excellence, offering a wide range of treatment services that are supported by cutting-edge medical equipment and technology. The hospital’s specialists are highly experienced and renowned in their dedicated fields, with at least 25 years of practice and international exposure in their medical careers.

Its commitment to providing excellent patient care has earned it recognition as one of the best hospitals in its class. As part of its ongoing efforts to improve the quality of care it provides, Island Hospital has expanded its services to aim towards becoming a Regional Quaternary Care hospital. This expansion has allowed it to offer patients an advanced level of specialised and niche treatments.

As a testament to its dedication to providing high-quality healthcare services, Island Hospital was shortlisted by the Malaysia Healthcare Travel Council (MHTC) as the only hospital in Penang in the Flagship Medical Tourism Hospital Programme.

The Flagship Medical Tourism Hospital Programme is an innovative initiative that aims to establish new standards in global healthcare travel, spearheaded by the Malaysia Healthcare Travel Council (MHTC) in 2022. Fully endorsed by the Government of Malaysia and the Ministry of Health, this collaborative effort with international bodies IQVIA and Joint Commission International (JCI) aims to position Malaysia as a globally renowned icon for healthcare travel, delivering exceptional end-to-end patient experiences anchored on medical and service excellence best practices and international branding. The programme is a critical component of the five-year Malaysia Healthcare Travel Industry blueprint, which seeks to provide the Best Malaysia Healthcare Travel Experience by 2025.''',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor1,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'About Island Hospital',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}