import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:vesalius_m_flutter/components/bottom_bar.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/health-package/my_cart_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/health_package_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/main_layout_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/notification_manager.dart';
import 'package:vesalius_m_flutter/models/user_data_manager.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';
// import 'dart:developer' as developer;

import 'appointment.dart';
import 'home.dart';
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

  final MainLayoutCtrl ctrl = Get.put(MainLayoutCtrl());
  final HealthPackageCtrl healthPackageCtrl = Get.put(HealthPackageCtrl());
  final MyCartCtrl myCartCtrl = Get.put(MyCartCtrl());

  @override
  void initState() {
    super.initState();
    pages = [const Home(), const Appointment(), const Profile()];
    ctrl.setIndex(widget.index);
    pageController = PageController(initialPage: ctrl.index);
    ctrl.pageController = pageController;
    load();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void load() async {
    await initPlatformState();
    await loadCart();
  }

  Future<void> initPlatformState() async {
    // OneSignal.shared.setLogLevel(OSLogLevel.info, OSLogLevel.none);

    // await OneSignal.shared.setAppId(kOneSignalAppID);

    // OneSignal.shared.setRequiresUserPrivacyConsent(false);

    OneSignal.shared.setNotificationWillShowInForegroundHandler(NotificationManager.instance.notificationWillShowInForegroundHandler);

    // OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    //   final notification = result.notification;
    //   String d = "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
    //   developer.log(d);
    //   if (AuthManager.instance.isLogin) {
    //     if (notification.additionalData!['type'] == 'survey') {
    //       Get.to(() => const PatientSurvey());
    //     }

    //     else {
    //       //Get.to(() => const AppointmentDetail());
    //     }
    //   }
    // });

    await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);

    if (AuthManager.instance.isLogin) {
      //OneSignal.shared.sendTag('user', DataManager.userDetails!.userId!);
      String playerId = await AuthManager.instance.getPlayerId();

      if (playerId.isNotEmpty) {
        UserService.updatePlayerId(playerId);
      }

      else {
        await AuthManager.instance.waitPlayerId();
        UserService.updatePlayerId(AuthManager.instance.playerId);
      }
    }
  }

  Future<void> loadCart() async {
    String? userMode = await AuthManager.instance.getUserMode();
    final res = await UserDataManager.instance.getMyCartList(userMode);
    myCartCtrl.setCartList(res);
  }

  Widget get buildContent => PageView(
    controller: pageController,
    physics: const NeverScrollableScrollPhysics(),
    children: pages,
  );

  void onPopInvokedWithResult(bool didPop, result) async {
    if (didPop) return;
    bool b = await showConfirmDialog('Are you sure you want to exit ?');
    if (b) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
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