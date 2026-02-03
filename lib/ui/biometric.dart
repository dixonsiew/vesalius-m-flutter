import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/biometric_ctrl.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';

import 'main_layout.dart';

class Biometric extends StatefulWidget {

  const Biometric({super.key});

  @override
  State<Biometric> createState() => _BiometricState();
}

class _BiometricState extends State<Biometric> {

  String deviceId = '';
  List<BiometricType> listBiometric = [];
  final LocalAuthentication auth = LocalAuthentication();
  static const AndroidId androidIdPlugin = AndroidId();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  final BiometricCtrl ctrl = Get.put(BiometricCtrl());

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void initPlatformState() async {
    try {
      if (Platform.isAndroid) {
        deviceId = await androidIdPlugin.getId() ?? '';
      }

      else {
        final IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
        deviceId = data.identifierForVendor ?? '';
      }

      listBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (_) {
      listBiometric = [];
    }

    String s = 'fingerprint';
    if (Platform.isIOS) {
      if (listBiometric.contains(BiometricType.face)) {
        s = 'face';
      }
    }

    ctrl.setType(s);
  }

  void onBiometric() async {
    String s = 'fingerprint';
    if (Platform.isIOS) {
      if (listBiometric.contains(BiometricType.face)) {
        s = 'face';
      }
    }

    bool a = await auth.authenticate(
      localizedReason: 'Please scan your $s to authenticate',
      options: const AuthenticationOptions(
        useErrorDialogs: true,
        stickyAuth: true,
        biometricOnly: true,
      ),
    );
    if (a) {
      await UserService.addMachineId({ 'machineId': deviceId });
      await DataManager.write('__biometric-username__', AuthManager.username!);
      await DataManager.write('__biometric-uuid__', deviceId);
      Map<dynamic, dynamic>? m = await DataManager.getItem('biometric');
      m ??= <dynamic, dynamic>{};
      m[AuthManager.username!] = 1;
      await DataManager.setItem('biometric', m);
      Get.offAll(() => const MainLayout());
    }
  }

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 144.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => 
                Flexible(
                  child: Image.asset(
                    ctrl.name == 'fingerprint' ?
                    'images/imgs/fingerprint.png' :
                    'images/imgs/face.png',
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Obx(() =>
                Text(
                  'Enable ${ctrl.label}',
                  style: kTextStyle1.copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: kTextColor1,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 44.0),
                child: Obx(() =>
                  Text(
                    'Login with ${ctrl.name} authentication for faster, easier access to your account.',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: kBgColor1,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppElevatedButton(
                  text: 'Enable Fingerprint',
                  onPressed: onBiometric,
                ),
                const SizedBox(height: 16.0),
                AppOutlinedButton(
                  text: 'No, thanks',
                  onPressed: () {
                    Get.offAll(() => const MainLayout());
                  }
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
      title: 'Biometric Authentication',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}