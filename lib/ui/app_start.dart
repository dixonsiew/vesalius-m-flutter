import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/notification_manager.dart';
import 'package:vesalius_m_flutter/ui/main_layout.dart';

import 'sign_in.dart';

class AppStart extends StatefulWidget {

  static const String routeName = '/AppStart';

  const AppStart({Key? key}) : super(key: key);
  
  @override
  State<AppStart> createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {

  int current = 0;
  String contentTitle = 'Book Appointment';
  String contentDesc = 'Easily schedule an appointment with your doctor at your convenience.';
  final CarouselController _controller = CarouselController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    await AuthManager.load();
    await initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.info, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(false);

    OneSignal.shared.setNotificationWillShowInForegroundHandler(NotificationManager.notificationWillShowInForegroundHandler);

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      NotificationManager.notificationOpenedHandler(result, context);
    });

    if (Platform.isIOS) {
      await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
    }

    await OneSignal.shared.setAppId(kOneSignalAppID);
  }

  getTitle(int i) {
    String s = 'Book Appointment';
    if (i == 1) {
      s = 'Search for a doctor';
    }

    else if (i == 2) {
      s = 'View Hospital Information';
    }

    return s;
  }

  getDesc(int i) {
    String s = 'Easily schedule an appointment with your doctor at your convenience.';
    if (i == 1) {
      s = 'Choose a doctor from any speciality and make appointment.';
    }

    else if (i == 2) {
      s = 'Know more about the history and background of Island Hospital.';
    }

    return s;
  }

  Widget buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          final SharedPreferences prefs = await _prefs;
          prefs.setBool('__app-started__', true);
          if (AuthManager.isLogin) {
            Get.offNamed(MainLayout.routeName);
          }

          else {
            Get.offNamed(SignIn.routeName);
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          backgroundColor: kMainColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        ),
        child: Text(
          'Get Started',
          style: kTextStyle1.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
        toolbarHeight: 0.0,
        backgroundColor: kBgColor1,
        elevation: 0.0,
      ),
      backgroundColor: kBgColor1,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      autoPlay: false,
                      height: 250.0,
                      viewportFraction: 1.0,
                      initialPage: current,
                      onPageChanged: (index, reason) {
                        setState(() {
                          current = index;
                          contentTitle = getTitle(index);
                          contentDesc = getDesc(index);
                        });
                      },
                    ),
                    items: [
                      Image.asset(
                        'images/imgs/started-1.png',
                        width: 220.0,
                        height: 214.73,
                        fit: BoxFit.contain,
                      ),
                      Image.asset(
                        'images/imgs/started-2.png',
                        width: 182.73,
                        height: 242.0,
                        fit: BoxFit.contain,
                      ),
                      Image.asset(
                        'images/imgs/started-3.png',
                        width: 312.0,
                        height: 172.0,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    contentTitle,
                    style: kTextStyle1.copyWith(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      color: kTextColor1,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      contentDesc,
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [0, 1, 2].map((i) {
                      if (current == i) {
                        return Container(
                          width: 20.0,
                          height: 6.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            color: kMainColor,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        );
                      }

                      return Container(
                        width: 6.0,
                        height: 6.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFDADADA),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            buildFooter(),
          ],
        ),
      ),
    );
  }
}