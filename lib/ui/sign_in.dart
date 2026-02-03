import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/notification_manager.dart';
import 'package:vesalius_m_flutter/models/storage_data_manager.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/ui/first_time_login.dart';
import 'package:vesalius_m_flutter/ui/forgot_password.dart';
import 'package:vesalius_m_flutter/ui/guest.dart';

import 'appointment/appointment_detail.dart';
import 'home.dart';
import 'patient_survey.dart';
import 'sign_up.dart';

class SignIn extends StatefulWidget {

  static const String routeName = '/SignIn';

  final String? email;

  const SignIn({
    Key? key, 
    this.email,
  }) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool isPwd = false;
  bool isTxt = false;
  bool isLoading = false;
  final usernameController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameController.value = TextEditingValue(text: widget.email ?? 'wingfei.siew@nova-hub.com');
    pwdController.value = const TextEditingValue(text: 'password');
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

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

  @override
  void dispose() {
    usernameController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    return await showConfirmDialog('Are you sure you want to exit ?');
  }

  void login() async {
    try {
      if (usernameController.text.isEmpty || pwdController.text.isEmpty) {
        showCustomDialog('Login Failed', 'Incorrect Email or Password', 'Dismiss');
        return;
      }
      
      setState(() {
        isLoading = true;
      });
      String playerId = '';
      OSDeviceState? deviceState = await OneSignal.shared.getDeviceState();
      if (deviceState != null) {
        String? userId = deviceState.userId;
        playerId = userId ?? '';
      }
      var o = {
        'username': usernameController.text,
        'password': pwdController.text,
        'playerId': playerId
      };
      var m = await authenticate(o);
      var x = m['data'];
      await DataManager.removeItem('isFirstTimeLogin');
      bool isFirstTimeLogin = x['isFirstTimeLogin'];
      if (x['isFirstTimeLogin']) {
        await DataManager.setItem('isFirstTimeLogin', true);
        await AuthManager.set(m['token'], x['role'], x['isFirstTimeLogin'], usernameController.text, false);
      }

      else {
        await AuthManager.set(m['token'], x['role'], x['isFirstTimeLogin'], usernameController.text, true);
      }

      if (x['role'] == 'USER') {
        var o = await getUser();
        if (o != null) {
          if (o.userBranches!.isNotEmpty) {
            await DataManager.setBranchDetails(o.userBranches![0]);
            var patientData = await getVesaliusPatientData(o.userBranches![0].branch!.branchId!, o.userBranches![0].prn!);
            if (patientData != null) {
              await DataManager.setPatientDetails(patientData);
              DataManager.setPrn(o.userBranches![0].prn!);
              //await OneSignal.shared.setExternalUserId(o.userBranches![0].prn!);
              await StorageDataManager.addUser(o.email!);
              await DataManager.setUserDetails(o);
            }
          }
        }
      }
      setState(() {
        isLoading = false;
      });
      if (isFirstTimeLogin) {
        Get.toNamed(FirstTimeLogin.routeName);
      }

      else {
        Get.offAllNamed(Home.routeName);
        if (NotificationManager.hasNotification) {
          if (NotificationManager.type == 'survey') {
            Get.toNamed(PatientSurvey.routeName);
          }

          else {
            Get.toNamed(AppointmentDetail.routeName);
          }

          NotificationManager.reset();
        }
      }
    }

    on DioError catch (error) {
      setState(() {
        isLoading = false;
      });
      if (error.type == DioErrorType.response && error.response?.statusCode == 401) {
        showCustomDialog('Login Failed', 'Incorrect Email or Password', 'Dismiss');
      }

      else {
        handleError(error, login);
      }
    }
  }

  Widget buildForm() {
    return Stack(
      children: [
        Scrollbar(
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 25.0),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  'Welcome!\nSign In to Continue',
                  style: kMainTextStyle.copyWith(
                    fontSize: 24.0,
                    color: kMainColor,
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  'Email',
                  style: kLabelTextStyle.copyWith(
                    fontSize: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: usernameController,
                  cursorColor: const Color(0xFF002E50),
                  style: const TextStyle(
                    fontFamily: kBodyFont,
                    fontSize: 16.0,
                    color: Color(0xFF002E50),
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15.0),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email',
                    hintStyle: kBodyTextStyle.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFB1B1B1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'Password',
                  style: kLabelTextStyle.copyWith(
                    fontSize: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: pwdController,
                  obscureText: isPwd,
                  cursorColor: const Color(0xFF002E50),
                  style: const TextStyle(
                    fontFamily: kBodyFont,
                    fontSize: 18.0,
                    color: Color(0xFF002E50),
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15.0),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter Password',
                    hintStyle: kBodyTextStyle.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFB1B1B1),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPwd ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF8C8C8C),
                      ),
                      color: const Color(0xFF8C8C8C),
                      onPressed: () {
                        setState(() {
                          isPwd = !isPwd;
                        });
                      },            
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(ForgotPassword.routeName);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: kMainColor,
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: kLabelTextStyle.copyWith(
                        fontSize: 14.0,
                        color: kMainColor,
                        decoration: TextDecoration.underline,
                        decorationColor: kMainColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 250.0),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.only(bottom: 48.0),
            color: const Color(0xFFF8F8F8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33.0),
                  child: ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      backgroundColor: kMainColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    ),
                    child: Text(
                      'Sign In',
                      style: kMainTextStyle.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Get.toNamed(Guest.routeName);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kMainColor,
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      side: const BorderSide(
                        color: Color(0xFFDBDBDB),
                      ),
                    ),
                    child: Text(
                      'Continue As Guest',
                      style: kMainTextStyle.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: kMainColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          height: 1.0,
                          thickness: 1.0,
                          color: Color(0xFFDADADA),
                        ),
                      ),
                      const SizedBox(width: 2.0),
                      Text(
                        'OR',
                        style: kBodyTextStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFB1B1B1),
                        ),
                      ),
                      const SizedBox(width: 2.0),
                      const Expanded(
                        child: Divider(
                          height: 1.0,
                          thickness: 1.0,
                          color: Color(0xFFDADADA),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not an existing user? ',
                      style: kBodyTextStyle.copyWith(
                        fontFamily: kMainFont,
                        fontSize: 16.0,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(SignUp.routeName);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: kMainColor,
                      ),
                      child: Text(
                        'Sign Up',
                        style: kMainTextStyle.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: kMainColor,
                        ),
                      ),
                    ),
                  ],
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
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
          toolbarHeight: 0.0,
          backgroundColor: const Color(0xFFF8F8F8),
          elevation: 0.0,
        ),
        backgroundColor: const Color(0xFFF8F8F8),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: const AppActivityIndicator(),
          child: SafeArea(
            child: buildForm(),
          ),
        ),
      ),
    );
  }
}
