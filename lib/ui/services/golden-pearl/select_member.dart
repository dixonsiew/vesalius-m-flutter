import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/golden-pearl/select_member_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/goldenclub_data.dart';
import 'package:vesalius_m_flutter/services/clubs_service.dart';

import 'confirm_join_club_activity.dart';
import 'my_membership.dart';
import 'register_exp.dart';

class SelectMember extends StatefulWidget {

  const SelectMember({super.key});

  @override
  State<SelectMember> createState() => _SelectMemberState();
}

class _SelectMemberState extends State<SelectMember> {

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final SelectMemberCtrl ctrl = Get.put(SelectMemberCtrl());

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      List<GoldenPearlMembership> lx = await ClubsService.getAllGoldenPearlMemberships(1, kPageSize);
      ctrl.setList(lx);
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

  Future<void> onRefresh() async {
    load();
  }

  Widget buildContent() {
    return Stack(
      children: [
        if (!ctrl.isLoading && ctrl.list.isEmpty) ...[
          NoMembership(onRefresh: onRefresh),
        ] else ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 144.0),
            child: Scrollbar(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ctrl.list.length,
                  itemBuilder: (context, i) {
                    final o = ctrl.list[i];
                    return MemberItem(
                      key: ValueKey(o.goldenMembershipId),
                      data: o,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() =>
                  AppElevatedButton(
                    text: ctrl.list.isEmpty ? 'Register New Member' : 'Next',
                    onPressed: ctrl.list.isNotEmpty && ctrl.selectedMemberList.isEmpty ? null : () {
                      if (ctrl.list.isEmpty && ctrl.selectedMemberList.isEmpty) {
                        Get.to(() => const RegisterExp());
                      }
                      
                      Get.to(() => const ConfirmJoinClubActivity());
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                AppOutlinedButton(
                  text: 'Cancel',
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Select Member',
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: RefreshIndicator(
              key: refreshIndicatorKey,
              onRefresh: onRefresh,
              color: kPrimaryColor,
              child: buildContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class MemberItem extends StatelessWidget {

  final GoldenPearlMembership data;

  final SelectMemberCtrl ctrl = Get.put(SelectMemberCtrl());

  MemberItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
      Container(
        margin: const EdgeInsets.only(bottom: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          child: InkWell(
            onTap: () {
              if (ctrl.hasMemberId(data.goldenMembershipId)) {
                ctrl.removeMember(data);
              }

              else {
                ctrl.addMember(data);
              }
            },
            borderRadius: BorderRadius.circular(5.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: kSecondaryColor2,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Text(
                        data.goldenName.isEmpty ? '' : data.goldenName[0].toUpperCase(),
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: kTextColor1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.goldenName,
                          style: kTextStyle1.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: kTextColor1,
                          ),
                        ),
                        // const SizedBox(height: 8.0),
                        // Text(
                        //   data.relationship,
                        //   style: kTextStyle1.copyWith(
                        //     fontSize: 14.0,
                        //     fontWeight: FontWeight.w400,
                        //     color: kTextColor2,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  ctrl.hasMemberId(data.goldenMembershipId) ?
                  const Icon(
                    Icons.check_circle,
                    color: kPrimaryColor,
                  ) : const SizedBox(width: 24.0, height: 24.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}