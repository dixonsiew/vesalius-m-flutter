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
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/sign_in_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/notification_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

import 'appointment/appointment_detail.dart';
import 'first_time_login.dart';
import 'forgot_password.dart';
import 'guest.dart';
import 'main_layout.dart';
import 'patient_survey.dart';
import 'sign_up.dart';

class SignIn extends StatefulWidget {

  static const String routeName = '/SignIn';

  final String? email;

  const SignIn({
    super.key,
    this.email,
  });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  String playerId = '';
  String deviceId = '';
  List<BiometricType>? listBiometric;
  final LocalAuthentication auth = LocalAuthentication();
  final formKey = GlobalKey<FormState>();
  late final TextEditingController txtusername;
  late final TextEditingController txtpwd;
  static const AndroidId androidIdPlugin = AndroidId();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  final SignInCtrl ctrl = Get.put(SignInCtrl());

  @override
  void initState() {
    super.initState();
    txtusername = TextEditingController();
    txtpwd = TextEditingController();
    initPlatformState();
  }

  @override
  void dispose() {
    txtusername.dispose();
    txtpwd.dispose();
    super.dispose();
  }

  void initPlatformState() async {
    txtusername.text = widget.email ?? 'rosalind.yee@nova-hub.com';
    txtpwd.text = 'password';
    try {
      if (Platform.isAndroid) {
        deviceId = await androidIdPlugin.getId() ?? '';
      }

      else {
        final IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
        deviceId = data.identifierForVendor ?? '';
      }

      OSDeviceState? deviceState = await OneSignal.shared.getDeviceState();
      if (deviceState != null) {
        String? userId = deviceState.userId;
        playerId = userId ?? '';
      }

      listBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (_) {
      listBiometric = [];
    }

    bool biometricEnabled = false;
    String username = await DataManager.read('__biometric-username__') ?? '';
    Map<dynamic, dynamic>? m = await DataManager.getItem('biometric');
    if (m != null && m.containsKey(username)) {
      biometricEnabled = true;
    }

    ctrl.setIsBiometricEnabled(biometricEnabled);

    OneSignal.shared.setNotificationWillShowInForegroundHandler(NotificationManager.notificationWillShowInForegroundHandler);

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      final notification = result.notification;
      NotificationManager.hasNotification = true;
      if (notification.additionalData!['type'] == 'survey') {
        NotificationManager.type = 'survey';
      }

      else {
        NotificationManager.type = 'appt';
      }
    });

    if (Platform.isIOS) {
      await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
    }

    await OneSignal.shared.setAppId(kOneSignalAppID);
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

  Future<bool> onWillPop() async {
    return await showConfirmDialog('Are you sure you want to exit ?');
  }

