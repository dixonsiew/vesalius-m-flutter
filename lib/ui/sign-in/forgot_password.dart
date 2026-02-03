import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/no_network.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/sign-in/forgot_password_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';
import 'package:vesalius_m_flutter/ui/sign-in/verify_email_code.dart';
import 'package:vesalius_m_flutter/ui/sign_in.dart';

class ForgotPassword extends StatefulWidget {

  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final formKey = GlobalKey<FormState>();
  late final TextEditingController txtemail;

  final ForgotPasswordCtrl ctrl = Get.put(ForgotPasswordCtrl());

  @override
  void initState() {
    super.initState();
    txtemail = TextEditingController();
  }

  @override
  void dispose() {
    txtemail.dispose();
    super.dispose();
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

   void showSuccess() async {
    await Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
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
              'Temporary Password Sent',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'A temporary password has been sent to your email address. Please sign in using the temporary password.',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Done',
              onPressed: () {
                Get.back();
                Get.offAll(() => const SignIn());
              },
            ),
          ],
        ),
      ),
    ));
  } 

  void onSubmit() async {
    try {
      ctrl.setIsLoading(true);
      await AdminService.resetPassword(txtemail.text);
      ctrl.setIsLoading(false);
      Get.to(() => VerifyEmailCode(
        type: 'forgot-pwd',
        email: txtemail.text,
      ));
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      if (error.type == DioExceptionType.badResponse) {
        final mx = error.response?.data as Map;
        if (mx.containsKey('errorMessage')) {
          showCustomDialog('Error', mx['errorMessage'], 'Dismiss');
        }

        else if (mx.containsKey('message')) {
          showCustomDialog('Error', mx['message'], 'Dismiss');
        }
        
        else {
          showCustomDialog('Error', 'Reset Password failed', 'Dismiss');
        }
      }

      else if (error.type == DioExceptionType.connectionError) {
        Get.to(() => NoNetwork(
          onPressed: () {
            onSubmit();
          },
        ));
      }

      else {
        showCustomDialog('Error', 'Reset Password failed', 'Dismiss');
      }
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  Widget buildForm() {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 17.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Reset Password',
                      style: kTextStyle1.copyWith(
                        fontFamily: kFont2,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor4.withValues(alpha: 0.1),
                          offset: const Offset(0.0, 4.0),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/icon/info1.png',
                          width: 16.0,
                          height: 16.0,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 9.0),
                        Expanded(
                          child: Text(
                            "Enter the email address associated with your account and we'll email you a temporary password for sign in.",
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 30.0),
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
                      validator: ValidationBuilder(requiredMessage: 'Email is required').required().minLength(1, 'Email is required').email('Email is invalid').build(),
                      controller: txtemail,
                      cursorColor: kTextColor1,
                      style: const TextStyle(
                        fontFamily: kBodyFont,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'e.g.JohnSmith@abc.com',
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
                        errorBorder: kFocusedErrorBorder,
                      ),
                    ),
                  ),
                  const SizedBox(height: 180.0),
                ],
              ),
            ),
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
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '*For registered patients of CVSKL only',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: kPrimaryColor2,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Obx(() =>
                    AppElevatedButton(
                      text: 'Proceed',
                      onPressed: !ctrl.isValid ? null : onSubmit,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember your password?',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor2,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.offAll(() => const SignIn());
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: kPrimaryColor2,
                      ),
                      child: Text(
                        'Sign In',
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
    return InnerPage(
      title: '',
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
    );
  }
}