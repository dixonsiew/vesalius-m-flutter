import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app-shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth-manager.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/services/auth-service.dart';

import 'home.dart';

class FirstTimeLogin extends StatefulWidget {
  
  static const String routeName = 'FirstTimeLogin';

  @override
  _FirstTimeLoginState createState() => _FirstTimeLoginState();
}

class _FirstTimeLoginState extends State<FirstTimeLogin> {

  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final txtcode = TextEditingController();

  @override
  void dispose() {
    txtcode.dispose();
    super.dispose();
  }

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
                      logout();
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
                padding: EdgeInsets.only(top: 40.0, bottom: 17.0),
                child: Text(
                  'FIRST TIME LOGIN',
                  style: TextStyle(
                    color: kMainColor,
                    fontSize: 18.0,
                    fontFamily: kTitleFont,
                  ),
                ),
              ),
              Text(
                'Enter your verification code to continue',
                style: TextStyle(
                  color: kMainColor,
                  fontSize: 18.0,
                  fontFamily: kTitleFont,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0, bottom: 20.0),
                child: TextFormField(
                  controller: txtcode,
                  cursorColor: Color(0xFF929292),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: kBodyFont,
                    color: Color(0xFF929292),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Verification Code',
                    hintStyle: TextStyle(
                      color: Color(0xFF929292),
                      fontFamily: kBodyFont,
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
                  fillColor: kHomeBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                  constraints: BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: kBodyFont,
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