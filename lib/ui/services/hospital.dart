import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/ui/services/hospital/our_story.dart';
import 'package:vesalius_m_flutter/ui/services/hospital/our_team.dart';
import 'package:vesalius_m_flutter/ui/services/hospital/vision.dart';

class Hospital extends StatelessWidget {

  static const String routeName = '/Hospital';

  const Hospital({super.key});

  Widget buildContent(BuildContext context) {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 32.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                Expanded(
                  child: HospitalItem(
                    image: 'our-story.png',
                    title: 'Our Story\n',
                    onTap: () {
                      Get.to(() => const OurStory());
                    },
                  ),
                ),
                const SizedBox(width: 27.0),
                Expanded(
                  child: HospitalItem(
                    image: 'vision.png',
                    title: 'Vision, Mission\n& Values',
                    onTap: () {
                      Get.to(() => const Vision());
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
                  child: HospitalItem(
                    image: 'team.png',
                    title: 'Our Team\n',
                    onTap: () {
                      Get.to(() => const OurTeam());
                    },
                  ),
                ),
                const SizedBox(width: 27.0),
                Expanded(
                  child: HospitalItem(
                    image: 'award.png',
                    title: 'Accreditation &\nAwards',
                    onTap: () {
                      
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
  final void Function() onTap;

  const HospitalItem({
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
            color: const Color(0xFFDADADA).withOpacity(0.35),
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
                  width: 48.0,
                  height: 48.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 18.0),
                Text(
                  title,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
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