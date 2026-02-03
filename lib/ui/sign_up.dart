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
import 'package:vesalius_m_flutter/models/data_manager.dart';
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

  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isValid = false;
  bool isLoading = false;
  DateTime? dobdt;
  bool isPwd = false;
  final formKey = GlobalKey<FormState>();
  final txtfullname = TextEditingController();
  final txtic = TextEditingController();
  final txtdob = TextEditingController();
  final txtemail = TextEditingController();
  final txtpwd = TextEditingController();

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
      setState(() {
        isValid = false;
      });
    }

    else {
      setState(() {
        isValid = b;
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
              'Sign Up Successfully',
              style: kLabelTextStyle.copyWith(
                fontFamily: kMainFont,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Your account is created.',
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

  void onSignUp() async {
    try {
      setState(() {
        isLoading = true;
      });
      var branchDetails = DataManager.branchDetails;
      num branchId = branchDetails == null ? 1 : branchDetails.branch!.branchId!;
      await signUp(branchId, txtdob.text, txtemail.text, txtfullname.text, txtic.text);
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
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 25.0),
                  Text(
                    'Full Name',
                    style: kLabelTextStyle.copyWith(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: validate,
                    validator: ValidationBuilder().required('Fullname is required').minLength(1, 'Fullname is required').build(),
                    controller: txtfullname,
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
                      hintText: 'e.g.John Smith',
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
                  const SizedBox(height: 20.0),
                  Text(
                    'NRIC / Passport',
                    style: kLabelTextStyle.copyWith(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: validate,
                    validator: ValidationBuilder().required('NRIC / Passport is required').minLength(1, 'NRIC / Passport is required').build(),
                    controller: txtic,
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
                      hintText: 'Enter NRIC / Passport',
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
                  const SizedBox(height: 20.0),
                  Text(
                    'Date of Birth',
                    style: kLabelTextStyle.copyWith(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  TextFormField(
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
                                primary: kMainColor,
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
                      hintText: 'DOB (DD/MM/YYYY)',
                      hintStyle: kBodyTextStyle.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFB1B1B1),
                      ),
                      errorStyle: const TextStyle(
                        fontFamily: kBodyFont,
                        color: Color(0xFFFA4954),
                      ),
                      suffixIcon: const Icon(
                        Icons.event,
                        color: Color(0xFF8C8C8C),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0.0)),
                        borderSide: BorderSide(color: Color(0xFFE9E9E9)),
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
                  const SizedBox(height: 20.0),
                  Text(
                    'Email',
                    style: kLabelTextStyle.copyWith(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  TextFormField(
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
                  const SizedBox(height: 20.0),
                  Text(
                    'Password',
                    style: kLabelTextStyle.copyWith(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: validate,
                    validator: ValidationBuilder().required('Password is required').minLength(1, 'Password is required').build(),
                    controller: txtpwd,
                    obscureText: isPwd,
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
                      hintText: 'Enter Password',
                      hintStyle: kBodyTextStyle.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFB1B1B1),
                      ),
                      errorStyle: const TextStyle(
                        fontFamily: kBodyFont,
                        color: Color(0xFFFA4954),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPwd ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFF8C8C8C),
                        ),
                        color: const Color(0xFF8C8C8C),
                        onPressed: () {
                          setState(() {
                            isPwd = !isPwd;
                          });
                        },            
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
                  const SizedBox(height: 180.0),
                ],
              ),
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
                    onPressed: isValid ? onSignUp : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      backgroundColor: kMainColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    ),
                    child: Text(
                      'Sign Up',
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
                      'Already an existing user? ',
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
                const SizedBox(height: 5.0),
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
        centerTitle: true,
        title: Text(
          'Sign Up',
          style: kMainTextStyle.copyWith(
            fontSize: 16.0,
            color: const Color(0xFF002E50),
          ),
        ),
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
