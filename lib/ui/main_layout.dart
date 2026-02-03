import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:vesalius_m_flutter/components/bottom_bar.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/health_package_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/main_layout_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/notification_manager.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';

import 'appointment.dart';
import 'appointment/appointment_detail.dart';
import 'home.dart';
import 'patient_survey.dart';
import 'profile.dart';

class MainLayout extends StatefulWidget {

  static const String routeName = '/MainLayout';

  final int index;

  const MainLayout({
    super.key,
    this.index = 0,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {

  late List<Widget> pages;
  late PageController pageController;

  final HealthPackageCtrl healthPackageCtrl = Get.put(HealthPackageCtrl());
  final MainLayoutCtrl ctrl = Get.put(MainLayoutCtrl());

  @override
  void initState() {
    super.initState();
    pages = [const Home(), const Appointment(), const Profile()];
    ctrl.setIndex(widget.index);
    pageController = PageController(initialPage: ctrl.index);
    ctrl.pageController = pageController;
    initPlatformState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void initPlatformState() async {
    OneSignal.shared.setLogLevel(OSLogLevel.info, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(false);

    OneSignal.shared.setNotificationWillShowInForegroundHandler(NotificationManager.notificationWillShowInForegroundHandler);

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      final notification = result.notification;
      String d = "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      print(d);
      if (AuthManager.isLogin) {
        if (notification.additionalData!['type'] == 'survey') {
          Get.to(() => const PatientSurvey());
        }

        else {
          Get.to(() => const AppointmentDetail());
        }
      }
    });

    if (Platform.isIOS) {
      await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
    }

    if (AuthManager.isLogin) {
      //OneSignal.shared.sendTag('user', DataManager.userDetails!.userId!);
      String playerId = '';
      OSDeviceState? deviceState = await OneSignal.shared.getDeviceState();
      if (deviceState != null) {
        String? userId = deviceState.userId;
        playerId = userId ?? '';
      }

      if (playerId.isNotEmpty) {
        await UserService.updatePlayerId(playerId);
      }
    }
  }

  Widget get buildContent => PageView(
    controller: pageController,
    physics: const NeverScrollableScrollPhysics(),
    children: pages,
  );

  Future<bool> onWillPop() async {
    return await showConfirmDialog('Are you sure you want to exit ?');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
          toolbarHeight: 0.0,
          backgroundColor: kBgColor1,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: kBgColor1,
        body: SafeArea(
          child: buildContent,
        ),
        bottomNavigationBar: Obx(() =>
          BottomBar(
            index: ctrl.index,
            onTap: (int i) {
              ctrl.setIndex(i);
              pageController.jumpToPage(i);
            },
          ),
        ),
      ),
    );
  }
}