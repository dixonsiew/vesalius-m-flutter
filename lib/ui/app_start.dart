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

import 'home.dart';
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

  Future<void> load() async {
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
    if (current == 2) {
      return Padding(
        padding: const EdgeInsets.only(left: 33.0, right: 33.0, bottom: 42.0),
        child: ElevatedButton(
          onPressed: () async {
            final SharedPreferences prefs = await _prefs;
            prefs.setBool('__app-started__', true);
            if (AuthManager.isLogin) {
              Get.offNamed(Home.routeName);
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
            style: kBodyTextStyle.copyWith(
              fontSize: 18.0,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 33.0, right: 33.0, bottom: 56.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              if (AuthManager.isLogin) {
                Get.offNamed(Home.routeName);
              }

              else {
                Get.offNamed(SignIn.routeName);
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF4E4E4E),
            ),
            child: Text(
              'Skip',
              style: kTitleTextStyle.copyWith(
                color: const Color(0xFF4E4E4E),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              int i = current;
              ++i;
              _controller.animateToPage(i);
            },
            icon: Image.asset(
              'images/icon/next.png',
              width: 48.0,
              height: 48.0,
              fit: BoxFit.cover,
            )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
        toolbarHeight: 0.0,
        backgroundColor: const Color(0xFFF8F8F8),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
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
                      height: 300.0,
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
                        width: 312.0,
                        height: 258.0,
                        fit: BoxFit.contain,
                      ),
                      Image.asset(
                        'images/imgs/started-2.png',
                        width: 312.0,
                        height: 258.0,
                        fit: BoxFit.contain,
                      ),
                      Image.asset(
                        'images/imgs/started-3.png',
                        width: 312.0,
                        height: 258.0,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    contentTitle,
                    style: kMainTextStyle.copyWith(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: kMainColor,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 38.0),
                    child: Text(
                      contentDesc,
                      style: kBodyTextStyle.copyWith(
                        fontSize: 16.0,
                        color: const Color(0xFF8C8C8C),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [0, 1, 2].map((i) {
                      return Container(
                        width: 6.0,
                        height: 6.0,
                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: current == i
                            ? kMainColor
                            : const Color(0xFFDADADA),
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