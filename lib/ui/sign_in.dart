import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/sign_in_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/country_data.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/notification_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';
import 'package:vesalius_m_flutter/services/common_service.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';
import 'package:vesalius_m_flutter/ui/sign-in/biometric.dart';
import 'package:vesalius_m_flutter/ui/sign-in/verify_email_code.dart';
import 'package:vesalius_m_flutter/ui/sign-in/verify_otp.dart';

import 'guest.dart';
import 'main_layout.dart';
import 'patient_survey.dart';
import 'select_country.dart';
import 'select_tel.dart';
import 'sign-in/forgot_password.dart';
import 'sign_up.dart';

class SignIn extends StatefulWidget {

  final String? email;

  const SignIn({
    super.key,
    this.email,
  });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  String deviceId = '';
  Map<String, dynamic> deviceData = <String, dynamic>{};
  List<BiometricType>? listBiometric;
  final LocalAuthentication auth = LocalAuthentication();
  final formKey = GlobalKey<FormState>();
  late final TextEditingController txtusername;
  late final TextEditingController txtpwd;
  late final TextEditingController txtcontact1;
  late final TextEditingController txtcontact2;
  static const AndroidId androidIdPlugin = AndroidId();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  final SignInCtrl ctrl = Get.put(SignInCtrl());

  @override
  void initState() {
    super.initState();
    txtusername = TextEditingController();
    txtpwd = TextEditingController();
    txtcontact1 = TextEditingController();
    txtcontact2 = TextEditingController();
    load();
  }

  @override
  void dispose() {
    txtusername.dispose();
    txtpwd.dispose();
    txtcontact1.dispose();
    txtcontact2.dispose();
    super.dispose();
  }

  void load() async {
    await initPlatformState();
  }

  Future<void> initPlatformState() async {
    String uname = await DataManager.instance.read('username') ?? '';
    String signinType = await DataManager.instance.read('signinType') ?? '1';
    String hp1 = await DataManager.instance.read('contact1') ?? '';
    String hp2 = await DataManager.instance.read('contact2') ?? '';
    ctrl.setSignInOpt(signinType == '1' ? SignInOpt.mobile : SignInOpt.email);
    txtusername.text = widget.email ?? 'eugene.lim@nova-hub.com';
    txtpwd.text = 'Abcd1234';
    if (uname.isNotEmpty && ctrl.signInOpt == SignInOpt.email) {
      txtusername.text = uname;
    }

    if (hp1.isNotEmpty) {
      txtcontact1.text = hp1;
    }

    if (hp2.isNotEmpty) {
      txtcontact2.text = hp2;
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    ctrl.setVersion(packageInfo.version);
    ctrl.setBuild(packageInfo.buildNumber);
    try {
      if (Platform.isAndroid) {
        deviceId = await androidIdPlugin.getId() ?? '';
        deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      }

      else {
        final IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
        deviceId = data.identifierForVendor ?? '';
        deviceData = readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }

      listBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (_) {
      listBiometric = [];
    }

    bool biometricEnabled = false;
    String username = await DataManager.instance.read('__biometric-username__') ?? '';
    Map<dynamic, dynamic>? m = await DataManager.instance.getItem('biometric');
    if (m != null && m.containsKey(username)) {
      biometricEnabled = true;
    }

    ctrl.setIsBiometricEnabled(biometricEnabled);

    // await OneSignal.shared.setAppId(kOneSignalAppID);

    OneSignal.Notifications.addForegroundWillDisplayListener(NotificationManager.instance.foregroundWillDisplayListener);

    // OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    //   final notification = result.notification;
    //   NotificationManager.instance.hasNotification = true;
    //   if (notification.additionalData!['type'] == 'survey') {
    //     NotificationManager.instance.type = 'survey';
    //   }

    //   else {
    //     NotificationManager.instance.type = 'appt';
    //   }
    // });

    await OneSignal.Notifications.requestPermission(true);
  }

  Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'name': build.name,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'freeDiskSize': build.freeDiskSize,
      'totalDiskSize': build.totalDiskSize,
      'systemFeatures': build.systemFeatures,
      'isLowRamDevice': build.isLowRamDevice,
      'physicalRamSize': build.physicalRamSize,
      'availableRamSize': build.availableRamSize,
    };
  }

