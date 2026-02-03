import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app-shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/services/auth-service.dart';

import 'sign-in.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(this);
  }
}

class SignUp extends StatefulWidget {

  static const String routeName = 'SignUp';

  @override
  _SignUpState createState() => _SignUpState();
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

  @override
  void dispose() {
    txtfullname.dispose();
    txtdob.dispose();
    txtic.dispose();
    txtemail.dispose();
    super.dispose();
  }

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
      showCustomDialog('Successful', m['successMessage'], 'Dismiss', context);
    }

    on DioError catch (error) {
      setState(() {
        isLoading = false;
      });
      if (error.type == DioErrorType.response) {
        var mx = error.response?.data as Map;
        if (mx.containsKey('errorMessage')) {
          showCustomDialog('Failed', mx['errorMessage'], 'Dismiss', context);
        }

        else if (mx.containsKey('message')) {
          showCustomDialog('Failed', mx['message'], 'Dismiss', context);
        }
        
        else {
          showCustomDialog('Failed', 'Sign Up failed', 'Dismiss', context);
        }
      }

      else {
        showCustomDialog('Failed', 'Sign Up failed', 'Dismiss', context);
      }
    }
  }

  Widget buildForm() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0, right: 20.0),
                  child: IconButton(
                    icon: Icon(
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
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text(
                  'Enter your personal details',
                  style: TextStyle(
                    color: kMainColor,
                    fontSize: 24.0,
                    fontFamily: kTitleFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: validate,
                  validator: ValidationBuilder().required('Fullname is required').minLength(1, 'Fullname is required').build(),
                  controller: txtfullname,
                  cursorColor: Color(0xFF929292),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: kBodyFont,
                    color: Color(0xFF929292),
                  ),
                  decoration: InputDecoration(
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
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: validate,
                  validator: ValidationBuilder().required('NRIC / Passport is required').minLength(1, 'NRIC / Passport is required').build(),
                  controller: txtic,
                  cursorColor: Color(0xFF929292),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: kBodyFont,
                    color: Color(0xFF929292),
                  ),
                  decoration: InputDecoration(
                    hintText: 'NRIC (with dash) / Passport',
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
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  onTap: () async {
                    DateTime? dob = await showDatePicker(
                      context: context,
                      initialDate: dobdt == null ? DateTime.now() : dobdt!,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      locale: Locale('en', 'AU'),
                      fieldHintText: 'DD/MM/YYYY',
                      helpText: '',
                      confirmText: 'SELECT DATE',
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: kHomeBgColor,
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

                    else {
                      dobdt = null;
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: validate,
                  validator: ValidationBuilder().required('DOB is required').minLength(10, 'DOB is required').build(),
                  controller: txtdob,
                  readOnly: true,
                  showCursor: true,
                  cursorColor: Color(0xFF929292),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: kBodyFont,
                    color: Color(0xFF929292),
                  ),
                  decoration: InputDecoration(
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
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: validate,
                  validator: ValidationBuilder().required('Email is required').minLength(1, 'Email is required').email('Email is invalid').build(),
                  controller: txtemail,
                  cursorColor: Color(0xFF929292),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: kBodyFont,
                    color: Color(0xFF929292),
                  ),
                  decoration: InputDecoration(
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
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: RawMaterialButton(
                  elevation: 5.0,
                  fillColor: kHomeBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                  constraints: BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: kBodyFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: valid ? onSignUp : null,
                ),
              ),
              SizedBox(height: 10.0),
              Align(
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
              SizedBox(height: 30.0),
              Align(
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
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, SignIn.routeName);
                },
                child: Text(
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
              SizedBox(height: 10.0),
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
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light, statusBarColor: kMainColor),
        toolbarHeight: 0.0,
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: AppActivityIndicator(),
        child: SafeArea(
          child: Scrollbar(
            child: buildForm(),
          ),
        ),
      ),
    );
  }
}
