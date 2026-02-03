import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vesalius_m_flutter/components/app-shared.dart';
import 'package:vesalius_m_flutter/components/bottom-red.dart';
import 'package:vesalius_m_flutter/components/top-red.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth-manager.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/services/auth-service.dart';

import 'home.dart';

class FirstTimeLogin extends StatefulWidget {
  
  static final String routeName = 'FirstTimeLogin';

  @override
  _FirstTimeLoginState createState() => _FirstTimeLoginState();
}

class _FirstTimeLoginState extends State<FirstTimeLogin> {

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  final txtcode = TextEditingController();

  void logout() async {
    await DataManager.clear();
    Navigator.pushNamedAndRemoveUntil(context, Home.routeName, (route) => false);
  }

  void onVerify() async {
    try {
      setState(() {
        isLoading = true;
      });
      await postVerificationCode(txtcode.text);
      await DataManager.removeItem('isFirstTimeLogin');
      await AuthManager.setIsLogin(true);
      setState(() {
        isLoading = false;
      });
      Navigator.pushNamedAndRemoveUntil(context, Home.routeName, (route) => false);
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
      showCustomDialog('Verifying Failed', 'Please enter a valid code', 'Dismiss', context);
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
            TopRed(),
            BottomRed(),

            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.0, right: 20.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: kPrimaryColor,
                    ),
                    onPressed: () {
                     logout();
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
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage('images/imgs/nova.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40.0, bottom: 17.0),
                      child: Text(
                        'FIRST TIME LOGIN',
                        style: TextStyle(
                          color: Color(0xFF414141),
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Text(
                      'Enter your verification code to continue',
                      style: TextStyle(
                        color: Color(0xFF585858),
                        fontSize: 18.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0, bottom: 20.0),
                      child: TextFormField(
                        controller: txtcode,
                        cursorColor: Color(0xFF929292),
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color(0xFF929292),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Verification Code',
                          hintStyle: TextStyle(
                            color: Color(0xFF929292),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFF585858),
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
                      child: RawMaterialButton(
                        elevation: 5.0,
                        fillColor: kPrimaryBtnBgColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        constraints: BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: onVerify,
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
        brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
        toolbarHeight: 0.0,
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: AppActivityIndicator(), // AppScalingText('Please wait...'),
        child: SafeArea(
          child: Scrollbar(
            child: buildForm(),
          ),
        ),
      ),
    );
  }
}