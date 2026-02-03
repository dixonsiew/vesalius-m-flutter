import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/no_network.dart';
import 'package:vesalius_m_flutter/components/verify_code.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/sign-in/verify_email_code_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';
import 'package:vesalius_m_flutter/ui/sign-in/biometric.dart';
import 'package:vesalius_m_flutter/ui/sign_in.dart';

import 'reset_password.dart';

class VerifyEmailCode extends StatelessWidget {

  final String type;
  final String email;

  final VerifyEmailCodeCtrl ctrl = Get.put(VerifyEmailCodeCtrl());

  VerifyEmailCode({
    super.key,
    required this.type,
    required this.email,
  });

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
              'Success',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Your account has been successfully created.',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor2,
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
    String verificationCode = ctrl.digits;
    if (type == 'verify-email-signup' || type == 'verify-email-signin') {
      try {
        ctrl.setIsLoading(true);
        await UserService.postVerificationCode(email, verificationCode);
        await DataManager.instance.removeItem('isFirstTimeLogin');
        AuthManager.instance.isFirstTimeLogin = false;
        ctrl.setIsLoading(false);
        if (type == 'verify-email-signup') {
          showSuccess();
        }
        
        else {
          Get.off(() => const Biometric());
        }
      }

      on DioException catch (error) {
        ctrl.setIsLoading(false);
        if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 400) {
          final mx = error.response?.data as Map?;
          if (mx?.containsKey('message') ?? false) {
            showCustomDialog('Error', mx?['message'], 'Dismiss');
          }

          else {
            showCustomDialog('Verifying Failed', 'Please enter a valid code', 'Dismiss');
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
          showCustomDialog('Verifying Failed', 'Please enter a valid code', 'Dismiss');
        }
      }

      catch (_) {
        ctrl.setIsLoading(false);
        showCustomDialog('Verifying Failed', 'Please enter a valid code', 'Dismiss');
      }
    }

    else {
      try {
        ctrl.setIsLoading(true);
        await UserService.postVerificationCode(email, verificationCode);
        ctrl.setIsLoading(false);
        Get.to(() => ResetPassword(
          verificationCode: verificationCode,
          email: email,
        ));
      }

      on DioException catch (error) {
        ctrl.setIsLoading(false);
        if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 400) {
          final mx = error.response?.data as Map?;
          if (mx?.containsKey('message') ?? false) {
            showCustomDialog('Error', mx?['message'], 'Dismiss');
          }

          else {
            showCustomDialog('Verifying Failed', 'Please enter a valid code', 'Dismiss');
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
          showCustomDialog('Verifying Failed', 'Please enter a valid code', 'Dismiss');
        }
      }
      
      catch (_) {
        ctrl.setIsLoading(false);
        showCustomDialog('Verifying Failed', 'Please enter a valid code', 'Dismiss');
      }
    }
  }

  Widget buildForm() {
    return Stack(
      children: [
        Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 52.0),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'images/imgs/email.png',
                    width: 145.09,
                    height: 75.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 32.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Please enter the verification code sent to\n',
                          style: kTextStyle2.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor2,
                          ),
                        ),
                        TextSpan(
                          text: email,
                          style: kTextStyle2.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: kTextColor2,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Kindly check your inbox or spam/junk folder if you have not received it yet.',
                    style: kTextStyle2.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 68.0),
                // Padding(
                //   padding: const EdgeInsets.only(left: 16.0),
                //   child: Align(
                //     alignment: Alignment.topLeft,
                //     child: Text(
                //       'enterVerifyCode'.tr,
                //       style: kTextStyle1.copyWith(
                //         fontSize: 16.0,
                //         fontWeight: FontWeight.w700,
                //         color: Color(0xFF002F67),
                //       ),
                //     ),
                //   ),
                // ),
                VerifyCode(
                  onAllDigitsEntered: (s) {
                    ctrl.setDigits(s);
                  },
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: kBgColor1,
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Obx(() =>
              AppElevatedButton(
                text: 'Confirm',
                onPressed: ctrl.isValid == false ? null : onSubmit,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      child: InnerPage(
        title: type == 'verify-email-signup' || type == 'verify-email-signin' ? 'Email Verification' : 'Forgot Password',
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
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}