import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/no_network.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/profile/change_password_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';

class ChangePassword extends StatefulWidget {

  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  late final TextEditingController txtcurrent;
  late final TextEditingController txtnew;
  late final TextEditingController txtconfirm;
  final formKey = GlobalKey<FormState>();

  final ChangePasswordCtrl ctrl = Get.put(ChangePasswordCtrl());

  @override
  void initState() {
    super.initState();
    txtcurrent = TextEditingController();
    txtnew = TextEditingController();
    txtconfirm = TextEditingController();
  }

  @override
  void dispose() {
    txtcurrent.dispose();
    txtnew.dispose();
    txtconfirm.dispose();
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
    Get.dialog(AlertDialog(
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
              'Successful',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Password successfully changed.',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Dismiss',
              onPressed: () {
                Get.back();
                Get.back();
              },
            ),
          ],
        ),
      ),
    ));
  }

  void onSubmit() async {
    String s1 = txtcurrent.text;
    String s2 = txtnew.text;
    String s3 = txtconfirm.text;
    
    if (s2 != s3) {
      showCustomDialog('Error', 'Password does not match with confirm password', 'Dismiss');
    }

    else {
      try {
        final o = {
          'newPassword': s2,
          'oldPassword': s1
        };
        ctrl.setIsLoading(true);
        await UserService.changePassword(o);
        ctrl.setIsLoading(false);
        showSuccess();
        //await showCustomDialog('Successful', 'Password successfully changed', 'Dismiss', context);
        //Navigator.popUntil(context, ModalRoute.withName(Home.routeName));
      }

      on DioException catch (error) {
        ctrl.setIsLoading(false);
        if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 417 &&
        s1 == s2) {
          showCustomDialog('Error', 'New Password is not allowed to be the same with Old Password', 'Dismiss');
        }

        else if (error.type == DioExceptionType.badResponse) {
          final mx = error.response?.data as Map?;
          if (mx?.containsKey('message') ?? false) {
            await showCustomDialog(error.response?.statusCode == 401 ? 'Unauthorized' : 'Error', mx?['message'], 'Dismiss');
          }

          if (error.response?.statusCode == 401) {
            handleError(error, onSubmit);
          }

          else {
            showCustomDialog('Error', 'Invalid password', 'Dismiss');
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
          showCustomDialog('Error', 'Invalid password', 'Dismiss');
        }
      }

      catch (error) {
        ctrl.setIsLoading(false);
        showCustomDialog('Error', error.toString(), 'Dismiss');
      }
    }
  }

  Widget buildForm() {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: Scrollbar(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 22.0),
                      Text(
                        'Current Password',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
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
                        child: Obx(() =>
                          TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            onChanged: validate,
                            validator: ValidationBuilder(requiredMessage: 'Current Password is required').required('Current Password is required').minLength(1, 'Current Password is required').build(),
                            controller: txtcurrent,
                            cursorColor: kTextColor1,
                            obscureText: ctrl.isCurrentPwd,
                            style: const TextStyle(
                              fontFamily: kBodyFont,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor1,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 12.0),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Current Password',
                              hintStyle: kTextStyle1.copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor5,
                              ),
                              suffixIcon: Material(
                                color: Colors.white,
                                type: MaterialType.transparency,
                                child: IconButton(
                                  onPressed: () {
                                    ctrl.setIsCurrentPwd(!ctrl.isCurrentPwd);
                                  }, 
                                  icon: Obx(() =>
                                    Icon(
                                      ctrl.isCurrentPwd ? Icons.visibility_off : Icons.visibility,
                                      color: kTextColor1,
                                    ),
                                  ),
                                  color: kTextColor1,
                                  splashRadius: 22.0,           
                                ),
                              ),
                              errorStyle: const TextStyle(
                                fontFamily: kBodyFont,
                                color: kTextColor3,
                              ),
                              enabledBorder: kEnabledBorder,
                              focusedBorder: kFocusedBorder,
                              errorBorder: kErrorBorder,
                              focusedErrorBorder: kFocusedErrorBorder,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14.0),
                      Text(
                        'New Password',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
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
                        child: Obx(() =>
                          TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            onChanged: validate,
                            validator: ValidationBuilder(requiredMessage: 'New Password is required').required('New Password is required').minLength(8, 'New Password must be at least 8 characters in length').regExp(kRegExpPassword, 'New Password must be alphanumeric').build(),
                            controller: txtnew,
                            cursorColor: kTextColor1,
                            obscureText: ctrl.isNewPwd,
                            style: const TextStyle(
                              fontFamily: kBodyFont,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor1,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 12.0),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'New Password',
                              hintStyle: kTextStyle1.copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor5,
                              ),
                              suffixIcon: Material(
                                color: Colors.white,
                                type: MaterialType.transparency,
                                child: IconButton(
                                  onPressed: () {
                                    ctrl.setIsNewPwd(!ctrl.isNewPwd);
                                  },
                                  icon: Obx(() =>
                                    Icon(
                                      ctrl.isNewPwd ? Icons.visibility_off : Icons.visibility,
                                      color: kTextColor1,
                                    ),
                                  ),
                                  color: kTextColor1,
                                  splashRadius: 22.0,            
                                ),
                              ),
                              errorStyle: const TextStyle(
                                fontFamily: kBodyFont,
                                color: kTextColor3,
                              ),
                              enabledBorder: kEnabledBorder,
                              focusedBorder: kFocusedBorder,
                              errorBorder: kErrorBorder,
                              focusedErrorBorder: kFocusedErrorBorder,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14.0),
                      Text(
                        'Confirm Password',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
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
                        child: Obx(() =>
                          TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            onChanged: validate,
                            validator: ValidationBuilder(requiredMessage: 'Confirm Password is required').required().minLength(8, 'Confirm Password must be at least 8 characters in length').regExp(kRegExpPassword, 'Confirm Password must be alphanumeric').build(),
                            controller: txtconfirm,
                            cursorColor: kTextColor1,
                            obscureText: ctrl.isConfirmPwd,
                            style: const TextStyle(
                              fontFamily: kBodyFont,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor1,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 12.0),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Confirm Password',
                              hintStyle: kTextStyle1.copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor5,
                              ),
                              suffixIcon: Material(
                                color: Colors.white,
                                type: MaterialType.transparency,
                                child: IconButton(
                                  onPressed: () {
                                    ctrl.setIsConfirmPwd(!ctrl.isConfirmPwd);
                                  },
                                  icon: Icon(
                                    ctrl.isConfirmPwd ? Icons.visibility_off : Icons.visibility,
                                    color: kTextColor1,
                                  ),
                                  color: kTextColor1,
                                  splashRadius: 22.0,           
                                ),
                              ),
                              errorStyle: const TextStyle(
                                fontFamily: kBodyFont,
                                color: kTextColor3,
                              ),
                              enabledBorder: kEnabledBorder,
                              focusedBorder: kFocusedBorder,
                              errorBorder: kErrorBorder,
                              focusedErrorBorder: kFocusedErrorBorder,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100.0),
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
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            color: kBgColor1,
            child: Obx(() =>
              AppElevatedButton(
                text: 'Save',
                onPressed: ctrl.isValid ? onSubmit : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Change Password',
      body: Obx(() =>
        ModalProgressHUD(
          inAsyncCall: ctrl.isLoading,
          blur: kBlur,
          progressIndicator: const AppActivityIndicator(),
          child: SafeArea(
            child: buildForm(),
          ),
        ),
      ),
    );
  }
}