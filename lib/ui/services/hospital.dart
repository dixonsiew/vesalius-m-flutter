import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/ui/services/hospital/fmth.dart';

import 'hospital/about_us.dart';
import 'hospital/award.dart';
import 'hospital/contact_us.dart';

class Hospital extends StatefulWidget {

  const Hospital({super.key});

  @override
  State<Hospital> createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {

  ScrollController scr = ScrollController();

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  Widget buildContent(BuildContext context) {
    return Scrollbar(
      controller: scr,
      child: ListView(
        controller: scr,
        shrinkWrap: true,
        children: [
          const SizedBox(height: 32.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                Expanded(
                  child: HospitalItem(
                    image: 'about-us.png',
                    title: 'About Us\n',
                    width: 32.0,
                    height: 32.0,
                    onTap: () {
                      Get.to(() => const AboutUs());
                    },
                  ),
                ),
                const SizedBox(width: 27.0),
                Expanded(
                  child: HospitalItem(
                    image: 'contact-us.png',
                    title: 'Contact Us\n',
                    onTap: () {
                      Get.to(() => const ContactUs());
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                Expanded(
                  child: HospitalItemX(
                    image: 'flagship.png',
                    title: 'Flagship Medical\nTourism Hospital',
                    onTap: () {
                      Get.to(() => const FMTH());
                    },
                  ),
                ),
                const SizedBox(width: 27.0),
                Expanded(
                  child: HospitalItem(
                    image: 'award.png',
                    title: 'Awards &\nAccreditation',
                    onTap: () {
                      Get.to(() => const Award());
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Hospital Information',
      body: SafeArea(
        child: buildContent(context),
      ),
    );
  }
}

class HospitalItem extends StatelessWidget {

  final String image;
  final String title;
  final double width;
  final double height;
  final void Function() onTap;

  const HospitalItem({
    super.key,
    required this.image,
    required this.title,
    this.width = 24.0,
    this.height = 24.0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: const Color(0xFFDADADA).withValues(alpha: 0.35),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFF5394A6),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/imgs/$image',
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  title,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HospitalItemX extends StatelessWidget {

  final String image;
  final String title;
  final void Function() onTap;

  const HospitalItemX({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: const Color(0xFFDADADA).withValues(alpha: 0.35),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/imgs/$image',
                  width: 104.0,
                  height: 47.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 15.0),
                Text(
                  title,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}