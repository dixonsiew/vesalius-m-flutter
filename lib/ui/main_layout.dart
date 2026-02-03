import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:vesalius_m_flutter/components/bottom_bar.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/notification_manager.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';
import 'package:vesalius_m_flutter/ui/appointment.dart';
import 'package:vesalius_m_flutter/ui/profile.dart';

import 'appointment/appointment_detail.dart';
import 'home.dart';
import 'patient_survey.dart';

class MainLayout extends StatefulWidget {

  static const String routeName = '/MainLayout';

  final int index;

  const MainLayout({
    Key? key,
    this.index = 0,
  }) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {

  int index = 0;
  late List<Widget> pages;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pages = [const Home(), const Appointment(), const Profile()];
    index = widget.index;
    pageController = PageController(initialPage: index);
    initPlatformState();
  }

  void initPlatformState() async {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.info, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(false);

    OneSignal.shared.setNotificationWillShowInForegroundHandler(NotificationManager.notificationWillShowInForegroundHandler);

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      final notification = result.notification;
      String d = "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      print(d);
      if (AuthManager.isLogin) {
        if (notification.additionalData!['type'] == 'survey') {
          Get.toNamed(PatientSurvey.routeName);
        }

        else {
          Get.toNamed(AppointmentDetail.routeName);
        }
      }
    });

    if (Platform.isIOS) {
      await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
    }

    if (AuthManager.isLogin) {
      OneSignal.shared.sendTag('user', DataManager.userDetails!.userId!);
      String playerId = '';
      OSDeviceState? deviceState = await OneSignal.shared.getDeviceState();
      if (deviceState != null) {
        String? userId = deviceState.userId;
        playerId = userId ?? '';
      }

      if (playerId.isNotEmpty) {
        await updatePlayerId(playerId);
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
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
          toolbarHeight: 0.0,
          backgroundColor: const Color(0xFFF8F8F8),
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: const Color(0xFFF8F8F8),
        body: SafeArea(
          child: buildContent,
        ),
        bottomNavigationBar: BottomBar(
          index: index,
          onTap: (int i) {
            setState(() {
              index = i;
              pageController.jumpToPage(i);
            });
          },
        ),
      ),
    );
  }
}