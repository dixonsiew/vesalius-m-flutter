import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/app_start_ctrl.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/notification_manager.dart';
import 'package:vesalius_m_flutter/ui/main_layout.dart';

import 'sign_in.dart';

class AppStart extends StatefulWidget {

  static const String routeName = '/AppStart';

  const AppStart({super.key});
  
  @override
  State<AppStart> createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {

  final AppStartCtrl ctrl = Get.put(AppStartCtrl());

  final List<ContentX> lx = [
    const ContentX(
      image: 'started-1.png',
      title: 'Book Appointment',
      desc: 'Easily schedule an appointment with your doctor at your convenience.',
      width: 220.0,
      height: 214.73,
    ),
    const ContentX(
      image: 'started-2.png',
      title: 'Search For A Doctor',
      desc: 'Choose a doctor from any speciality and make appointment.',
      width: 182.73,
      height: 242.0,
    ),
    const ContentX(
      image: 'started-3.png',
      title: 'View Hospital Information',
      desc: 'Know more about the history and background of Hospital',
      width: 312.0,
      height: 172.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    await AuthManager.instance.load();
    await initPlatformState();
  }

  Future<void> initPlatformState() async {
    // OneSignal.shared.setLogLevel(OSLogLevel.info, OSLogLevel.none);

    // await OneSignal.shared.setAppId(kOneSignalAppID);

    // OneSignal.shared.setRequiresUserPrivacyConsent(false);

    OneSignal.shared.setNotificationWillShowInForegroundHandler(NotificationManager.instance.notificationWillShowInForegroundHandler);

    // OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    //   NotificationManager.instance.notificationOpenedHandler(result, context);
    // });

    await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
  }

  Widget buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppElevatedButton(
            text: 'Get Started',
            onPressed: () async {
              if (AuthManager.instance.isLogin) {
                Get.off(() => const MainLayout());
              }

              else {
                Get.off(() => const SignIn());
              }
            },
          ),
          TextButton(
            onPressed: () async {
              await DataManager.instance.setItem('__app-started__', true);
              if (AuthManager.instance.isLogin) {
                Get.off(() => const MainLayout());
              }

              else {
                Get.off(() => const SignIn());
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: kPrimaryColor,
            ),
            child: Text(
              'Skip',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
            ),
          ),
        ],
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 112.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 360.0,
                    child: PageView(
                      physics: const BouncingScrollPhysics(),
                      children: lx,
                      onPageChanged: (int i) {
                        ctrl.setCurrent(i);
                      },
                    ),
                  ),
                  Obx(() =>
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [0, 1, 2].map((i) {
                        if (ctrl.current == i) {
                          return Container(
                            width: 20.0,
                            height: 6.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
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
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: buildFooter(),
            ),
          ],
        ),
      ),
    );
  }
}

class ContentX extends StatelessWidget {

  final String image;
  final String title;
  final String desc;
  final double width;
  final double height;

  const ContentX({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'images/imgs/$image',
          width: width,
          height: height,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16.0),
        Text(
          title,
          style: kTextStyle1.copyWith(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Text(
            desc,
            style: kTextStyle1.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: kTextColor2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }
}