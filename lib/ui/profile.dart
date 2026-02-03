import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/no_network.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/profile_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';
import 'package:vesalius_m_flutter/services/common_service.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';
import 'package:vesalius_m_flutter/ui/guest.dart';
import 'package:vesalius_m_flutter/ui/profile/my_profile.dart';

import 'profile/change_password.dart';
import 'profile/my_package.dart';
import 'sign_in.dart';

class Profile extends StatefulWidget {

  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin<Profile> {

  String deviceId = '';
  List<BiometricType> listBiometric = [];
  ScrollController scr = ScrollController();
  final LocalAuthentication auth = LocalAuthentication();
  static const AndroidId androidIdPlugin = AndroidId();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  final ProfileCtrl ctrl = Get.put(ProfileCtrl());

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      await AuthManager.instance.load();
      initPlatformState();
      final la = await CommonService.getAuthModeServices();
      final delAccount = la.firstWhereOrNull((x) => x.name == 'DeleteAccount');
      final purchase = la.firstWhereOrNull((x) => x.name == 'PurchaseAndPayment');
      ctrl.setDelAccount(delAccount == null ? kDelAcc : true);
      ctrl.setPurchase(purchase == null ? kPurchase : true);
      final hospitalData = await CommonService.getHospitalInfo();
      ctrl.setHospitalData(hospitalData);
      UserBranch? branchDetails = DataManager.instance.branchDetails;
      PatientDetails? patientData = await DataManager.instance.getPatientDetails();
      if (patientData == null) {
        patientData = await VesaliusService.getVesaliusPatientData(branchDetails!.branch!.branchId!, branchDetails.prn!);
        await DataManager.instance.setPatientDetails(patientData);
      }
      
      ctrl.setPatientDetails(patientData);
      ctrl.setIsLoading(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, load);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
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
    Map<dynamic, dynamic>? m = await DataManager.instance.getItem('biometric');
    if (m != null && m.containsKey(AuthManager.instance.username!)) {
      biometricEnabled = true;
    }

    ctrl.setIsBiometricEnabled(biometricEnabled);
    ctrl.setVersion(packageInfo.version);
    ctrl.setBuild(packageInfo.buildNumber);
  }