  void onLogin() async {
    try {
      if (txtusername.text.isEmpty || txtpwd.text.isEmpty) {
        showCustomDialog('Login Failed', 'Incorrect Email or Password', 'Dismiss');
        return;
      }
      
      ctrl.setIsLoading(true);
      String playerId = '';
      OSDeviceState? deviceState = await OneSignal.shared.getDeviceState();
      if (deviceState != null) {
        String? userId = deviceState.userId;
        playerId = userId ?? '';
      }
      final o = {
        'username': txtusername.text,
        'password': txtpwd.text,
        'playerId': playerId,
        'machineId': deviceId
      };
      final m = await AuthService.authenticate(o);
      final x = m['data'];
      await DataManager.removeItem('isFirstTimeLogin');
      bool isFirstTimeLogin = x['isFirstTimeLogin'];
      if (x['isFirstTimeLogin']) {
        await DataManager.setItem('isFirstTimeLogin', true);
        await AuthManager.set(m['token'], x['role'], x['isFirstTimeLogin'], txtusername.text, false);
      }

      else {
        await AuthManager.set(m['token'], x['role'], x['isFirstTimeLogin'], txtusername.text, true);
        String username = await DataManager.read('__biometric-username__') ?? '';
        if (username.isNotEmpty) {
          await DataManager.write('__biometric-username__', txtusername.text);
        }
      }

      if (x['role'] == 'USER') {
        UserDetails? o = await UserService.getUser();
        if (o != null) {
          await DataManager.setUserDetails(o);
          if (o.userBranches.isNotEmpty) {
            await DataManager.setBranchDetails(o.userBranches.first);
            PatientDetails? patientData = await VesaliusService.getVesaliusPatientData(o.userBranches.first.branch!.branchId!, o.userBranches.first.prn!);
            if (patientData != null) {
              await DataManager.setPatientDetails(patientData);
              DataManager.setPrn(o.userBranches.first.prn!);
              //await OneSignal.shared.setExternalUserId(o.userBranches![0].prn!);
              //await StorageDataManager.addUser(o.email!);
              // await DataManager.setUserDetails(o);
            }
          }
        }
      }
      ctrl.setIsLoading(false);
      if (isFirstTimeLogin) {
        Get.to(() => const FirstTimeLogin());
      }

      else {
        Get.offAll(() => const MainLayout());
        if (NotificationManager.hasNotification) {
          if (NotificationManager.type == 'survey') {
            Get.to(() => const PatientSurvey());
          }

          else {
            Get.to(() => const AppointmentDetail());
          }

          NotificationManager.reset();
        }
      }
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 401) {
        showCustomDialog('Login Failed', 'Incorrect Email or Password', 'Dismiss');
      }

      else {
        handleError(error, onLogin);
      }
    }
  }

  void biometricLogin() async {
    String username = await DataManager.read('__biometric-username__') ?? '';
    bool allowBiometricAuth = username.isEmpty ? false : true;

    if (!allowBiometricAuth) {
      await showCustomDialog('Failed', 'Biometric not enabled on this device', 'Dismiss');
      return;
    }

    try {
      bool x = await auth.canCheckBiometrics;
      if (x) {
        String s = 'fingerprint';
        if (listBiometric?.contains(BiometricType.face) ?? false) {
          s = 'face';
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
          var o = {
            'username': username,
            'password': deviceId,
            'playerId': playerId,
            'fromBiometric': 1
          };
          ctrl.setIsLoading(true);
          var m = await AuthService.authenticate(o);
          var x = m['data'];
          await AuthManager.set(m['token'], x['role'], x['isFirstTimeLogin'], txtusername.text, true);
          if (x['role'] == 'USER') {
            UserDetails? o = await UserService.getUser();
            if (o != null) {
              await DataManager.setUserDetails(o);
              if (o.userBranches.isNotEmpty) {
                await DataManager.setBranchDetails(o.userBranches.first);
                PatientDetails? patientData = await VesaliusService.getVesaliusPatientData(o.userBranches.first.branch!.branchId!, o.userBranches.first.prn!);
                if (patientData != null) {
                  await DataManager.setPatientDetails(patientData);
                  DataManager.setPrn(o.userBranches.first.prn!);
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
        showCustomDialog('Failed', 'Biometric not enrolled on this device', 'Dismiss');
      }
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 401) {
        showCustomDialog('Failed', 'Biometric authentication failed', 'Dismiss');
      }

      else {
        handleError(error, biometricLogin);
      }
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Failed', error.toString(), 'Dismiss');
    }
  }

  Widget buildForm() {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.only(bottom: ctrl.isBiometricEnabled ? 240.0 : 180.0),
            child: Scrollbar(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 25.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Welcome!\nSign In to Continue',
                      style: kTextStyle1.copyWith(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w700,
                        color: kTextColor1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
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
                          color: kBgColor2.withOpacity(0.1),
                          offset: const Offset(0, 4.0),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: validate,
                      validator: ValidationBuilder().required('Email is required').minLength(1, 'Email is required').build(),
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
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: kTextColor3),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: kTextColor3),
                        ),
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
                          color: kBgColor2.withOpacity(0.1),
                          offset: const Offset(0, 4.0),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Obx(() =>
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: validate,
                        validator: ValidationBuilder().required('Password is required').minLength(1, 'Password is required').build(),
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
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: kTextColor3),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: kTextColor3),
                          ),
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
              ),
            ),
          ),
        ),
        Obx(() => ctrl.isBiometricEnabled ?
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: kBgColor1,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppElevatedButton(
                    text: 'Sign In',
                    onPressed: onLogin,
                  ),
                  const SizedBox(height: 27.0),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1.0,
                          color: const Color(0xFFDADADA),
                        ),
                      ),
                      Text(
                        'OR',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: kTextColor2,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1.0,
                          color: const Color(0xFFDADADA),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Material(
                    borderRadius: BorderRadius.circular(5.0),
                    child: InkWell(
                      onTap: biometricLogin,
                      borderRadius: BorderRadius.circular(5.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'images/icon/fingerprint.png',
                          width: 48.0,
                          height: 48.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    'Biometric Login',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryColor,
                    ),
                  ),
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
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Obx(() =>
                      AppElevatedButton(
                        text: 'Sign In',
                        onPressed: !ctrl.isValid ? null : onLogin,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: AppOutlinedButton(
                      text: 'Continue As Guest',
                      onPressed: () => Get.to(() => const Guest()),
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
    return WillPopScope(
      onWillPop: onWillPop,
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
              progressIndicator: const AppActivityIndicator(),
              child: buildForm(),
            ),
          ),
        ),
      ),
    );
  }
}
