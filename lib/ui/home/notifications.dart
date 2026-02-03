import 'package:dio/dio.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/guest_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/home_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/notifications_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/notification_data.dart';
import 'package:vesalius_m_flutter/services/guest_service.dart';
import 'package:vesalius_m_flutter/services/notification_service.dart';

import 'notifications_detail.dart';

class Notifications extends StatefulWidget {

  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  late ScrollController scr;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final NotificationsCtrl ctrl = Get.put(NotificationsCtrl());

  @override
  void initState() {
    super.initState();
    scr = ScrollController();
    scr.addListener(scrollListener);
    load();
  }

  @override
  void dispose() {
    scr.removeListener(scrollListener);
    scr.dispose();
    super.dispose();
  }

  void scrollListener() {
    final nextPageTrigger = 0.8 * scr.position.maxScrollExtent;
    if (scr.position.pixels > nextPageTrigger) {
      loadMore();
    }
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      await ctrl.load();
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

  void loadMore() async {
    try {
      if (ctrl.isLoadingMore) return;
      ctrl.setIsLoadingMore(true);
      await ctrl.loadMore();
      ctrl.setIsLoadingMore(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoadingMore(false);
      handleLoadError(error, loadMore);
    }

    catch (error) {
      ctrl.setIsLoadingMore(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  Widget buildList() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
      child: Obx(() => 
        GroupedListView(
          controller: scr,
          elements: ctrl.list,
          physics: const AlwaysScrollableScrollPhysics(),
          sort: false,
          groupBy: (element) => element.dateCreateText,
          groupComparator: (value1, value2) => value2.compareTo(value1),
          itemComparator: (element1, element2) => element1.notificationId.compareTo(element2.notificationId),
          groupSeparatorBuilder:(value) => Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
            child: Text(
              value,
              style: kTextStyle1.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                color: kTextColor2,
              ),
            ),
          ),
          indexedItemBuilder: (context, element, index) {
            if (index == ctrl.list.length - 1) {
              return Obx(() => 
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    NotificationItem(data: element),
                    if (ctrl.isLoadingMore) ...[
                      const AppLoadMoreIndicator(),
                      const SizedBox(height: 24.0),
                    ],
                  ],
                ),
              );
            }

            return NotificationItem(key: ValueKey(element.notificationId), data: element);
          },
        ),
      ),
    );
  }

  Widget buildContent() {
    if (!ctrl.isLoading && ctrl.list.isEmpty) {
      return NoNotification(onRefresh: onRefresh);
    }

    return Scrollbar(
      controller: scr,
      child: buildList(),
    );
  }

  // Widget buildContent000() {
  //   return Scrollbar(
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //       child: ListView(
  //         shrinkWrap: true,
  //         children: [
  //           const SizedBox(height: 20.0),
  //           Text(
  //             'TODAY',
  //             style: kTextStyle1.copyWith(
  //               fontSize: 12.0,
  //               fontWeight: FontWeight.w700,
  //               color: kTextColor2,
  //             ),
  //           ),
  //           const SizedBox(height: 16.0),
  //           const NotificationItem(
  //             text: 'Patient Survey',
  //             content: 'We hope you enjoy our service! Let us know your feedback by taking this survey!',
  //             time: '03:00 PM',
  //           ),
  //           const NotificationItem(
  //             text: 'You are in queue.',
  //             content: '5 people ahead you. Please be prepared for your turn.',
  //             time: '02:00 PM',
  //           ),
  //           const NotificationItem(
  //             text: 'Prescription Order Request',
  //             content: 'You have submitted a prescription order request.',
  //             time: '09:00 AM',
  //           ),

  //           const SizedBox(height: 8.0),
  //           Text(
  //             'OLDER',
  //             style: kTextStyle1.copyWith(
  //               fontSize: 12.0,
  //               fontWeight: FontWeight.w700,
  //               color: kTextColor2,
  //             ),
  //           ),
  //           const SizedBox(height: 16.0),
  //           const NotificationItem(
  //             text: 'Upcoming Appointment',
  //             content: 'You have an upcoming appointment with Dr Wong on 11 Jan 2022 , 9AM.',
  //             time: '02:00 PM',
  //             isUnread: true,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Notification',
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

class NotificationItem extends StatelessWidget {

  final NotificationX data;
  final HomeCtrl homeCtrl = Get.put(HomeCtrl());
  final GuestCtrl guestCtrl = Get.put(GuestCtrl());
  final NotificationsCtrl ctrl = Get.put(NotificationsCtrl());

  NotificationItem({
    super.key,
    required this.data,
  });

  void submitSeen() async {
    try {
      if (AuthManager.instance.isLogin) {
        int n = await NotificationService.postNotificationSeen(data.notificationId);
        ctrl.setSeen(data.notificationId);
        homeCtrl.setUnseenCount(n);
      }
      
      else {
        if (AuthManager.instance.playerId.isEmpty) {
          AuthManager.instance.getPlayerId();
        }

        int n = await GuestModeService.postNotificationSeen(data.notificationId, AuthManager.instance.playerId);
        ctrl.setSeen(data.notificationId);
        guestCtrl.setUnseenCount(n);
      }
    }

    catch (_) {}
  }

  String get image {
    String s = 'general-info.png';
    if (data.msgType == 'PROMOTION') {
      s = 'promotion.png';
    }

    else if (data.msgType == 'QUEUE_NOTIFICATION') {
      s = 'queue-notification.png';
    }

    else if (data.msgType == 'UPCOMING_APPT') {
      s = 'upcoming-appt.png';
    }

    else if (data.msgType == 'PATIENT_FEEDBACK') {
      s = 'patient-feedback.png';
    }

    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            color: kColor3.withValues(alpha: 0.4),
            blurRadius: 4.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: () {
            submitSeen();
            Get.to(() => NotificationsDetail(data: data));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Image.asset(
                  'images/icon/$image',
                  width: 48.0,
                  height: 48.0,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              data.notificationTitle,
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Text(
                            data.showTime,
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: EasyRichText(
                              data.shortMessage,
                              defaultStyle: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor2,
                              ),
                              patternList: [
                                EasyRichTextPattern(
                                  targetString: '(\\*)(.*?)(\\*)',
                                  matchBuilder: (BuildContext context, RegExpMatch? match) {
                                    // print(match[0]);
                                    return TextSpan(
                                      text: match?[0]?.replaceAll('*', ''),
                                      style: kTextStyle1.copyWith(fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                              ],
                            ),
                            /* Text(
                              data.shortMessage,
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor2,
                              ),
                            ), */
                          ),
                          const SizedBox(width: 32.0),
                          data.isSeen ? Container() :
                          Container(
                            width: 8.0,
                            height: 8.0,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF4848),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NoNotification extends StatelessWidget {

  final Future<void> Function() onRefresh;

  const NoNotification({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/imgs/empty-notification.png',
            width: 145.0,
            height: 145.0,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 9.0),
          Text(
            'You do not have any new notifications.',
            style: kTextStyle1.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(0, 0, 0, 0.2),
            ),
            textAlign: TextAlign.center,
          ),
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(
              Icons.refresh,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}