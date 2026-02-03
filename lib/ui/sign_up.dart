import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/bottom_red.dart';
import 'package:vesalius_m_flutter/components/top_red.dart';
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

  static const String routeName = 'SignUp';

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool valid = false;
  bool isLoading = false;
  DateTime? dobdt;

  final formKey = GlobalKey<FormState>();
  final txtfullname = TextEditingController();
  final txtdob = TextEditingController();
  final txtic = TextEditingController();
  final txtemail = TextEditingController();

  void validate(String s) {
    bool b = formKey.currentState!.validate();

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

  void onSignUp() async {
    final dlg = CustomDialog.of(context);
    try {
      setState(() {
        isLoading = true;
      });
      var branchDetails = DataManager.branchDetails;
      num branchId = branchDetails == null ? 1 : branchDetails.branch!.branchId!;
      var m = await signUp(branchId, txtdob.text, txtemail.text, txtfullname.text, txtic.text);
      setState(() {
        isLoading = false;
      });
      dlg.showCustomDialog('Successful', m['successMessage'], 'Dismiss');
    }

    on DioError catch (error) {
      setState(() {
        isLoading = false;
      });
      if (error.type == DioErrorType.badResponse) {
        var mx = error.response?.data as Map;
        if (mx.containsKey('errorMessage')) {
          dlg.showCustomDialog('Failed', mx['errorMessage'], 'Dismiss');
        }

        else if (mx.containsKey('message')) {
          dlg.showCustomDialog('Failed', mx['message'], 'Dismiss');
        }
        
        else {
          dlg.showCustomDialog('Failed', 'Sign Up failed', 'Dismiss');
        }
      }

      else {
        dlg.showCustomDialog('Failed', 'Sign Up failed', 'Dismiss');
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
            const TopRed(),
            const BottomRed(),

            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, right: 20.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: kPrimaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
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
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage('images/imgs/nova.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Text(
                        'Enter your personal details',
                        style: TextStyle(
                          color: kPrimaryColor,
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
                        validator: ValidationBuilder().required('Fullname is required').minLength(1, 'Fullname is required').build(),
                        controller: txtfullname,
                        cursorColor: const Color(0xFF929292),
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontFamily: kBodyFont,
                          color: Color(0xFF929292),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Fullname',
                          hintStyle: TextStyle(
                            color: Color(0xFF929292),
                            fontFamily: kBodyFont,
                          ),
                          errorStyle: TextStyle(
                            fontFamily: kBodyFont,
                          ),
                          prefixIcon: Icon(
                            Icons.account_circle,
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: validate,
                        validator: ValidationBuilder().required('NRIC / Passport is required').minLength(1, 'NRIC / Passport is required').build(),
                        controller: txtic,
                        cursorColor: const Color(0xFF929292),
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontFamily: kBodyFont,
                          color: Color(0xFF929292),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'NRIC / Passport',
                          hintStyle: TextStyle(
                            color: Color(0xFF929292),
                            fontFamily: kBodyFont,
                          ),
                          errorStyle: TextStyle(
                            fontFamily: kBodyFont,
                          ),
                          prefixIcon: Icon(
                            Icons.contacts,
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        onTap: () async {
                          DateTime? dob = await showDatePicker(
                            context: context,
                            initialDate: dobdt ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            locale: const Locale('en', 'AU'),
                            fieldHintText: 'DD/MM/YYYY',
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: kPrimaryColor,
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
                        cursorColor: const Color(0xFF929292),
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontFamily: kBodyFont,
                          color: Color(0xFF929292),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'DOB (DD/MM/YYYY)',
                          hintStyle: TextStyle(
                            color: Color(0xFF929292),
                            fontFamily: kBodyFont,
                          ),
                          errorStyle: TextStyle(
                            fontFamily: kBodyFont,
                          ),
                          prefixIcon: Icon(
                            Icons.event,
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
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                            borderSide: BorderSide(color: Color(0xFFE9E9E9)),
                          ),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                      child: RawMaterialButton(
                        elevation: 5.0,
                        fillColor: kPrimaryBtnBgColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        constraints: const BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
                        onPressed: valid ? onSignUp : null,
                        child: const Text(
                          'Sign Up',
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
                          color: kPrimaryColor,
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
                          color: kPrimaryColor,
                          fontSize: 14.0,
                          fontFamily: kBodyFont,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(SignIn.routeName);
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: kPrimaryColor,
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light, statusBarColor: kPrimaryBgColor),
        toolbarHeight: 0.0,
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(),
        child: SafeArea(
          child: Scrollbar(
            child: buildForm(),
          ),
        ),
      ),
    );
  }
}
