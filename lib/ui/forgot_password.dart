import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';

import 'sign_in.dart';

class ForgotPassword extends StatefulWidget {
  
  static const String routeName = '/ForgotPassword';

  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  bool isValid = false;
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
        isValid = false;
      });
    }

    else {
      setState(() {
        isValid = b ?? false;
      });
    }
  }

  Future<void> showSuccess() async {
    await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 29.0, bottom: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/icon/tick.png',
              width: 54.0,
              height: 54.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 17.0),
            Text(
              'Temporary Password Sent',
              style: kLabelTextStyle.copyWith(
                fontFamily: kMainFont,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'A temporary password has been sent to your email address. Please sign in using the temporary password.',
              style: kBodyTextStyle.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFB1B1B1),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.offAllNamed(SignIn.routeName);
              },
              style: ElevatedButton.styleFrom(
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
          ],
        ),
      ),
    );
  }

  void onResetPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      await resetPassword(txtemail.text);
      setState(() {
        isLoading = false;
      });
      await showSuccess();
      //showCustomDialog('Successful', m['successMessage'], 'Dismiss', context);
    }

    on DioError catch (error) {
      setState(() {
        isLoading = false;
      });
      if (error.type == DioErrorType.response) {
        var mx = error.response?.data as Map;
        if (mx.containsKey('errorMessage')) {
          showCustomDialog('Failed', mx['errorMessage'], 'Dismiss');
        }

        else if (mx.containsKey('message')) {
          showCustomDialog('Failed', mx['message'], 'Dismiss');
        }
        
        else {
          showCustomDialog('Failed', 'Reset Password failed', 'Dismiss');
        }
      }

      else {
        showCustomDialog('Failed', 'Reset Password failed', 'Dismiss');
      }
    }
  }

  Widget buildForm() {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: Scrollbar(
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 17.0),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Reset Password',
                    style: kMainTextStyle.copyWith(
                      fontSize: 24.0,
                      color: kMainColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  margin: const EdgeInsets.only(left: 25.0, right: 25.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1EDFF),
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(229, 229, 229, 0.1),
                        offset: Offset(0, 4.0),
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'images/icon/info.png',
                        width: 16.0,
                        height: 16.0,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 9.0),
                      Expanded(
                        child: Text(
                          'Enter the email address associated with your account and we’ll email you a temporary password for sign in.',
                          style: kBodyTextStyle.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 30.0),
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
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: validate,
                    validator: ValidationBuilder().required('Email is required').minLength(1, 'Email is required').email('Email is invalid').build(),
                    controller: txtemail,
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
                      hintText: 'e.g.JohnSmith@abc.com',
                      hintStyle: kBodyTextStyle.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFB1B1B1),
                      ),
                      errorStyle: const TextStyle(
                        fontFamily: kBodyFont,
                        color: Color(0xFFFA4954),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color(0xFFFA4954)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color(0xFFFA4954)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 180.0),
              ],
            ),
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
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '*For hospital registered patient only',
                    style: kBodyTextStyle.copyWith(
                      color: const Color(0xFFA41D2B),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33.0),
                  child: ElevatedButton(
                    onPressed: isValid ? onResetPassword : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      backgroundColor: kMainColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    ),
                    child: Text(
                      'Send Password',
                      style: kMainTextStyle.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember your password? ',
                      style: kBodyTextStyle.copyWith(
                        fontFamily: kMainFont,
                        fontSize: 16.0,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.offAllNamed(SignIn.routeName);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: kMainColor,
                      ),
                      child: Text(
                        'Sign In',
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
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: const Color(0xFFF8F8F8),
        leading: const BackBtn(color: Color(0xFF002E50)),
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
    );
  }
}