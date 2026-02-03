import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_validator/form_validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/no_network.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/sign-in/reset_password_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';
import 'package:vesalius_m_flutter/ui/sign_in.dart';

class ResetPassword extends StatefulWidget {

  final String verificationCode;
  final String email;

  const ResetPassword({
    super.key,
    required this.verificationCode,
    required this.email,
  });

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  late TextEditingController txtpwd;
  late TextEditingController txtcfmpwd;
  final formKey = GlobalKey<FormState>();
  
  final ResetPasswordCtrl ctrl = Get.put(ResetPasswordCtrl());

  @override
  void initState() {
    super.initState();
    txtpwd = TextEditingController();
    txtcfmpwd = TextEditingController();
  }

  @override
  void dispose() {
    txtpwd.dispose();
    txtcfmpwd.dispose();
    super.dispose();
  }

  void validate(String s) {
    bool b = formKey.currentState!.validate();

    if (s.isEmpty) {
      ctrl.setIsValid(false);
    }

    else {
      String s1 = txtpwd.text;
      String s2 = txtcfmpwd.text;
      if (s1.isNotEmpty && s2.isNotEmpty && s1 == s2) {
        ctrl.setIsValid(true);
      }

      else if (s1.isNotEmpty && s2.isNotEmpty && s1 != s2) {
        ctrl.setIsValid(false);
      }

      else {
        ctrl.setIsValid(b);
      }
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
              'Password changed successfully',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Please sign in using the new password.',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Sign In',
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
      final o = {
        'email': widget.email,
        'verificationCode': widget.verificationCode,
        'password': txtpwd.text
      };
      ctrl.setIsLoading(true);
      await UserService.postResetPassword(o);
      ctrl.setIsLoading(false);
      showSuccess();
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      if (error.type == DioExceptionType.badResponse) {
        final mx = error.response?.data as Map?;
        if (mx?.containsKey('errorMessage') ?? false) {
          showCustomDialog('Error', mx?['errorMessage'], 'Dismiss');
        }

        else if (mx?.containsKey('message') ?? false) {
          showCustomDialog('Error', mx?['message'], 'Dismiss');
        }
        
        else {
          showCustomDialog('Error', 'Set New Password failed', 'Dismiss');
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
        showCustomDialog('Error', 'Set New Password failed', 'Dismiss');
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
          child: Padding(
            padding: const EdgeInsets.only(bottom: 74.0),
            child: Scrollbar(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 45.0),
                      Text(
                        'Password',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: ctrl.inputIndex == 0 ? kPrimaryColor : kTextColor1,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
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
                          validator: ValidationBuilder(requiredMessage: 'Password is required').required().minLength(8, 'Password must be at least 8 characters in length').regExp(kRegExpPassword, 'Password must be alphanumeric').build(),
                          controller: txtpwd,
                          obscureText: ctrl.isPwd,
                          cursorColor: kPrimaryColor,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: kTextColor1,
                          ),
                          onTap: () {
                            ctrl.setInputIndex(0);
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter Password',
                            hintStyle: kTextStyle1.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor5,
                            ),
                            errorStyle: const TextStyle(
                              fontFamily: kBodyFont,
                              color: kTextColor3,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                ctrl.isPwd ? Icons.visibility_off : Icons.visibility,
                                color: kPrimaryColor,
                              ),
                              color: kPrimaryColor,
                              onPressed: () {
                                ctrl.setIsPwd(!ctrl.isPwd);
                              },            
                            ),
                            enabledBorder: kEnabledBorder,
                            focusedBorder: kFocusedBorder,
                            errorBorder: kErrorBorder,
                            focusedErrorBorder: kFocusedErrorBorder,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Text(
                        'Confirm Password',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: ctrl.inputIndex == 1 ? kPrimaryColor : kTextColor1,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
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
                          validator: ValidationBuilder(requiredMessage: 'Confirm Password is required').required().minLength(8, 'Confirm Password must be at least 8 characters in length').regExp(kRegExpPassword, 'Confirm Password must be alphanumeric').build(),
                          controller: txtcfmpwd,
                          obscureText: ctrl.isCfmPwd,
                          cursorColor: kPrimaryColor,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: kTextColor1,
                          ),
                          onTap: () {
                            ctrl.setInputIndex(1);
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter Password',
                            hintStyle: kTextStyle1.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor5,
                            ),
                            errorStyle: const TextStyle(
                              fontFamily: kBodyFont,
                              color: kTextColor3,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                ctrl.isCfmPwd ? Icons.visibility_off : Icons.visibility,
                                color: kPrimaryColor,
                              ),
                              color: kPrimaryColor,
                              onPressed: () {
                                ctrl.setIsCfmPwd(!ctrl.isCfmPwd);
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: kBgColor1,
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: AppElevatedButton(
              text: 'Set New Password',
              onPressed: ctrl.isValid == false ? null : onSubmit,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Set New Password',
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