import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vesalius_m_flutter/components/app-shared.dart';
import 'package:vesalius_m_flutter/components/bottom-red.dart';
import 'package:vesalius_m_flutter/components/top-red.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth-manager.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/models/storage-data-manager.dart';
import 'package:vesalius_m_flutter/services/auth-service.dart';
import 'package:vesalius_m_flutter/services/data-service.dart';
import 'package:vesalius_m_flutter/ui/first-time-login.dart';

import 'forgot-password.dart';
import 'home.dart';
import 'sign-up.dart';

class SignIn extends StatefulWidget {

  static final String routeName = 'SignIn';

  final String email;

  SignIn({
    this.email,
  });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool isTxt = false;
  bool isLoading = false;

  final usernameController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameController.value = TextEditingValue(text: widget.email == null ? '' : widget.email);
    pwdController.value = TextEditingValue(text: '');
    // initPlatformState();
  }

  void login() async {
    try {
      if (usernameController.text.isEmpty || pwdController.text.isEmpty) {
        showCustomDialog('Login Failed', 'Incorrect Email or Password', 'Dismiss', context);
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
          if (o.userBranches.isNotEmpty) {
            await DataManager.setBranchDetails(o.userBranches[0]);
            var patientData = await getVesaliusPatientData(o.userBranches[0].branch.branchId, o.userBranches[0].prn);
            if (patientData != null) {
              await DataManager.setPatientDetails(patientData);
              DataManager.setPrn(o.userBranches[0].prn);
              await StorageDataManager.addUser(o.email);
              await DataManager.setUserDetails(o);
            }
          }
        }
      }
      setState(() {
        isLoading = false;
      });
      if (isFirstTimeLogin) {
        Navigator.pushNamed(context, FirstTimeLogin.routeName);
      }

      else {
        Navigator.pushNamedAndRemoveUntil(context, Home.routeName, (route) => false);
      }
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
      if (error.type == DioErrorType.response && error.response.statusCode == 401) {
        showCustomDialog('Login Failed', 'Incorrect Email or Password', 'Dismiss', context);
      }

      else {
        handleError(context, error, login);
      }
    }
  }

  Widget buildForm() {
    var padding = MediaQuery.of(context).padding;

    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - padding.top - padding.bottom,
        color: Colors.white,
        child: Stack(
          fit: StackFit.expand,
          children: [
            TopRed(),
            BottomRed(),
            
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.0, right: 20.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: kPrimaryColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 72.0,
                    height: 72.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: AssetImage('images/imgs/nova.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Text(
                      'Welcome back',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextField(
                      controller: usernameController,
                      cursorColor: Color(0xFF929292),
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFF929292),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: Color(0xFF929292),
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
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextField(
                      controller: pwdController,
                      cursorColor: Color(0xFF929292),
                      obscureText: !isTxt,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFF929292),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: Color(0xFF929292),
                        ),
                        prefixIcon: Icon(
                          Icons.lock_open,
                          color: Color(0xFF929292),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isTxt ? Icons.visibility : Icons.visibility_off,
                            color: Color(0xFF929292),
                          ),
                          onPressed: () {
                            setState(() {
                              isTxt = !isTxt;
                            });
                          },            
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
                    padding: EdgeInsets.only(left: 20.0, right: 20.0,top: 20.0),
                    child: RawMaterialButton(
                      elevation: 5.0,
                      fillColor: kPrimaryBtnBgColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      constraints: BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        login();
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, ForgotPassword.routeName);
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 14.0,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, SignUp.routeName);
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
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
        brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
        toolbarHeight: 0.0,
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: AppActivityIndicator(), // AppScalingText('Sign In...'),
        child: SafeArea(
          child: Scrollbar(
            child: buildForm(),
          ),
        ),
      ),
    );
  }
}
