import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/storage_data_manager.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/ui/first_time_login.dart';

import 'forgot_password.dart';
import 'home.dart';
import 'sign_up.dart';

class SignIn extends StatefulWidget {

  static const String routeName = 'SignIn';

  final String? email;

  const SignIn({
    Key? key,
    this.email,
  }) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool isTxt = false;
  bool isLoading = false;
  final usernameController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameController.value = TextEditingValue(text: widget.email ?? '');
    pwdController.value = const TextEditingValue(text: '');
  }

  @override
  void dispose() {
    usernameController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  void login() async {
    CustomDialog dlg = CustomDialog.of(context);
    try {
      NavigatorState nav = Navigator.of(context);
      if (usernameController.text.isEmpty || pwdController.text.isEmpty) {
        CustomDialog.of(context).showCustomDialog('Login Failed', 'Incorrect Email or Password', 'Dismiss');
        return;
      }

      var o = {
        'username': usernameController.text,
        'password': pwdController.text
      };
      setState(() {
        isLoading = true;
      });
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
        nav.pushNamed(FirstTimeLogin.routeName);
      }

      else {
        nav.pushNamedAndRemoveUntil(Home.routeName, (route) => false);
      }
    }

    on DioException catch (error) {
      setState(() {
        isLoading = false;
      });
      if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 401) {
        dlg.showCustomDialog('Login Failed', 'Incorrect Email or Password', 'Dismiss');
      }

      else {
        dlg.handleError(error, login);
      }
    }
  }

  Widget buildForm() {
    return SingleChildScrollView(
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 20.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: kHomeBgColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Image.asset(
              'images/imgs/nova.png',
              width: 72.0,
              height: 72.0,
              fit: BoxFit.contain,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text(
                'Welcome back',
                style: TextStyle(
                  color: kMainColor,
                  fontSize: 24.0,
                  fontFamily: kTitleFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextField(
                controller: usernameController,
                cursorColor: const Color(0xFF929292),
                style: const TextStyle(
                  fontSize: 18.0,
                  fontFamily: kBodyFont,
                  color: Color(0xFF929292),
                ),
                decoration: const InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    color: Color(0xFF929292),
                    fontFamily: kBodyFont,
                  ),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Color(0xFF929292),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: Color(0xFFE9E9E9)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: Color(0xFFE9E9E9)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextField(
                controller: pwdController,
                cursorColor: const Color(0xFF929292),
                obscureText: !isTxt,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontFamily: kBodyFont,
                  color: Color(0xFF929292),
                ),
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                    color: Color(0xFF929292),
                    fontFamily: kBodyFont,
                  ),
                  prefixIcon: const Icon(
                    Icons.lock_open,
                    color: Color(0xFF929292),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isTxt ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF929292),
                    ),
                    onPressed: () {
                      setState(() {
                        isTxt = !isTxt;
                      });
                    },            
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: Color(0xFFE9E9E9)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: Color(0xFFE9E9E9)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0,top: 20.0),
              child: RawMaterialButton(
                elevation: 5.0,
                fillColor: kHomeBgColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                constraints: const BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: kBodyFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  login();
                },
              ),
            ),
            const SizedBox(height: 10.0),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, ForgotPassword.routeName);
                },
                style: TextButton.styleFrom(
                  foregroundColor: kMainColor,
                ),
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: kMainColor,
                    fontSize: 14.0,
                    fontFamily: kBodyFont,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Don\'t have an account?',
                style: TextStyle(
                  color: Color(0xFF606060),
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, SignUp.routeName);
              },
              style: TextButton.styleFrom(
                foregroundColor: kMainColor,
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: kMainColor,
                  fontSize: 14.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light, statusBarColor: kMainColor),
        toolbarHeight: 0.0,
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(), // AppScalingText('Sign In...'),
        child: SafeArea(
          child: Scrollbar(
            child: buildForm(),
          ),
        ),
      ),
    );
  }
}
