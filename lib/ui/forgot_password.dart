import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';

import 'sign_in.dart';

class ForgotPassword extends StatefulWidget {
  
  static const String routeName = 'ForgotPassword';

  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  bool valid = false;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final txtemail = TextEditingController();

  @override
  void dispose() {
    txtemail.dispose();
    super.dispose();
  }

  void validate(String s) {
    bool? b = formKey.currentState?.validate();

    if (s.isEmpty) {
      setState(() {
        valid = false;
      });
    }

    else {
      setState(() {
        valid = b ?? false;
      });
    }
  }

  void onResetPassword() async {
    CustomDialog dlg = CustomDialog.of(context);

    try {
      setState(() {
        isLoading = true;
      });
      var m = await resetPassword(txtemail.text);
      setState(() {
        isLoading = false;
      });
      dlg.showCustomDialog('Successful', m['successMessage'], 'Dismiss');
    }

    on DioException catch (error) {
      setState(() {
        isLoading = false;
      });
      if (error.type == DioExceptionType.badResponse) {
        var mx = error.response?.data as Map;
        if (mx.containsKey('errorMessage')) {
          dlg.showCustomDialog('Failed', mx['errorMessage'], 'Dismiss');
        }

        else if (mx.containsKey('message')) {
          dlg.showCustomDialog('Failed', mx['message'], 'Dismiss');
        }
        
        else {
          dlg.showCustomDialog('Failed', 'Reset Password failed', 'Dismiss');
        }
      }

      else {
        dlg.showCustomDialog('Failed', 'Reset Password failed', 'Dismiss');
      }
    }
  }

  Widget buildForm() {
    return SingleChildScrollView(
      child: Material(
        color: Colors.white,
        child: Form(
          key: formKey,
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
                  'Forgot your password?',
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
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: validate,
                  validator: ValidationBuilder().required('Email is required').minLength(1, 'Email is required').email('Email is invalid').build(),
                  controller: txtemail,
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
                    errorStyle: TextStyle(
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
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: RawMaterialButton(
                  elevation: 5.0,
                  fillColor: kHomeBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                  constraints: const BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
                  onPressed: valid ? onResetPassword : null,
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: kBodyFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'For hospital registered patient only',
                  style: TextStyle(
                    color: kMainColor,
                    fontSize: 14.0,
                    fontFamily: kBodyFont,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Already a user?',
                  style: TextStyle(
                    color: Color(0xFF606060),
                    fontSize: 14.0,
                    fontFamily: kBodyFont,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, SignIn.routeName);
                },
                style: TextButton.styleFrom(
                  foregroundColor: kMainColor,
                ),
                child: const Text(
                  'Sign In',
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
        progressIndicator: const AppActivityIndicator(), // AppScalingText('Please wait...'),
        child: SafeArea(
          child: Scrollbar(
            child: buildForm(),
          ),
        ),
      ),
    );
  }
}