  void showSuccessDeleteAccount() {
    Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/icon/tick.png',
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Account Deletion Successful',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Your account has been deleted and all data has been permanently removed. If you decide to return, signing up a new account is just a few clicks away!',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Done',
              onPressed: () async {
                Get.back();
                try {
                  await AuthManager.instance.signOut();
                  Get.offAll(() => const Guest());
                }

                catch (_) {
                  ctrl.setIsLoading(false);
                  showCustomDialog('Error', 'Unable to logout at the moment. Please check your internet connection or try again later.', 'Dismiss');
                }
              },
            ),
          ],
        ),
      ),
    ));
  }

  void onConfirmSubmitDeleteAccount() async {
    try {
      ctrl.setIsLoading(true);
      await UserService.deleteAccount();
      ctrl.setIsLoading(false);
      showSuccessDeleteAccount();
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      if (error.type == DioExceptionType.badResponse) {
        final mx = error.response?.data as Map?;
        if (mx?.containsKey('errorMessage') ?? false) {
          showCustomDialog('Error', mx?['errorMessage'], 'Dismiss');
        }

        else if (mx?.containsKey('message') ?? false) {
          showCustomDialog('Error', mx?['message'], 'Dismiss');
        }
        
        else {
          showCustomDialog('Error', 'Delete Account failed', 'Dismiss');
        }
      }

      else if (error.type == DioExceptionType.connectionError) {
        Get.to(() => NoNetwork(
          onPressed: () {
            onConfirmSubmitDeleteAccount();
          },
        ));
      }

      else {
        showCustomDialog('Error', 'Delete Account failed', 'Dismiss');
      }
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  void onSubmitDeleteAccount() async {
    bool b = await Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Are You Sure?',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Please be aware that deleting your account will remove all your account data and you will need to Sign Up again to use our services.',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back(result: false);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kTextColor2,
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      side: const BorderSide(
                        color: Color(0xFFDBDBDB),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18.0),
                Expanded(
                  child: AppElevatedButton(
                    text: 'Delete',
                    onPressed: () => Get.back(result: true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )) ?? false;
    if (b) {
      onConfirmSubmitDeleteAccount();
    }
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
      biometricOnly: true,
      persistAcrossBackgrounding: true,
    );
    if (a) {
      await UserService.addMachineId({ 'machineId': deviceId });
      await DataManager.instance.write('__biometric-username__', AuthManager.instance.username!);
      await DataManager.instance.write('__biometric-uuid__', deviceId);
      Map<dynamic, dynamic>? m = await DataManager.instance.getItem('biometric');
      m ??= <dynamic, dynamic>{};
      m[AuthManager.instance.username!] = 1;
      await DataManager.instance.setItem('biometric', m);
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
                color: kPrimaryColor,
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

  String get patientName {
    return ctrl.patientDetails?.displayName ?? '';
  }

  String get patientDOB {
    String s = '';
    if (ctrl.patientDetails != null) {
      String? dob = ctrl.patientDetails!.dob;
      if (dob != null) {
        final dt = DateFormat('dd-MMM-yyyy').parse(dob);
        s = DateFormat('dd/MM/yyyy').format(dt);
      }
    }

    return s;
  }

  String get patientNRIC {
    String s = '';
    if (ctrl.patientDetails != null) {
      Document? doc = ctrl.patientDetails!.documents.firstWhereOrNull((o) => o.code == 'ID');
      if (doc != null) {
        s = doc.value ?? '';
      }
    }

    return s;
  }

  String get patientGender {
    String s = '';
    if (ctrl.patientDetails != null) {
      s = ctrl.patientDetails!.sex?.description ?? '';
    }

    return s;
  }

  Widget buildContent() {
    return Obx(() => ctrl.isLoading ? Container() : 
    Scrollbar(
      controller: scr,
      child: ListView(
        controller: scr,
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 30.0, bottom: 24.0),
            child: Text(
              'Profile',
              style: kTextStyle1.copyWith(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: kPrimaryColor,
              ),
            ),
          ),
          /* FlipCard(
            front: FrontCard(),
            back: BackCard(),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Tap to flip the card',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: kTextColor2,
            ),
            textAlign: TextAlign.center,
          ), */

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'images/imgs/ihp.png',
                    width: 122.07,
                    height: 32.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Name',
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor4,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  patientName,
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor4,
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'DOB',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor4,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'NRIC',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        patientDOB,
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor4,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        patientNRIC,
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'PRN',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor4,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Gender',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ctrl.patientDetails?.prn ?? '',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor4,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        patientGender,
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BarcodeWidget(
                    barcode: Barcode.code128(),
                    data: ctrl.patientDetails?.prn ?? '',
                    height: 40.0,
                    color: Colors.black,
                    drawText: false,
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor4,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  ctrl.hospitalData?.website ?? 'www.hospitalmetro.com',
                  style: kTextStyle1.copyWith(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          makePhoneCallNum(ctrl.hospitalData?.contactInfoApptCall ?? '+6044238888');
                        },
                        borderRadius: BorderRadius.circular(5.0),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'Contact ${ctrl.hospitalData?.contactInfoApptDisplay ?? '+604 4238888'}',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor6,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '|',
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor6,
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          makePhoneCallNum(ctrl.hospitalData?.contact24Call ?? '+6044238888');
                        },
                        borderRadius: BorderRadius.circular(5.0),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'Emergency Hotline ${ctrl.hospitalData?.contact24Display ?? '+6044238888'}',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor6,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'International Patient Service',
                        style: kTextStyle1.copyWith(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Material(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          launchWANum(ctrl.hospitalData?.contactWhatsAppCall ?? '6044238888');
                        },
                        borderRadius: BorderRadius.circular(5.0),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/icon/wa.png',
                                width: 16.0,
                                height: 16.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                ctrl.hospitalData?.contactWhatsAppDisplay ?? '+6044238888',
                                style: kTextStyle1.copyWith(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w400,
                                  color: kTextColor6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),


                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       'www.islandhospital.com',
                //       style: kTextStyle1.copyWith(
                //         fontSize: 9.0,
                //         fontWeight: FontWeight.w400,
                //         color: kTextColor6,
                //       ),
                //     ),
                //     Text(
                //       'Contact +604 238 3388',
                //       style: kTextStyle1.copyWith(
                //         fontSize: 9.0,
                //         fontWeight: FontWeight.w400,
                //         color: kTextColor6,
                //       ),
                //     ),
                //     Text(
                //       'Emergency Hotline +6042268527',
                //       style: kTextStyle1.copyWith(
                //         fontSize: 9.0,
                //         fontWeight: FontWeight.w400,
                //         color: kTextColor6,
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 4.0),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Text(
                //       'International Patient Service +62896-1300-9999',
                //       style: kTextStyle1.copyWith(
                //         fontSize: 9.0,
                //         fontWeight: FontWeight.w400,
                //         color: kTextColor6,
                //       ),
                //     ),
                //     GestureDetector(
                //       onTap: () {
                //         launchWANum('6289613009999');
                //       },
                //       child: Row(
                //         children: [
                //           Image.asset(
                //             'images/icon/wa.png',
                //             width: 16.0,
                //             height: 16.0,
                //             fit: BoxFit.cover,
                //           ),
                //           const SizedBox(width: 6.0),
                //           Text(
                //             '+62896-1300-9999',
                //             style: kTextStyle1.copyWith(
                //               fontSize: 9.0,
                //               fontWeight: FontWeight.w400,
                //               color: kTextColor6,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 24.0, bottom: 17.0),
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
              Get.to(() => const MyProfile());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Image.asset(
                    'images/icon/profile1.png',
                    width: 16.0,
                    height: 16.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    'My Profile',
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
          if (AuthManager.instance.signinType == 2) ...[
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
                      activeThumbColor: const Color(0xFF08B86E),
                      onChanged: (value) async {
                        if (value) {
                          try {
                            bool x = await auth.canCheckBiometrics;
                            if (listBiometric.isEmpty) {
                              showCustomDialog('Error', 'Biometric not enrolled on this device', 'Dismiss');
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
                              showCustomDialog('Error', 'Biometric not enrolled on this device', 'Dismiss');
                            }
                          }
                  
                          on PlatformException catch (_) {
                            showCustomDialog('Error', 'Biometric not enrolled on this device', 'Dismiss');
                          }
                  
                          on DioException catch (error) {
                            handleError(error, onBiometric);
                          }
                  
                          catch (error) {
                            showCustomDialog('Error', error.toString(), 'Dismiss');
                          }
                        }
                  
                        else {
                          try {
                            await UserService.addMachineId({ 'machineId': '__disabled__' });
                            await DataManager.instance.remove('__biometric-username__');
                            await DataManager.instance.remove('__biometric-uuid__');
                            Map<dynamic, dynamic>? m = await DataManager.instance.getItem('biometric');
                            if (m != null) {
                              m.remove(AuthManager.instance.username!);
                              await DataManager.instance.setItem('biometric', m);
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
          ],

          if (ctrl.purchase) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 14.0, bottom: 17.0),
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
                Get.to(() => const MyPackage());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Image.asset(
                      'images/icon/cart1.png',
                      width: 16.0,
                      height: 16.0,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                      'My Packages',
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
            
            const SizedBox(height: 15.0),
          ],
          
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            width: double.infinity,
            height: 1.0,
            color: kBgColor2,
          ),
          if (ctrl.delAccount) ...[
            const SizedBox(height: 17.0),
            InkWell(
              onTap: onSubmitDeleteAccount,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Image.asset(
                      'images/icon/delete1.png',
                      width: 12.38,
                      height: 14.63,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                      'Delete Account',
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
          ],
          
          const SizedBox(height: 17.0),
          InkWell(
            onTap: () async {
              bool b = await onSignOut();
              if (b) {
                try {
                  // ctrl.setIsLoading(true);
                  // await AuthService.logout();
                  await AuthManager.instance.signOut();
                  // ctrl.setIsLoading(false);
                  Get.offAll(() => const SignIn());
                }

                catch (_) {
                  ctrl.setIsLoading(false);
                  showCustomDialog('Error', 'Unable to logout at the moment. Please check your internet connection or try again later.', 'Dismiss');
                }
                
                //AppointmentManager.stop();
                //OneSignal.shared.removeExternalUserId();
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
                      color: kTextColor3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 9.0),
          Obx(() =>
            Text(
              ctrl.build == '1' ? 'Version ${ctrl.version}' : 'Version ${ctrl.version} (${ctrl.build})',
              style: kTextStyle1.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: kTextColor2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16.0),
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
        blur: kBlur,
        progressIndicator: const AppActivityIndicator(),
        child: buildContent(),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => false;
}

class BackCard extends StatelessWidget {

  final ProfileCtrl ctrl = Get.put(ProfileCtrl());

  BackCard({super.key});

  @override
  Widget build(BuildContext context) {
    String s = ctrl.patientDetails?.prn ?? '';
    return Container(
      height: 200.0,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: const Color(0xFFDBDBDB).withValues(alpha: 0.65),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.asset(
              'images/imgs/cardb.png',
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 70.94),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 71.0,
                    height: 71.0,
                    child: QrImageView(
                      data: s,
                      version: QrVersions.auto,
                      dataModuleStyle: const QrDataModuleStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30.0),
                  Expanded(
                    child: BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: s,
                      height: 48.0,
                      color: Colors.black,
                      drawText: true,
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor4,
                      ),
                    ),
                  ),
                ],
              ),
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
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: const Color(0xFFDBDBDB).withValues(alpha: 0.65),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.asset(
              'images/imgs/card.png',
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 53.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          color: kPrimaryColor,
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
                            color: kPrimaryColor,
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
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        s,
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor,
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