  Map<String, dynamic> readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'modelName': data.modelName,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'isiOSAppOnMac': data.isiOSAppOnMac,
      'freeDiskSize': data.freeDiskSize,
      'totalDiskSize': data.totalDiskSize,
      'physicalRamSize': data.physicalRamSize,
      'availableRamSize': data.availableRamSize,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  void loadCountry() async {
    try {
      if (ctrl.countryList.isEmpty) {
        ctrl.setIsLoading(true);
        final lx = await CommonService.getCountries();
        lx.sort((a, b) {
          return a.countryName.toLowerCase().compareTo(b.countryName.toLowerCase());
        });
        final cx1 = lx.firstWhereOrNull((x) => x.countryName.toLowerCase() == 'malaysia');
        final cx2 = lx.firstWhereOrNull((x) => x.countryName.toLowerCase() == 'singapore');
        final cx3 = lx.firstWhereOrNull((x) => x.countryName.toLowerCase() == 'indonesia');
        if (cx3 != null) {
          lx.removeWhere((x) => x.countryName.toLowerCase() == 'indonesia');
          lx.insert(0, cx3);
        }

        if (cx2 != null) {
          lx.removeWhere((x) => x.countryName.toLowerCase() == 'singapore');
          lx.insert(0, cx2);
        }

        if (cx1 != null) {
          lx.removeWhere((x) => x.countryName.toLowerCase() == 'malaysia');
          lx.insert(0, cx1);
        }

        ctrl.setCountryList(lx);
        ctrl.setIsLoading(false);
      }

      final c = await Get.to<Country?>(() => SelectCountry(selected: ctrl.selectedCountry, list: ctrl.countryList));
      ctrl.setSelectedCountry(c);
      FocusManager.instance.primaryFocus?.unfocus();
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, loadCountry);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  void loadTel() async {
    try {
      if (ctrl.telList.isEmpty) {
        ctrl.setIsLoading(true);
        final lx = await CommonService.getTelCountries();
        ctrl.setTelList(lx);
        ctrl.setIsLoading(false);
      }

      final c = await Get.to<CountryTel?>(() => SelectTel(selected: ctrl.selectedTel, list: ctrl.telList));
      ctrl.setSelectedTel(c);
      txtcontact1.text = c?.telCode ?? '';
      validate(txtcontact1.text);
      FocusManager.instance.primaryFocus?.unfocus();
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, loadTel);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  void validate(String s) {
    bool b = formKey.currentState!.validate();

    if (s.isEmpty) {
      ctrl.setIsValid(false);
    }

    else {
      ctrl.setIsValid(b);
    }
  }

  void onPopInvokedWithResult(bool didPop, result) async {
    if (didPop) return;
    bool b = await showConfirmDialog('Are you sure you want to exit ?');
    if (b) {
      SystemNavigator.pop();
    }
  }

  void onLoginMobile() async {
    try {
      if (txtcontact1.text.isEmpty || txtcontact2.text.isEmpty) {
        showCustomDialog('Login Failed', 'Invalid Contact Number', 'Dismiss');
        return;
      }

      String hp2 = txtcontact2.text.trimFirstZero();
      String mobile = '${txtcontact1.text}$hp2';
      ctrl.setIsLoading(true);
      await AuthManager.instance.waitPlayerId();
      await UserService.postPlayerID({
        'playerId': AuthManager.instance.playerId,
        'machineId': deviceId
      });

      final o = {
        'signInType': 1,
        'username': mobile,
        'deviceInfo': jsonEncode(deviceData)
      };
      final m = await AuthService.authenticateMobile(o);
      await DataManager.instance.removeItem('isFirstTimeLogin');
      ctrl.setIsLoading(false);
      if (m['smsTacSent'] == true) {
        Get.to(() => VerifyOTP(
          type: 'verify-mobile-signin',
          mobile: mobile,
          contact1: txtcontact1.text,
          contact2: hp2,
        ));
        /* if (isFirstTimeLogin) {
          await DataManager.instance.setItem('isFirstTimeLogin', true);
          Get.to(() => VerifyOTP(
            type: 'verify-mobile-signup-signin',
            mobile: mobile,
            contact1: txtcontact1.text,
            contact2: hp2,
          ));
        }

        else {
          Get.to(() => VerifyOTP(
            type: 'verify-mobile-signin',
            mobile: mobile,
            contact1: txtcontact1.text,
            contact2: hp2,
          ));
        } */
      }

      else {
        showCustomDialog('OTP not sent', 'OTP failed to be sent', 'Dismiss');
      }
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 400) {
        final mx = error.response?.data as Map?;
        if (mx?.containsKey('message') ?? false) {
          showCustomDialog('Error', mx?['message'], 'Dismiss');
        }

        else {
          showCustomDialog('Login Failed', 'Invalid Contact Number', 'Dismiss');
        }
      }

      else {
        handleError(error, onLogin);
      }
    }

    catch (_) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', kError, 'Dismiss');
    }
  }

