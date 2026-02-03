import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vesalius_m_flutter/components/app-shared.dart';
import 'package:vesalius_m_flutter/components/bottom-red.dart';
import 'package:vesalius_m_flutter/components/top-red.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/services/auth-service.dart';

import 'sign-in.dart';

class ForgotPassword extends StatefulWidget {
  
  static final String routeName = 'ForgotPassword';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  bool valid = false;
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  final txtemail = TextEditingController();

  void validate(String s) {
    bool b = formKey.currentState.validate();

    if (s.isEmpty) {
      setState(() {
        valid = false;
      });
    }

    else {
      setState(() {
        valid = b;
      });
    }
  }

  void onResetPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      var m = await resetPassword(txtemail.text);
      setState(() {
        isLoading = false;
      });
      showCustomDialog('Successful', m['successMessage'], 'Dismiss', context);
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
      if (error.type == DioErrorType.response) {
        var mx = error.response.data as Map;
        if (mx.containsKey('errorMessage')) {
          showCustomDialog('Failed', mx['errorMessage'], 'Dismiss', context);
        }

        else if (mx.containsKey('message')) {
          showCustomDialog('Failed', mx['message'], 'Dismiss', context);
        }
        
        else {
          showCustomDialog('Failed', 'Reset Password failed', 'Dismiss', context);
        }
      }

      else {
        showCustomDialog('Failed', 'Reset Password failed', 'Dismiss', context);
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
              child: Form(
                key: formKey,
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
                        'Forgot your password?',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: validate,
                        validator: ValidationBuilder().required('Email is required').minLength(1, 'Email is required').email('Email is invalid').build(),
                        controller: txtemail,
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
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: RawMaterialButton(
                        elevation: 5.0,
                        fillColor: kPrimaryBtnBgColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        constraints: BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: valid ? onResetPassword : null,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'For hospital registered patient only',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 14.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Already a user?',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await Navigator.pushNamed(context, SignIn.routeName);
                      },
                      child: Text(
                        'Sign In',
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
        progressIndicator: AppActivityIndicator(), // AppScalingText('Please wait...'),
        child: SafeArea(
          child: Scrollbar(
            child: buildForm(),
          ),
        ),
      ),
    );
  }
}