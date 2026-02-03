import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/kidsclub_image.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/golden-pearl/join_club_activity_ctrl.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/goldenclub_data.dart';

import 'my_membership_id.dart';
import 'select_member.dart';
import 'tnc.dart';

class ClubActivityDetail extends StatefulWidget {

  final GoldenPearlActivity data;

  const ClubActivityDetail({
    super.key,
    required this.data,
  });

  @override
  State<ClubActivityDetail> createState() => _ClubActivityDetailState();
}

class _ClubActivityDetailState extends State<ClubActivityDetail> {

  ScrollController scr = ScrollController();
  final JoinClubActivityCtrl joinClubActivityCtrl = Get.put(JoinClubActivityCtrl());

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  void onSubmit() {
    joinClubActivityCtrl.setGoldenPearlActivity(widget.data);
    if (AuthManager.instance.isLogin) {
      Get.to(() => const SelectMember());
    }

    else {
      Get.to(() => const MyMembershipId(fromUI: 1));
    }
  }

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: widget.data.activitySeatsAvailable > 0 ? 80.0 : 0),
          child: Scrollbar(
            controller: scr,
            child: SingleChildScrollView(
              controller: scr,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KidsActivityImage(
                    img: widget.data.goldenActivityImage,
                    width: double.infinity,
                    height: 375.0,
                  ),
                  const SizedBox(height: 13.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      widget.data.goldenActivityName,
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
                      widget.data.dateRange,
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
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        alignment: Alignment.topRight,
                        child:Text(
                          '${widget.data.activityAttendees} Attendees',
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
                          '${widget.data.activitySeatsAvailable} seats available',
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
                      widget.data.goldenActivityDesc,
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Material(
                    child: InkWell(
                      onTap: () {
                        Get.to(() => TnC(data: widget.data.activityTnc));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: const BoxDecoration(
                                color: kColor7,
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
                    color: kColor3.withValues(alpha: 0.45),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.data.activitySeatsAvailable > 0) ...[
          Align(
            alignment: Alignment.bottomCenter,
            child:  Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: AppElevatedButton(
                text: 'Join The Activity',
                onPressed: onSubmit,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: widget.data.goldenActivityName,
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}