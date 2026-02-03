import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/sign_up_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';

import 'sign_in.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(this);
  }
}

class SignUp extends StatefulWidget {

  static const String routeName = '/SignUp';

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  DateTime? dobdt;
  late final TextEditingController txtfullname;
  late final TextEditingController txtic;
  late final TextEditingController txtdob;
  late final TextEditingController txtemail;
  late final TextEditingController txtpwd;
  final formKey = GlobalKey<FormState>();

  final SignUpCtrl ctrl = Get.put(SignUpCtrl());

  @override
  void initState() {
    super.initState();
    txtfullname = TextEditingController();
    txtic = TextEditingController();
    txtdob = TextEditingController();
    txtemail = TextEditingController();
    txtpwd = TextEditingController();
  }

  @override
  void dispose() {
    txtfullname.dispose();
    txtic.dispose();
    txtdob.dispose();
    txtemail.dispose();
    txtpwd.dispose();
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
              'Sign Up Successfully',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Your account is created.',
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

  void onSignUp() async {
    try {
      ctrl.setIsLoading(true);
      UserBranch? branchDetails = DataManager.branchDetails;
      num branchId = branchDetails == null ? 1 : branchDetails.branch!.branchId!;
      await AdminService.signUp(branchId, txtdob.text, txtemail.text, txtfullname.text, txtic.text);
      ctrl.setIsLoading(false);
      showSuccess();
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      if (error.type == DioExceptionType.badResponse) {
        final mx = error.response?.data as Map;
        if (mx.containsKey('errorMessage')) {
          showCustomDialog('Failed', mx['errorMessage'], 'Dismiss');
        }

        else if (mx.containsKey('message')) {
          showCustomDialog('Failed', mx['message'], 'Dismiss');
        }
        
        else {
          showCustomDialog('Failed', 'Sign Up failed', 'Dismiss');
        }
      }

      else {
        showCustomDialog('Failed', 'Sign Up failed', 'Dismiss');
      }
    }
  }

  Widget buildForm() {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: Scrollbar(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 25.0),
                  Text(
                    'Full Name',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
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
                      validator: ValidationBuilder().required('Fullname is required').minLength(1, 'Fullname is required').build(),
                      controller: txtfullname,
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
                        hintText: 'e.g.John Smith',
                        hintStyle: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor5,
                        ),
                        errorStyle: const TextStyle(
                          fontFamily: kBodyFont,
                          color: kTextColor3,
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
                  const SizedBox(height: 20.0),
                  Text(
                    'NRIC / Passport',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
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
                      validator: ValidationBuilder().required('NRIC / Passport is required').minLength(1, 'NRIC / Passport is required').build(),
                      controller: txtic,
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
                        hintText: 'e.g. 96xxxx-xx-xxxx',
                        hintStyle: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor5,
                        ),
                        errorStyle: const TextStyle(
                          fontFamily: kBodyFont,
                          color: kTextColor3,
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
                  const SizedBox(height: 20.0),
                  Text(
                    'Date of Birth',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
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
                      onTap: () async {
                        DateTime? dob = await showDatePicker(
                          context: context,
                          initialDate: dobdt == null ? DateTime.now() : dobdt!,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          locale: const Locale('en', 'AU'),
                          fieldHintText: 'DD/MM/YYYY',
                          helpText: '',
                          confirmText: 'SELECT DATE',
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: kPrimaryColor,
                                ),
                                dialogTheme: DialogTheme(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          }
                        );
                        if (dob != null) {
                          String dobDay = '${dob.day}';
                          dobDay = dobDay.padLeft(2, '0');
                          String dobMonth = '${dob.month}';
                          dobMonth = dobMonth.padLeft(2, '0');
                          txtdob.text = '$dobDay/$dobMonth/${dob.year}';
                          dobdt = DateTime(dob.year, dob.month, dob.day);
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: validate,
                      validator: ValidationBuilder().required('DOB is required').minLength(10, 'DOB is required').build(),
                      controller: txtdob,
                      readOnly: true,
                      showCursor: true,
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
                        hintText: 'DOB (DD/MM/YYYY)',
                        hintStyle: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor5,
                        ),
                        errorStyle: const TextStyle(
                          fontFamily: kBodyFont,
                          color: kTextColor3,
                        ),
                        suffixIcon: const Icon(
                          Icons.event,
                          color: kTextColor1,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                        ),
                        disabledBorder: OutlineInputBorder(
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
                  const SizedBox(height: 20.0),
                  Text(
                    'Email',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
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
                      validator: ValidationBuilder().required('Email is required').minLength(1, 'Email is required').email('Email is invalid').build(),
                      controller: txtemail,
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
                  const SizedBox(height: 20.0),
                  Text(
                    'Password',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: kBgColor2.withOpacity(0.1),
                          offset: const Offset(0, 4.0),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Obx(() =>
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: validate,
                        validator: ValidationBuilder().required('Password is required').minLength(1, 'Password is required').build(),
                        controller: txtpwd,
                        obscureText: ctrl.isPwd,
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
                          suffixIcon: Material(
                            color: Colors.white,
                            type: MaterialType.transparency,
                            child: IconButton(
                              onPressed: () {
                                ctrl.setIsPwd(!ctrl.isPwd);
                              }, 
                              icon: Obx(() =>
                                Icon(
                                  ctrl.isPwd ? Icons.visibility_off : Icons.visibility,
                                  color: kTextColor1,
                                ),
                              ),
                              color: kTextColor1,
                              splashRadius: 22.0,           
                            ),
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
                    '*For hospital registered patient only',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33.0),
                  child: Obx(() =>
                    AppElevatedButton(
                      text: 'Sign Up',
                      onPressed: !ctrl.isValid ? null : onSignUp,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already an existing user?',
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
                        foregroundColor: kPrimaryColor,
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
      title: 'Sign Up',
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            progressIndicator: const AppActivityIndicator(),
            child: buildForm(),
          ),
        ),
      ),
    );
  }
}
