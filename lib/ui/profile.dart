import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/profile_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

import 'profile/change_password.dart';
import 'sign_in.dart';

class Profile extends StatefulWidget {

  static const String routeName = '/Profile';

  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin<Profile> {

  String deviceId = '';
  List<BiometricType> listBiometric = [];
  final LocalAuthentication auth = LocalAuthentication();
  static const AndroidId androidIdPlugin = AndroidId();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  final ProfileCtrl ctrl = Get.put(ProfileCtrl());

  @override
  void initState() {
    super.initState();
    initPlatformState();
    load();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      await AuthManager.load();
      UserBranch? branchDetails = DataManager.branchDetails;
      PatientDetails? patientData = await VesaliusService.getVesaliusPatientData(branchDetails!.branch!.branchId!, branchDetails.prn!);
      await DataManager.setPatientDetails(patientData);
      ctrl.setPatientDetails(patientData);
      ctrl.setIsLoading(false);
    }

    catch (error) {
      ctrl.setIsLoading(false);
    }
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

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    bool biometricEnabled = false;
    Map<dynamic, dynamic>? m = await DataManager.getItem('biometric');
    if (m != null && m.containsKey(AuthManager.username!)) {
      biometricEnabled = true;
    }

    ctrl.setIsBiometricEnabled(biometricEnabled);
    ctrl.setVersion(packageInfo.version);
  }

