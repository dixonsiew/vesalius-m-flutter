import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vesalius_m_flutter/components/no_network.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/notification_manager.dart';
import 'package:vesalius_m_flutter/services/common_service.dart';
import 'dart:developer' as developer;

import 'app_start.dart';
import 'main_layout.dart';
import 'sign_in.dart';
import 'update.dart';

class Splash extends StatefulWidget {

  static const String routeName = '/Splash';

  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  bool started = false;
  String version = '';

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    bool b = await DataManager.instance.getItem('isFirstRun') ?? true;
    if (b) {
      await DataManager.instance.clear();
      await DataManager.instance.setItem('isFirstRun', false);
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = '${packageInfo.version} (${packageInfo.buildNumber})';
    
    await AuthManager.instance.load();
    await checkNetwork();
  }

  void initPlatformState() async {
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.Debug.setLogLevel(OSLogLevel.info);

    OneSignal.consentRequired(false);

    OneSignal.initialize(kOneSignalAppID);
    await OneSignal.Notifications.clearAll();

    OneSignal.User.pushSubscription.addObserver((state) {
      final s = OneSignal.User.pushSubscription.id ?? '';
      if (s.isNotEmpty) {
        AuthManager.instance.playerId = s;
        developer.log("==== splash playerid ${AuthManager.instance.playerId} ====");
      }
    });

    OneSignal.Notifications.addForegroundWillDisplayListener(NotificationManager.instance.foregroundWillDisplayListener);

    OneSignal.Notifications.addClickListener((OSNotificationClickEvent ev) {
      NotificationManager.instance.clickListener(ev);
    });

    startNavigate();
  }

  void startNavigate() async {
    Duration duration = const Duration(milliseconds: 500);
    await Future.delayed(duration, navigationPage);
  }

  Future<void> checkNetwork() async {
    try {
      await CommonService.getCountries();
      final lv = await CommonService.getVersions();
      if (Platform.isAndroid) {
        final v = lv.firstWhereOrNull((x) => x.osPlatform == 'Android');
        if (v != null) {
          String ver = v.latestVersion;
          if (ver != version && v.status == 1) {
            // AuthManager.instance.hasUpdate = true;
            // showUpdate(kAppUrl);
            // return;
          }
        }
      }

      else {
        final v = lv.firstWhereOrNull((x) => x.osPlatform == 'iOS');
        if (v != null) {
          String ver = v.latestVersion;
          if (ver != version && v.status == 1) {
            // AuthManager.instance.hasUpdate = true;
            // showUpdate(kIOSAppUrl);
            // return;
          }
        }
      }

      initPlatformState();
    }

    on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError) {
        await Get.to(() => NoNetwork(
          onPressed: () {
            
          })
        );
        load();
      }

      else {
        initPlatformState();
      }
    }

    catch (_) {
      initPlatformState();
    }
  }

  void navigationPage() async {
    if (AuthManager.instance.hasUpdate) {
      Get.offAll(() => const Update());
      return;
    }

    if (AuthManager.instance.isAppStarted) {
      AuthManager.instance.getPlayerId();
      if (AuthManager.instance.isLogin) {
        Get.offAll(() => const MainLayout());
      }

      else {
        Get.offAll(() => const SignIn());
      }
    }

    else {
      Get.offAll(() => const AppStart());
      // final b = await DataManager.instance.getItem('__accepttnc__') ?? false;
      // if (b) {
      //   Get.offAll(() => const AppStart());
      // }

      // else {
      //   Get.offAll(() => const TnC());
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/imgs/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}