import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/first_time_login_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';
import 'package:vesalius_m_flutter/ui/biometric.dart';

import 'sign_in.dart';

class FirstTimeLogin extends StatefulWidget {

  static const String routeName = '/FirstTimeLogin';

  const FirstTimeLogin({super.key});

  @override
  State<FirstTimeLogin> createState() => _FirstTimeLoginState();
}

class _FirstTimeLoginState extends State<FirstTimeLogin> {

  final formKey = GlobalKey<FormState>();
  late final TextEditingController txtcode;

  final FirstTimeLoginCtrl ctrl = Get.put(FirstTimeLoginCtrl());

  @override
  void initState() {
    super.initState();
    txtcode = TextEditingController();
  }

  @override
  void dispose() {
    txtcode.dispose();
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

  void onVerify() async {
    try {
      ctrl.setIsLoading(true);
      await UserService.postVerificationCode(txtcode.text);
      await DataManager.removeItem('isFirstTimeLogin');
      await AuthManager.setIsLogin(true);
      ctrl.setIsLoading(false);
      Get.to(() => const Biometric());
      // Get.offAll(() => const MainLayout());
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Verifying Failed', 'Please enter a valid code', 'Dismiss');
    }
  }

  Widget buildForm() {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 144.0),
            child: Scrollbar(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 25.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'First Time Login\nEnter your verification code to continue',
                      style: kTextStyle1.copyWith(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w700,
                        color: kTextColor1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
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
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: validate,
                      validator: ValidationBuilder().required('Verification Code is required').minLength(1, 'Verification Code is required').build(),
                      controller: txtcode,
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
                        hintText: 'Verification Code',
                        hintStyle: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor5,
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
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: kBgColor1,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() =>
                  AppElevatedButton(
                    text: 'Sign In',
                    onPressed: !ctrl.isValid ? null : onVerify,
                  ),
                ),
                const SizedBox(height: 16.0),
                AppOutlinedButton(
                  text: 'Cancel',
                  onPressed: () async {
                    await AuthManager.signOut();
                    Get.offAll(() => const SignIn());
                  }
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
      body: Obx(() =>
        ModalProgressHUD(
          inAsyncCall: ctrl.isLoading,
          progressIndicator: const AppActivityIndicator(),
          child: SafeArea(
            child: buildForm(),
          ),
        ),
      ),
    );
  }
}