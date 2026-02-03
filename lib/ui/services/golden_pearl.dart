import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/kidsclub_image.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/golden_pearl_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/goldenclub_data.dart';
import 'package:vesalius_m_flutter/services/clubs_service.dart';
// ignore: unused_import
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/services/guest_service.dart';
import 'package:vesalius_m_flutter/ui/home.dart';
import 'package:vesalius_m_flutter/ui/services/golden-pearl/about_us.dart';
import 'package:vesalius_m_flutter/ui/services/golden-pearl/club_activities.dart';
import 'package:vesalius_m_flutter/ui/services/golden-pearl/club_activity_detail.dart';
import 'package:vesalius_m_flutter/ui/services/golden-pearl/my_activity.dart';
import 'package:vesalius_m_flutter/ui/services/golden-pearl/my_membership.dart';
import 'package:vesalius_m_flutter/ui/services/golden-pearl/transport_arrangement.dart';

import 'golden-pearl/tnc.dart';
import 'golden-pearl/my_membership_id.dart';

class GoldenPearl extends StatefulWidget {

  static const String routeName = '/GoldenPearl';
  
  const GoldenPearl({super.key});

  @override
  State<GoldenPearl> createState() => _GoldenPearlState();
}

class _GoldenPearlState extends State<GoldenPearl> {

  ScrollController scr = ScrollController();
  final GoldenPearlCtrl ctrl = Get.put(GoldenPearlCtrl());

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      if (AuthManager.instance.isLogin) {
        final lw = <Future<dynamic>>[
          ClubsService.getGoldenPearlAboutUs(),
          ClubsService.getAllGoldenPearlActivities(1, 5, 1),
        ];
        final lr = await Future.wait<dynamic>(lw);
        GoldenPearlClub? x = lr[0];
        List<GoldenPearlActivity> lx = lr[1];
        ctrl.setList(lx);
        ctrl.setGoldenPearlClub(x);
      }

      else {
        final lw = <Future<dynamic>>[
          GuestModeService.getGoldenPearlAboutUs(),
          GuestModeService.getAllGoldenPearlActivities(1, 5, 1),
        ];
        final lr = await Future.wait<dynamic>(lw);
        GoldenPearlClub? x = lr[0];
        List<GoldenPearlActivity> lx = lr[1];
        ctrl.setList(lx);
        ctrl.setGoldenPearlClub(x);
      }
      
      ctrl.setIsLoading(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, load);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  void onSubmit() {
    Get.to(() => TnC(data: ctrl.goldenPearlClub?.goldenClubTnc, showAgree: true));
  }

  Widget buildContent() {
    return ctrl.isLoading ? Container() : 
    Stack(
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
                  img: ctrl.goldenPearlClub?.goldenClubImage,
                  height: 180.0,
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  height: 100.0,
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    runAlignment: WrapAlignment.start,
                    children: [
                      ServiceItem(
                        image: 'about.png',
                        title: 'About Us\n',
                        onTap: () {
                          Get.to(() => AboutUs(data: ctrl.goldenPearlClub!));
                        },
                      ),
                      if (AuthManager.instance.isLogin && kTransportArrangement) ...[
                        ServiceItem(
                          image: 'affiliate.png',
                          title: 'Transport\nArrangement',
                          onTap: () {
                            Get.to(() => const TransportArrangement());
                          },
                        ),
                      ],
                      ServiceItem(
                        image: 'membership.png',
                        title: 'My\nMembership',
                        onTap: () {
                          if (AuthManager.instance.isLogin) {
                            Get.to(() => MyMembership(data: ctrl.goldenPearlClub!));
                          }

                          else {
                            Get.to(() => MyMembershipId(data: ctrl.goldenPearlClub!));
                          }
                        },
                      ),
                      if (AuthManager.instance.isLogin) ...[
                        ServiceItem(
                          image: 'myactivity.png',
                          title: 'My\nActivity',
                          onTap: () {
                            Get.to(() => const MyActivity());
                          },
                        ),
                      ],
                    ],
                  ),
                  
                  // GridView.count(
                  //   shrinkWrap: true,
                  //   clipBehavior: Clip.antiAlias,
                  //   crossAxisCount: 4,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   children: [
                  //     ServiceItem(
                  //       image: 'about.png',
                  //       title: 'About Us\n',
                  //       onTap: () {
                  //         Get.to(() => AboutUs(data: ctrl.goldenPearlClub!));
                  //       },
                  //     ),
                  //     ServiceItem(
                  //       image: 'affiliate.png',
                  //       title: 'Transport\nArrangement',
                  //       onTap: () {
                  //         Get.to(() => const TransportArrangement());
                  //       },
                  //     ),
                  //     ServiceItem(
                  //       image: 'membership.png',
                  //       title: 'My\nMembership',
                  //       onTap: () {
                  //         Get.to(() => MyMembership(data: ctrl.goldenPearlClub!));
                  //       },
                  //     ),
                  //     ServiceItem(
                  //       image: 'myactivity.png',
                  //       title: 'My\nActivity',
                  //       onTap: () {
                  //         Get.to(() => const MyActivity());
                  //       },
                  //     ),
                  //   ],
                  // ),
                ),
                if (ctrl.list.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Club Activities',
                          style: kTextStyle1.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: kTextColor1,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const ClubActivities());
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: kPrimaryColor,
                          ),
                          child: Text(
                            'See More',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: 243.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: ctrl.list.length,
                      itemBuilder: (context, i) {
                        return GoldenPearlActivityItem(
                          data: ctrl.list[i],
                          isLast: i == ctrl.list.length - 1,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
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
      title: 'Golden Pearl Club',
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: buildContent(),
          ),
        ),
      ),
    );
  }
}

class GoldenPearlActivityItem extends StatelessWidget {

  final GoldenPearlActivity data;
  final bool isLast;

  const GoldenPearlActivityItem({
    super.key,
    required this.data,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168.0,
      height: 240.0,
      margin: isLast ? EdgeInsets.zero : const EdgeInsets.only(right: 16.0),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Get.to(() => ClubActivityDetail(data: data));
          },
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KidsActivityImage(
                    img: data.goldenActivityImage,
                    width: double.infinity,
                    height: 148.0,
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      data.goldenActivityName,
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      data.dateRange,
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    margin: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4E8E8).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      '${data.activitySeatsAvailable} seats available',
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor1,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(right: 8.0, top: 8.0),
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  '${data.activityAttendees} Attendees',
                  style: kTextStyle1.copyWith(
                    fontSize: 8.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}