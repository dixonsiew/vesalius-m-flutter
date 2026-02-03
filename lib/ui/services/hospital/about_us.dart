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
              '''Metro Specialist Hospital was established in 1993 with a humble beginning, featuring 60 beds and a dedicated team of 4 specialists. Over the years, it has evolved to become a vital healthcare institution in our community.

A significant milestone in our journey occurred on the 19th of October 2002 when we moved into our new, state-of-art premises. This move allowed us to expand our capacity to 120 beds and added an impressive roster of 29 specialists along with 3 medical officers. It marked a significant leap forward in our commitment to provide top-quality healthcare services to our patients.

In 2018, we further improved our facilities by completing a new car park, showcasing our dedication for the convenience of our patients and visitors. This car park boasts an impressive capacity of 333 parking lots for cars and 350 for motorcycles, including dedicated parking bays for 3 buses.

Continuing our mission to offer cutting-edge healthcare, we proudly initiated the ground-breaking ceremony for a new modern block on the 7th August 2023. This block will be a 7 –storey building, equipped with over 200 beds, ensuring that MSH can continue to meet the growing healthcare needs of our community.

We are committed to our vision of providing compassionate and quality healthcare services, and we look forward to serving the community for many many more years to come.

''', style: kTextStyle1.copyWith(
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
      title: 'About Metro Hospital',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}