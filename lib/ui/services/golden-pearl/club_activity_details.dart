import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/ui/services/golden-pearl/select_member.dart';

class ClubActivityDetails extends StatefulWidget {

  const ClubActivityDetails({
    super.key,
  });

  @override
  State<ClubActivityDetails> createState() => _ClubActivityDetailsState();
}

class _ClubActivityDetailsState extends State<ClubActivityDetails> {

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'images/imgs/golden_activity.png',
                    width: double.infinity,
                    height: 375.0,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Activity Name',
                      style: kTextStyle1.copyWith(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '12 Aug - 31 Aug',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: kColor14,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        alignment: Alignment.topRight,
                        child:Text(
                          '11 Attendees',
                          style: kTextStyle1.copyWith(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: kColor13.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(
                          '30 seats available',
                          style: kTextStyle1.copyWith(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w600,
                            color: kTextColor1,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'DESCRIPTION',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child:  Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: AppElevatedButton(
              text: 'Join The Activity',
              onPressed: (){
                Get.to(() => const SelectMember());
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
      title: 'Activity Name',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}