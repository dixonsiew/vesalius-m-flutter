import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/kidsclub_image.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/kidsclub_data.dart';
import 'package:vesalius_m_flutter/ui/services/little-explorer/tnc.dart';

class AboutUs extends StatefulWidget {

  final KidsClub data;

  const AboutUs({
    super.key,
    required this.data,
  });

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

  void onSubmit() {
    Get.to(() => TnC(data: widget.data.kidsClubTnc, showAgree: true));
  }

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Scrollbar(
            controller: scr,
            child: ListView(
              controller: scr,
              shrinkWrap: true,
              children: [
                KidsClubImage(
                  img: widget.data.kidsClubImage,
                  height: 180.0,
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.data.kidsClubTitle.replaceAll('\\n', '\n'),
                    style: kTextStyle1.copyWith(
                      fontFamily: kFont2,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryColor,
                    ),
                  ),
                ),

                /* Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Explore the World with\n',
                          style: kTextStyle1.copyWith(
                            fontFamily: kFont2,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            color: kTextColor1,
                          ),
                        ),
                        TextSpan(
                          text: 'Little Explorers’ Kids Club',
                          style: kTextStyle1.copyWith(
                            fontFamily: kFont2,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            color: kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ), */

                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.data.kidsClubDesc,
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor1,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Material(
                  child: InkWell(
                    onTap: () {
                      Get.to(() => TnC(data: widget.data.kidsClubTnc));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: const BoxDecoration(
                              color: Color(0xFF5394A6),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Image.asset(
                                'images/icon/tnc1.png',
                                width: 24.0,
                                height: 24.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Text(
                              'Terms & Conditions',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: kTextColor2,
                            size: 24.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 1.0,
                  color: const Color(0xFFDADADA).withValues(alpha: 0.45),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppElevatedButton(
              text: 'Register New Member',
              onPressed: onSubmit,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'About Us',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}