  Future<bool> onSignOut() async {
    return await showConfirmDialog('Are you sure you want to sign out?');
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
      ctrl.setIsBiometricEnabled(true);
    }
  }

  Future<bool> onConfirmBiometric() async {
    return await Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/icon/biometric1.png',
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Biometric Login',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Do you want to enable biometric login? ',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor2,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: AppOutlinedButton(
                    text: 'Cancel',
                    onPressed: () => Get.back(result: false),
                  ),
                ),
                const SizedBox(width: 18.0),
                Expanded(
                  child: AppElevatedButton(
                    text: 'Enable',
                    onPressed: () {
                      Get.back(result: true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )) ?? false;
  }

  Widget buildContent() {
    return Obx(() => ctrl.isLoading ? Container() : 
    Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 30.0, bottom: 24.0),
            child: Text(
              'Profile',
              style: kTextStyle1.copyWith(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: kTextColor1,
              ),
            ),
          ),
          FlipCard(
            front: FrontCard(),
            back: BackCard(),
          ),
          Text(
            'Tap to flip the card',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: kTextColor2,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 24.0, bottom: 17.0),
            child: Text(
              'PURCHASE HISTORY',
              style: kTextStyle1.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                color: kTextColor2,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Image.asset(
                    'images/icon/cart1.png',
                    width: 15.61,
                    height: 12.67,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    'My Screening Packages',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 25.0, bottom: 17.0),
            child: Text(
              'ACCOUNT SETTINGS',
              style: kTextStyle1.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                color: kTextColor2,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const ChangePassword());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Image.asset(
                    'images/icon/lock1.png',
                    width: 13.33,
                    height: 16.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    'Change Password',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 18.0),
            child: Row(
              children: [
                Image.asset(
                  'images/icon/biometric.png',
                  width: 15.34,
                  height: 16.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    'Enable Biometric Login',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                ),
                Obx(() =>
                  Switch(
                    value: ctrl.isBiometricEnabled,
                    activeColor: const Color(0xFF08B86E),
                    onChanged: (value) async {
                      if (value) {
                        try {
                          bool x = await auth.canCheckBiometrics;
                          if (listBiometric.isEmpty) {
                            showCustomDialog('Failed', 'Biometric not enrolled on this device', 'Dismiss');
                            return;
                          }
                
                          if (x) {
                            bool b = await onConfirmBiometric();
                            if (b == true) {
                              onBiometric();
                            }
                
                            else {
                              ctrl.setIsBiometricEnabled(false);
                            }
                          }
                
                          else {
                            showCustomDialog('Failed', 'Biometric not enrolled on this device', 'Dismiss');
                          }
                        }
                
                        on PlatformException catch (_) {
                          showCustomDialog('Failed', 'Biometric not enrolled on this device', 'Dismiss');
                        }
                
                        on DioException catch (error) {
                          handleError(error, onBiometric);
                        }
                
                        catch (error) {
                          showCustomDialog('Failed', error.toString(), 'Dismiss');
                        }
                      }
                
                      else {
                        try {
                          await UserService.addMachineId({ 'machineId': '__disabled__' });
                          await DataManager.remove('__biometric-username__');
                          await DataManager.remove('__biometric-uuid__');
                          Map<dynamic, dynamic>? m = await DataManager.getItem('biometric');
                          if (m != null) {
                            m.remove(AuthManager.username!);
                            await DataManager.setItem('biometric', m);
                          }
                          ctrl.setIsBiometricEnabled(false);
                        }
                
                        catch (_) {
                
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 17.0),
            child: Text(
              'HELP & SUPPORT',
              style: kTextStyle1.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                color: kTextColor2,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Image.asset(
                    'images/icon/privacy.png',
                    width: 16.0,
                    height: 16.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    'Privacy Policy',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18.0),
          InkWell(
            onTap: () {
              
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Image.asset(
                    'images/icon/tnc.png',
                    width: 13.33,
                    height: 16.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    'Terms & Conditions',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 17.0),
          Container(
            width: double.infinity,
            height: 1.0,
            color: kBgColor2,
          ),
          const SizedBox(height: 17.0),
          InkWell(
            onTap: () async {
              bool b = await onSignOut();
              if (b) {
                await AuthManager.signOut();
                //AppointmentManager.stop();
                //OneSignal.shared.removeExternalUserId();
                Get.offAll(() => const SignIn());
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Image.asset(
                    'images/icon/logout.png',
                    width: 16.0,
                    height: 16.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    'Logout',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 9.0),
          Obx(() =>
            Text(
              'Version ${ctrl.version}',
              style: kTextStyle1.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: kTextColor2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 46.0),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() =>
      ModalProgressHUD(
        inAsyncCall: ctrl.isLoading,
        progressIndicator: const AppActivityIndicator(),
        child: buildContent(),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class BackCard extends StatelessWidget {

  final ProfileCtrl ctrl = Get.put(ProfileCtrl());

  BackCard({super.key});

  @override
  Widget build(BuildContext context) {
    String s = ctrl.patientDetails?.prn ?? '';
    return Container(
      height: 200.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 11.0),
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              'images/imgs/logo.png',
              width: 47.74,
              height: 40.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 7.0),
          Container(
            height: 142.0,
            padding: const EdgeInsets.only(left: 40.0, right: 50.0),
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0), bottomRight: Radius.circular(12.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80.0,
                  height: 80.0,
                  child: QrImageView(
                    data: s,
                    version: QrVersions.auto,
                    dataModuleStyle: const QrDataModuleStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 33.0),
                Expanded(
                  child: BarcodeWidget(
                    barcode: Barcode.code128(),
                    data: s,
                    height: 48.0,
                    color: Colors.white,
                    drawText: false,
                  ),
                ),
                // Expanded(
                //   child: BarcodeWidget(
                //     barcode: Barcode.code128(), // Barcode type and settings
                //     data: s, // Content
                //     width: 105.0,
                //     height: 48.0,
                //     color: Colors.white,
                //     drawText: false,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FrontCard extends StatelessWidget {

  final ProfileCtrl ctrl = Get.put(ProfileCtrl());

  FrontCard({super.key});

  @override
  Widget build(BuildContext context) {
    String s = '';
    if (ctrl.patientDetails != null) {
      Name name = ctrl.patientDetails!.name!;
      s = '${name.title} ${name.firstName} ${name.middleName} ${name.lastName}';
    }

    return Container(
      height: 200.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 11.0),
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              'images/imgs/logo.png',
              width: 47.74,
              height: 40.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 7.0),
          Container(
            height: 142.0,
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0), bottomRight: Radius.circular(12.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 35.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50.0,
                      child: Text(
                        'PRN: ',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFF8F8F8),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Obx(() =>
                        Text(
                          ctrl.patientDetails?.prn ?? '',
                          style: kTextStyle1.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFF8F8F8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50.0,
                      child: Text(
                        'Name: ',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFF8F8F8),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        s,
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFF8F8F8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}