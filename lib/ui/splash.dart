import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/notification_manager.dart';

import 'app_start.dart';
import 'sign_in.dart';

class Splash extends StatefulWidget {

  static const String routeName = '/Splash';

  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  bool started = false;
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    await AuthManager.load();
    startTime();
    initPlatformState();
  }

  void initPlatformState() async {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.info, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(false);

    OneSignal.shared.setNotificationWillShowInForegroundHandler(NotificationManager.notificationWillShowInForegroundHandler);

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      NotificationManager.notificationOpenedHandler(result, context);
    });

    await OneSignal.shared.setAppId(kOneSignalAppID);
  }

  // Future<void> initPlatformState() async {
  //   final SharedPreferences prefs = await _prefs;
  //   bool _started = prefs.getBool('__app-started__') ?? false;
  //   setState(() {
  //     started = _started;
  //   });
  // }

  Future<Timer> startTime() async {
    Duration duration = const Duration(seconds: 5);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    if (AuthManager.isAppStarted) {
      Get.offNamed(SignIn.routeName);
    }

    else {
      Get.offNamed(AppStart.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light, statusBarColor: kMainColor),
        toolbarHeight: 0.0,
        backgroundColor: kMainColor,
        elevation: 0.0,
      ),
      backgroundColor: kMainColor,
      body: Center(
        child: Image.asset(
          'images/imgs/splash.png',
          width: 280.0,
          height: 139.41,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}