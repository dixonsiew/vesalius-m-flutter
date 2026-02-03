import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/little-explorer/confirm_join_club_activity_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/services/little-explorer/join_club_activity_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/services/little-explorer/select_member_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/services/little_explorer_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/kidsclub_data.dart';
import 'package:vesalius_m_flutter/services/clubs_service.dart';
import 'package:vesalius_m_flutter/services/guest_service.dart';
import 'package:vesalius_m_flutter/ui/services/little-explorer/select_date.dart';
import 'package:vesalius_m_flutter/ui/services/little_explorer.dart';

class ConfirmJoinClubActivity extends StatefulWidget {

  const ConfirmJoinClubActivity({super.key});

  @override
  State<ConfirmJoinClubActivity> createState() => _ConfirmJoinClubActivityState();
}

class _ConfirmJoinClubActivityState extends State<ConfirmJoinClubActivity> {

  ScrollController scr = ScrollController();
  final ConfirmJoinClubActivityCtrl ctrl = Get.put(ConfirmJoinClubActivityCtrl());
  final JoinClubActivityCtrl joinClubActivityCtrl = Get.put(JoinClubActivityCtrl());
  final SelectMemberCtrl selectMemberCtrl = Get.put(SelectMemberCtrl());
  final LittleExplorerCtrl littleExplorerCtrl = Get.put(LittleExplorerCtrl());

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  void showSuccess() {
    Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/icon/tick.png',
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Registration Successfully',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'You have joined ',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor6,
                    ),
                  ),
                  TextSpan(
                    text: '${joinClubActivityCtrl.kidsActivity?.kidsActivityName ?? ''} ',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                  TextSpan(
                    text: '\nat ',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor6,
                    ),
                  ),
                  TextSpan(
                    text: '$date.',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Done',
              onPressed: () {
                Get.back();
                Get.until((route) => Get.currentRoute == LittleExplorer.routeName);
              },
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> refreshMainList() async {
    try {
      List<KidsActivity> lx = await ClubsService.getAllLittleKidsActivities(1, 2, 1);
      littleExplorerCtrl.setList(lx);
    }

    on DioException catch (_) {}

    catch (_) {}
  }

  void onSubmit() async {
    try {
      final a = joinClubActivityCtrl.kidsActivity;
      final la = selectMemberCtrl.selectedMemberList.map((x) {
        return {
          'kidsActivityId': a?.kidsActivityId,
          'kidsMembershipId': x.kidsMembershipId,
          'activityDateTime': formatDate(ctrl.date!, [dd, '/', mm, '/', yyyy])
        };
      }).toList();
      final o = {
        'kidsActvParticipation': la
      };
      ctrl.setIsLoading(true);
      if (AuthManager.instance.isLogin) {
        await ClubsService.postLittleKidsActivityJoin(o);
      }

      else {
        await GuestModeService.postLittleKidsActivityJoin(o);
      }

      await refreshMainList();
      ctrl.setIsLoading(false);
      showSuccess();
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleSubmitError(error, 'Unable to create new membership at the moment. Please check your internet connection or try again later.', null);
    }

    catch (_) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', 'Unable to create new membership at the moment. Please check your internet connection or try again later.', 'Dismiss');
    }
  }

  String get date {
    if (ctrl.date == null) {
      return 'Please Select';
    }

    return formatDate(ctrl.date!, [dd, ' ', M, ' ', yyyy]);
  }

  List<Widget> buildList() {
    List<Widget> lx = [];
    final lm = selectMemberCtrl.selectedMemberList;
    for (int i = 0; i < lm.length; i++) {
      final o = lm[i];
      final lbl = Text(
        AuthManager.instance.isLogin ? 'Member ${i + 1}' : "Member's Name",
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: kTextColor5,
        ),
      );
      final x = Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: const Color(0xFFC7CCD6)),
          boxShadow: [
            BoxShadow(
              color: kBgColor2.withValues(alpha: 0.1),
              offset: const Offset(0.0, 4.0),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Text(
          o.kidsName,
          style: kTextStyle1.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: kTextColor1,
          ),
        ),
      );
      lx.addAll([
        lbl,
        const SizedBox(height: 4.0),
        x,
        const SizedBox(height: 24.0),
      ]);
    }

    lx.addAll([
      Text(
        'Activity Name',
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: kTextColor5,
        ),
      ),
      const SizedBox(height: 4.0),
      Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: const Color(0xFFC7CCD6)),
          boxShadow: [
            BoxShadow(
              color: kBgColor2.withValues(alpha: 0.1),
              offset: const Offset(0.0, 4.0),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Text(
          joinClubActivityCtrl.kidsActivity?.kidsActivityName ?? '',
          style: kTextStyle1.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: kTextColor1,
          ),
        ),
      ),
      const SizedBox(height: 24.0),
    ]);

    lx.addAll([
      Text(
        'Activity Date',
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: kTextColor5,
        ),
      ),
      const SizedBox(height: 4.0),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: const Color(0xFFC7CCD6)),
          boxShadow: [
            BoxShadow(
              color: kBgColor2.withValues(alpha: 0.1),
              offset: const Offset(0.0, 4.0),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          child: InkWell(
            onTap: () async {
              final lx = joinClubActivityCtrl.kidsActivity?.datesMinMax ?? [DateTime.now(), DateTime.now()];
              final dt = await Get.to<DateTime?>(() => SelectDate(selected: ctrl.date, startDate: lx[0]!, endDate: lx[1]));
              if (dt != null) {
                ctrl.setDate(dt);
              }
            },
            borderRadius: BorderRadius.circular(5.0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Image.asset(
                    'images/icon/clock3.png',
                    width: 16.0,
                    height: 16.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Obx(() =>
                      Text(
                        date,
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor1,
                        ),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.expand_more,
                    color: kTextColor1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ]);

    return lx;
  }

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 144.0),
          child: Scrollbar(
            controller: scr,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
              child: ListView(
                controller: scr,
                shrinkWrap: true,
                children: buildList(),
              ),
            ),
          ),
        ),
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
                    text: 'Confirm',
                    onPressed: ctrl.date == null ? null : onSubmit,
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
      title: 'Confirmation',
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