  void onLoginEmail() async {
    try {
      if (txtusername.text.isEmpty || txtpwd.text.isEmpty) {
        showCustomDialog('Login Failed', 'Incorrect Email or Password', 'Dismiss');
        return;
      }

      ctrl.setIsLoading(true);
      await AuthManager.instance.waitPlayerId();
      await UserService.postPlayerID({
        'playerId': AuthManager.instance.playerId,
        'machineId': deviceId
      });

      final o = {
        'signInType': 2,
        'username': txtusername.text,
        'password': txtpwd.text,
        'playerId': AuthManager.instance.playerId,
        'machineId': deviceId,
        'deviceInfo': jsonEncode(deviceData)
      };
      final m = await AuthService.authenticateEmail(o);
      final x = m['data'];
      await DataManager.instance.removeItem('isFirstTimeLogin');
      await DataManager.instance.removeItem('isFirstTimeBiometric');
      bool isFirstTimeLogin = x['isFirstTimeLogin'];
      bool isFirstTimeBiometric = x['isFirstTimeBiometric'];
      if (isFirstTimeLogin) {
        await DataManager.instance.setItem('isFirstTimeLogin', true);
        await DataManager.instance.setItem('isFirstTimeBiometric', true);
        await AuthManager.instance.set(m['token'], x['role'], isFirstTimeLogin, isFirstTimeBiometric, txtusername.text, false, 2, '', '');
      }

      else {
        await AuthManager.instance.set(m['token'], x['role'], isFirstTimeLogin, isFirstTimeBiometric, txtusername.text, true, 2, '', '');
        String username = await DataManager.instance.read('__biometric-username__') ?? '';
        if (username.isNotEmpty) {
          await DataManager.instance.write('__biometric-username__', txtusername.text);
        }
      }

      if (x['role'] == 'USER') {
        UserDetails? o = await UserService.getUser();
        if (o != null) {
          await DataManager.instance.setUserDetails(o);
          if (o.userBranches.isNotEmpty) {
            await DataManager.instance.setBranchDetails(o.userBranches.first);
            PatientDetails? patientData = await VesaliusService.getVesaliusPatientData(o.userBranches.first.branch!.branchId!, o.userBranches.first.prn!);
            if (patientData != null) {
              await DataManager.instance.setPatientDetails(patientData);
              DataManager.instance.setPrn(o.userBranches.first.prn!);
              //await OneSignal.shared.setExternalUserId(o.userBranches![0].prn!);
              //await StorageDataManager.addUser(o.email!);
              // await DataManager.setUserDetails(o);
            }
          }
        }
      }
      ctrl.setIsLoading(false);
      if (isFirstTimeLogin) {
        Get.to(() => VerifyEmailCode(
          type: 'verify-email-signin',
          email: txtusername.text,
        ));
      }

      else if (isFirstTimeBiometric && !isFirstTimeLogin) {
        Get.to(() => const Biometric());
      }

      else {
        Get.offAll(() => const MainLayout());
        if (NotificationManager.instance.hasNotification) {
          if (NotificationManager.instance.type == 'survey') {
            Get.to(() => const PatientSurvey());
          }

          else {
            //Get.to(() => const AppointmentDetail());
          }

          NotificationManager.instance.reset();
        }
      }
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 401) {
        showCustomDialog('Login Failed', 'Incorrect Email or Password', 'Dismiss');
      }

      else if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 400) {
        final mx = error.response?.data as Map?;
        if (mx?.containsKey('message') ?? false) {
          showCustomDialog('Error', mx?['message'], 'Dismiss');
        }

        else {
          showCustomDialog('Login Failed', 'Incorrect Email or Password', 'Dismiss');
        }
      }

