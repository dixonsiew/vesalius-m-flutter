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
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/storage_data_manager.dart';
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
    Key? key, 
    this.email,
  }) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool isPwd = true;
  bool isValid = false;
  bool isLoading = false;
  late final TextEditingController txtusername;
  late final TextEditingController txtpwd;

  @override
  void initState() {
    super.initState();
    txtusername = TextEditingController();
    txtpwd = TextEditingController();
    txtusername.value = TextEditingValue(text: widget.email ?? 'wingfei.siew@nova-hub.com');
    txtpwd.value = const TextEditingValue(text: 'password');
    initPlatformState();
  }

  @override
  void dispose() {
    txtusername.dispose();
    txtpwd.dispose();
    super.dispose();
  }

  void initPlatformState() async {
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

  void validate(String s) {
    if (txtusername.text.isEmpty || txtpwd.text.isEmpty) {
      setState(() {
        isValid = false;
      });
    }

    else {
      setState(() {
        isValid = true;
      });
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
      
      setState(() {
        isLoading = true;
      });
      String playerId = '';
      OSDeviceState? deviceState = await OneSignal.shared.getDeviceState();
      if (deviceState != null) {
        String? userId = deviceState.userId;
        playerId = userId ?? '';
      }
      final o = {
        'username': txtusername.text,
        'password': txtpwd.text,
        'playerId': playerId
      };
      final m = await authenticate(o);
      final x = m['data'];
      await DataManager.removeItem('isFirstTimeLogin');
      bool isFirstTimeLogin = x['isFirstTimeLogin'];
      if (x['isFirstTimeLogin']) {
        await DataManager.setItem('isFirstTimeLogin', true);
        await AuthManager.set(m['token'], x['role'], x['isFirstTimeLogin'], txtusername.text, false);
      }

      else {
        await AuthManager.set(m['token'], x['role'], x['isFirstTimeLogin'], txtusername.text, true);
      }

      if (x['role'] == 'USER') {
        UserDetails? o = await getUser();
        if (o != null) {
          await DataManager.setUserDetails(o);
          if (o.userBranches!.isNotEmpty) {
            await DataManager.setBranchDetails(o.userBranches![0]);
            PatientDetails? patientData = await getVesaliusPatientData(o.userBranches![0].branch!.branchId!, o.userBranches![0].prn!);
            if (patientData != null) {
              await DataManager.setPatientDetails(patientData);
              DataManager.setPrn(o.userBranches![0].prn!);
              //await OneSignal.shared.setExternalUserId(o.userBranches![0].prn!);
              await StorageDataManager.addUser(o.email!);
              // await DataManager.setUserDetails(o);
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
        Get.offAllNamed(MainLayout.routeName);
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
        handleError(error, onLogin);
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
                child: TextField(
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
                      color: const Color(0xFFBDC2CC),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                    ),
                  ),
                  onChanged: validate,
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
                child: TextField(
                  controller: txtpwd,
                  obscureText: isPwd,
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
                      color: const Color(0xFFBDC2CC),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPwd ? Icons.visibility_off : Icons.visibility,
                        color: kTextColor1,
                      ),
                      color: kTextColor1,
                      onPressed: () {
                        setState(() {
                          isPwd = !isPwd;
                        });
                      },            
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                    ),
                  ),
                  onChanged: validate,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
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
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kMainColor,
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
            color: kBgColor1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: !isValid ? null : () {
                      onLogin();
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
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Get.toNamed(Guest.routeName);
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
                      'Continue As Guest',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
                        Get.toNamed(SignUp.routeName);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: kMainColor,
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
          toolbarHeight: 0.0,
          backgroundColor: kBgColor1,
          elevation: 0.0,
        ),
        backgroundColor: kBgColor1,
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
