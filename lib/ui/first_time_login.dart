import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';

import 'home.dart';

class FirstTimeLogin extends StatefulWidget {
  
  static const String routeName = 'FirstTimeLogin';

  const FirstTimeLogin({Key? key}) : super(key: key);

  @override
  State<FirstTimeLogin> createState() => _FirstTimeLoginState();
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
    NavigatorState nav = Navigator.of(context);
    await DataManager.clear();
    nav.pushNamedAndRemoveUntil(Home.routeName, (route) => false);
  }

  void onVerify() async {
    CustomDialog dlg = CustomDialog.of(context);
    try {
      setState(() {
        isLoading = true;
      });
      NavigatorState nav = Navigator.of(context);
      await postVerificationCode(txtcode.text);
      await DataManager.removeItem('isFirstTimeLogin');
      await AuthManager.setIsLogin(true);
      setState(() {
        isLoading = false;
      });
      nav.pushNamedAndRemoveUntil(Home.routeName, (route) => false);
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
      dlg.showCustomDialog('Verifying Failed', 'Please enter a valid code', 'Dismiss');
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
                  padding: const EdgeInsets.only(top: 20.0, right: 20.0),
                  child: IconButton(
                    icon: const Icon(
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
              const Padding(
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
              const Text(
                'Enter your verification code to continue',
                style: TextStyle(
                  color: kMainColor,
                  fontSize: 18.0,
                  fontFamily: kTitleFont,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0, bottom: 20.0),
                child: TextFormField(
                  controller: txtcode,
                  cursorColor: const Color(0xFF929292),
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontFamily: kBodyFont,
                    color: Color(0xFF929292),
                  ),
                  decoration: const InputDecoration(
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
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: RawMaterialButton(
                  elevation: 5.0,
                  fillColor: kHomeBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                  constraints: const BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
                  onPressed: onVerify,
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: kBodyFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light, statusBarColor: kMainColor),
        toolbarHeight: 0.0,
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(), // AppScalingText('Please wait...'),
        child: SafeArea(
          child: Scrollbar(
            child: buildForm(),
          ),
        ),
      ),
    );
  }
}