      else {
        handleError(error, onLogin);
      }
    }

    catch (_) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', kError, 'Dismiss');
    }
  }

  void onLogin() async {
    if (ctrl.signInOpt == SignInOpt.email) {
      onLoginEmail();
    }

    else if (ctrl.signInOpt == SignInOpt.mobile) {
      onLoginMobile();
    }
  }

  void biometricLogin() async {
    String username = await DataManager.instance.read('__biometric-username__') ?? '';
    bool allowBiometricAuth = username.isEmpty ? false : true;

    try {
      if (!allowBiometricAuth) {
        showCustomDialog('Error', 'Biometric not enabled on this device', 'Dismiss');
        return;
      }

      bool x = await auth.canCheckBiometrics;
      if (x) {
        String s = 'fingerprint';
        if (listBiometric?.contains(BiometricType.face) ?? false) {
          s = 'face';
        }

        bool a = await auth.authenticate(
          localizedReason: 'Please scan your $s to authenticate',
          biometricOnly: true,
          persistAcrossBackgrounding: true,
        );
        if (a) {
          ctrl.setIsLoading(true);
          await AuthManager.instance.waitPlayerId();
          await UserService.postPlayerID({
            'playerId': AuthManager.instance.playerId,
            'machineId': deviceId
          });

          final o = {
            'signInType': 2,
            'username': username,
            'password': deviceId,
            'playerId': AuthManager.instance.playerId,
            'fromBiometric': 1,
            'deviceInfo': jsonEncode(deviceData)
          };
          var m = await AuthService.authenticateEmail(o);
          var x = m['data'];
          await AuthManager.instance.set(m['token'], x['role'], false, false, username, true, 2, '', '');
          if (x['role'] == 'USER') {
            UserDetails? o = await UserService.getUser();
            if (o != null) {
              await DataManager.instance.setUserDetails(o);
              if (o.userBranches.isNotEmpty) {
                await DataManager.instance.setBranchDetails(o.userBranches.first);
                PatientDetails? patientData = await VesaliusService.getVesaliusPatientData(o.userBranches.first.branch!.branchId!, o.userBranches.first.prn!);
                if (patientData != null) {
                  await DataManager.instance.setPatientDetails(patientData);
                  DataManager.instance.setPrn(o.userBranches.first.prn!);
                  //await OneSignal.shared.setExternalUserId(o.userBranches![0].prn!);
                  //await StorageDataManager.addUser(o.email!);
                  // await DataManager.setUserDetails(o);
                }
              }
            }
          }
          ctrl.setIsLoading(false);
          Get.off(() => const MainLayout());
        }
      }

      else {
        showCustomDialog('Error', 'Biometric not enrolled on this device', 'Dismiss');
      }
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 401) {
        showCustomDialog('Error', 'Biometric authentication failed', 'Dismiss');
      }

      else if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 400) {
        final mx = error.response?.data as Map?;
        if (mx?.containsKey('message') ?? false) {
          showCustomDialog('Error', mx?['message'], 'Dismiss');
        }

        else {
          showCustomDialog('Error', 'Biometric authentication failed', 'Dismiss');
        }
      }

      else {
        handleError(error, biometricLogin);
      }
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', kError, 'Dismiss');
    }
  }

  List<Widget> buildGuest() {
    return [
      const SizedBox(height: 16.0),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: AppOutlinedButton(
          text: 'Continue As Guest',
          onPressed: () => Get.off(() => const Guest()),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Not an existing user?',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: kTextColor2,
            ),
          ),
          TextButton(
            onPressed: () {
              Get.to(() => const SignUp());
            },
            style: TextButton.styleFrom(
              foregroundColor: kPrimaryColor,
            ),
            child: Text(
              'Sign Up',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        width: double.infinity,
        child: Obx(() =>
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
      ),
      const SizedBox(height: 16.0),
    ];
  }

  Widget buildForm() {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 180.0),
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Welcome!\nSign In to Continue',
                        style: kTextStyle1.copyWith(
                          fontFamily: kFont2,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),

                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Sign In Method',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Obx(() => 
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(color: ctrl.signInOpt == SignInOpt.mobile ? kTextColor1 : const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                                      blurRadius: 8.0,
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: InkWell(
                                    onTap: () {
                                      ctrl.setSignInOpt(SignInOpt.mobile);
                                      Future.delayed(const Duration(milliseconds: 100), () {
                                        validate(txtcontact1.text);
                                        validate(txtcontact2.text);
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                      child: Text(
                                        'Mobile Number',
                                        style: kTextStyle1.copyWith(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                          color: ctrl.signInOpt == SignInOpt.mobile ? kTextColor1 : kTextColor2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Obx(() =>
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(color: ctrl.signInOpt == SignInOpt.email ? kTextColor1 : const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                                      blurRadius: 8.0,
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: InkWell(
                                    onTap: () {
                                      ctrl.setSignInOpt(SignInOpt.email);
                                      Future.delayed(const Duration(milliseconds: 100), () {
                                        validate(txtusername.text);
                                        validate(txtpwd.text);
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                      child: Text(
                                        'Email Address',
                                        style: kTextStyle1.copyWith(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                          color: ctrl.signInOpt == SignInOpt.email ? kTextColor1 : kTextColor2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    
                          /* Obx(() =>
                            Radio<SignInOpt>(
                              value: SignInOpt.mobile,
                              groupValue: ctrl.signInOpt,
                              activeColor: kPrimaryColor,
                              onChanged: (value) {
                                ctrl.setSignInOpt(value);
                                Future.delayed(const Duration(milliseconds: 100), () {
                                  validate(txtcontact1.text);
                                  validate(txtcontact2.text);
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Mobile Number',
                              style: kTextStyle1.copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                          Obx(() =>
                            Radio<SignInOpt>(
                              value: SignInOpt.email,
                              groupValue: ctrl.signInOpt,
                              activeColor: kPrimaryColor,
                              onChanged: (value) {
                                ctrl.setSignInOpt(value);
                                Future.delayed(const Duration(milliseconds: 100), () {
                                  validate(txtusername.text);
                                  validate(txtpwd.text);
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Email Address',
                              style: kTextStyle1.copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                          ), */
                        ],
                      ),
                    ),
                    const SizedBox(height: 12.0),

                    if (ctrl.signInOpt == SignInOpt.mobile) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Mobile Number',
                          style: kTextStyle1.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: kTextColor1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 78.85,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: kBgColor2.withValues(alpha: 0.1),
                                    offset: const Offset(0.0, 4.0),
                                    blurRadius: 4.0,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.always,
                                onChanged: validate,
                                validator: ValidationBuilder(requiredMessage: 'Contact Number is required').required().minLength(1, 'Contact Number is required').build(),
                                controller: txtcontact1,
                                readOnly: true,
                                cursorColor: kTextColor1,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontFamily: kBodyFont,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: kTextColor1,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(15.0),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: '+60',
                                  hintStyle: kTextStyle1.copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    color: kTextColor5,
                                  ),
                                  errorStyle: const TextStyle(
                                    fontFamily: kBodyFont,
                                    color: kTextColor3,
                                  ),
                                  enabledBorder: kEnabledBorder,
                                  focusedBorder: kFocusedBorder,
                                  errorBorder: kErrorBorder,
                                  focusedErrorBorder: kFocusedErrorBorder,
                                ),
                                onTap: loadTel,
                              ),
                            ),
                            const SizedBox(width: 13.0),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: kBgColor2.withValues(alpha: 0.1),
                                      offset: const Offset(0.0, 4.0),
                                      blurRadius: 4.0,
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.always,
                                  onChanged: validate,
                                  validator: ValidationBuilder(requiredMessage: 'Contact Number is required').required().minLength(1, 'Contact Number is required').build(),
                                  controller: txtcontact2,
                                  cursorColor: kTextColor1,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    fontFamily: kBodyFont,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    color: kTextColor1,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15.0),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Contact Number',
                                    hintStyle: kTextStyle1.copyWith(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                      color: kTextColor5,
                                    ),
                                    errorStyle: const TextStyle(
                                      fontFamily: kBodyFont,
                                      color: kTextColor3,
                                    ),
                                    enabledBorder: kEnabledBorder,
                                    focusedBorder: kFocusedBorder,
                                    errorBorder: kErrorBorder,
                                    focusedErrorBorder: kFocusedErrorBorder,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    if (ctrl.signInOpt == SignInOpt.email) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Email',
                          style: kTextStyle1.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: kTextColor1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kBgColor2.withValues(alpha: 0.1),
                              offset: const Offset(0.0, 4.0),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: 'Email is required').required().minLength(1, 'Email is required').build(),
                          controller: txtusername,
                          cursorColor: kTextColor1,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15.0),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'e.g.JohnSmith@abc.com',
                            hintStyle: kTextStyle1.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor5,
                            ),
                            enabledBorder: kEnabledBorder,
                            focusedBorder: kFocusedBorder,
                            errorBorder: kErrorBorder,
                            focusedErrorBorder: kFocusedErrorBorder,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Password',
                          style: kTextStyle1.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: kTextColor1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kBgColor2.withValues(alpha: 0.1),
                              offset: const Offset(0.0, 4.0),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: Obx(() =>
                          TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            onChanged: validate,
                            validator: ValidationBuilder(requiredMessage: 'Password is required').required().minLength(1, 'Password is required').build(),
                            controller: txtpwd,
                            obscureText: ctrl.isPwd,
                            cursorColor: kTextColor1,
                            style: const TextStyle(
                              fontFamily: kBodyFont,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor1,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15.0),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Enter Password',
                              hintStyle: kTextStyle1.copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor5,
                              ),
                              suffixIcon: Material(
                                color: Colors.white,
                                type: MaterialType.transparency,
                                child: IconButton(
                                  onPressed: () {
                                    ctrl.setIsPwd(!ctrl.isPwd);
                                  },
                                  icon: Obx(() =>
                                    Icon(
                                      ctrl.isPwd ? Icons.visibility_off : Icons.visibility,
                                      color: kTextColor1,
                                    ),
                                  ),
                                  color: kTextColor1,
                                  splashRadius: 22.0,           
                                ),
                              ),
                              enabledBorder: kEnabledBorder,
                              focusedBorder: kFocusedBorder,
                              errorBorder: kErrorBorder,
                              focusedErrorBorder: kFocusedErrorBorder,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () {
                              Get.to(() => const ForgotPassword());
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: kPrimaryColor,
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        Obx(() => ctrl.isBiometricEnabled && ctrl.signInOpt == SignInOpt.email ?
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: kBgColor1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(() =>
                            AppElevatedButton(
                              text: 'Sign In',
                              onPressed: !ctrl.isValid ? null : onLogin,
                            ),
                          ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(5.0),
                          child: InkWell(
                            onTap: biometricLogin,
                            borderRadius: BorderRadius.circular(5.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                Platform.isAndroid ?
                                'images/imgs/fingerprint.png' :
                                'images/imgs/face.png',
                                width: 48.0,
                                height: 48.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...buildGuest(),
                ],
              ),
            ),
          ) :
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: kBgColor1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Obx(() =>
                      AppElevatedButton(
                        text: 'Sign In',
                        onPressed: !ctrl.isValid ? null : onLogin,
                      ),
                    ),
                  ),
                  ...buildGuest(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
          toolbarHeight: 0.0,
          backgroundColor: kBgColor1,
          elevation: 0.0,
        ),
        backgroundColor: kBgColor1,
        body: SafeArea(
          child: Obx(() =>
            ModalProgressHUD(
              inAsyncCall: ctrl.isLoading,
              blur: kBlur,
              progressIndicator: const AppActivityIndicator(),
              child: buildForm(),
            ),
          ),
        ),
      ),
    );
  }
}
