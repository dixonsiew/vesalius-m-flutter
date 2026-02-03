import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

import 'home.dart';

class ChangePassword extends StatefulWidget {
  
  static const String routeName = 'ChangePassword';

  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  bool valid = false;
  bool isTxt = false;
  bool isTxt1 = false;
  bool isTxt2 = false;
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  final txtcurrent = TextEditingController();
  final txtnew = TextEditingController();
  final txtconfirm = TextEditingController();

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

  void onSubmit() async {
    String s1 = txtcurrent.text;
    String s2 = txtnew.text;
    String s3 = txtconfirm.text;
    final dlg = CustomDialog.of(context);
    
    if (s2 != s3) {
      dlg.showCustomDialog('Failed', 'Password does not match with confirm password', 'Dismiss');
    }

    else {
      try {
        var o = {
          'newPassword': s2,
          'oldPassword': s1
        };
        setState(() {
          isLoading = true;
        });
        final nav = Navigator.of(context);
        await changePassword(o);
        setState(() {
          isLoading = false;
        });
        await dlg.showCustomDialog('Successful', 'Password successfully changed', 'Dismiss');
        nav.popUntil(ModalRoute.withName(Home.routeName));
      }

      on DioException catch (error) {
        setState(() {
          isLoading = false;
        });
        if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 417 &&
        s1 == s2) {
          dlg.showCustomDialog('Failed', 'New Password is not allowed to be the same with Old Password', 'Dismiss');
        }

        else {
          dlg.showCustomDialog('Failed', 'Invalid password', 'Dismiss');
        }
      }
    }
  }

  Widget buildSubmit() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: RawMaterialButton(
          elevation: 5.0,
          fillColor: kChangePasswordBgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          constraints: const BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
          onPressed: valid ? onSubmit : null,
          child: const Text(
            'Change Password',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontFamily: kBodyFont,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForm() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(133, 133, 133, 0.29),
            offset: Offset(5, 4),
            blurRadius: 10.0,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Scrollbar(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.lock,
                      color: Color(0xFF8D7E7E),
                      size: 24.0,
                    ),
                    SizedBox(width: 15.0),
                    Text(
                      'Current Password',
                      style: TextStyle(
                        color: Color(0xFF727272),
                        fontSize: 18.0,
                        fontFamily: kTitleFont,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: validate,
                  validator: ValidationBuilder().required('Current Password is required').build(),
                  controller: txtcurrent,
                  cursorColor: Colors.black,
                  obscureText: !isTxt,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontFamily: kBodyFont,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isTxt ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF929292),
                      ),
                      onPressed: () {
                        setState(() {
                          isTxt = !isTxt;
                        });
                      },            
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Color(0xFF727272)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Color(0xFF727272)),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
        
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.lock,
                      color: Color(0xFF8D7E7E),
                      size: 24.0,
                    ),
                    SizedBox(width: 15.0),
                    Text(
                      'New Password',
                      style: TextStyle(
                        color: Color(0xFF727272),
                        fontSize: 18.0,
                        fontFamily: kBodyFont,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: validate,
                  validator: ValidationBuilder().required('New Password is required').minLength(6, 'Password need at least 6 characters').regExp(RegExp(r'^[a-zA-Z0-9]*$'), 'Invalid password').build(),
                  controller: txtnew,
                  cursorColor: Colors.black,
                  obscureText: !isTxt1,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontFamily: kBodyFont,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isTxt1 ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF929292),
                      ),
                      onPressed: () {
                        setState(() {
                          isTxt1 = !isTxt1;
                        });
                      },            
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Color(0xFF727272)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Color(0xFF727272)),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
        
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.lock,
                      color: Color(0xFF8D7E7E),
                      size: 24.0,
                    ),
                    SizedBox(width: 15.0),
                    Text(
                      'Confirm Password',
                      style: TextStyle(
                        color: Color(0xFF727272),
                        fontSize: 18.0,
                        fontFamily: kBodyFont,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: validate,
                  validator: ValidationBuilder().required('Confirm Password is required').minLength(6, 'Password need at least 6 characters').regExp(RegExp(r'^[a-zA-Z0-9]*$'), 'Invalid password').build(),
                  controller: txtconfirm,
                  cursorColor: Colors.black,
                  obscureText: !isTxt2,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontFamily: kBodyFont,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isTxt2 ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF929292),
                      ),
                      onPressed: () {
                        setState(() {
                          isTxt2 = !isTxt2;
                        });
                      },            
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Color(0xFF727272)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Color(0xFF727272)),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
        
              const Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: Text(
                  'Password requirement',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: kBodyFont,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 5.0,
                          height: 5.0,
                          margin: const EdgeInsets.only(right: 15.0, top: 5.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF4B4B4B),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'New Password is not allowed to be same with Old Password',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: kBodyFont,
                              color: Color(0xFF4B4B4B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 5.0,
                          height: 5.0,
                          margin: const EdgeInsets.only(right: 15.0, top: 5.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF4B4B4B),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Minimum password length: 6 characters (alphanumeric)',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: kBodyFont,
                              color: Color(0xFF4B4B4B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset(
            'images/icon/page-header-icon/password.png',
            width: 65.0,
            height: 50.0,
            fit: BoxFit.contain,
          ),
          const Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                'Change Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLayer2() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
          buildHeader(),
          Expanded(
            child: buildForm(),
          ),
          buildSubmit(),
        ],
      ),
    );
  }

  Widget buildLayer1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          height: 160.0,
          color: kChangePasswordBgColor,
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            color: const Color(0xFFF5F5F5),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kChangePasswordBgColor),
        backgroundColor: kChangePasswordBgColor,
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: const BackBtn(
          color: Color.fromARGB(255, 255, 253, 253),
          fontWeight: FontWeight.bold,
        ),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(), // AppScalingText('Please wait...'),
        child: SafeArea(
          child: Stack(
            children: [
              buildLayer1(),
              buildLayer2(),
            ],
          ),
        ),
      ),
    );
  }
}