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
import 'package:vesalius_m_flutter/services/data_service.dart';

class ChangePassword extends StatefulWidget {
  
  static const String routeName = '/ChangePassword';

  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  bool isCurrentPwd = false;
  bool isNewPwd = false;
  bool isConfirmPwd = false;
  String currentPwd = '';
  String newPwd = '';
  String confirmPwd = '';
  bool isValid = false;
  bool isLoading = false;
  late final TextEditingController txtcurrent;
  late final TextEditingController txtnew;
  late final TextEditingController txtconfirm;
  final formKey = GlobalKey<FormState>();

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
              'Successful',
              style: kLabelTextStyle.copyWith(
                fontFamily: kMainFont,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Password successfully changed.',
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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kMainColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
              ),
              child: Text(
                'Dismiss',
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

  void onSubmit() async {
    String s1 = txtcurrent.text;
    String s2 = txtnew.text;
    String s3 = txtconfirm.text;
    
    if (s2 != s3) {
      showCustomDialog('Failed', 'Password does not match with confirm password', 'Dismiss');
    }

    else {
      try {
        final o = {
          'newPassword': s2,
          'oldPassword': s1
        };
        setState(() {
          isLoading = true;
        });
        await changePassword(o);
        setState(() {
          isLoading = false;
        });
        await showSuccess();
        //await showCustomDialog('Successful', 'Password successfully changed', 'Dismiss', context);
        Get.back();
        //Navigator.popUntil(context, ModalRoute.withName(Home.routeName));
      }

      on DioError catch (error) {
        setState(() {
          isLoading = false;
        });
        if (error.type == DioErrorType.response && error.response?.statusCode == 417 &&
        s1 == s2) {
          showCustomDialog('Failed', 'New Password is not allowed to be the same with Old Password', 'Dismiss');
        }

        else {
          showCustomDialog('Failed', 'Invalid password', 'Dismiss');
        }
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
                  const SizedBox(height: 46.0),
                  Text(
                    'Current Password',
                    style: kLabelTextStyle.copyWith(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: validate,
                    validator: ValidationBuilder(requiredMessage: 'Current Password is required').required('Current Password is required').minLength(1, 'Current Password is required').build(),
                    controller: txtcurrent,
                    obscureText: isCurrentPwd,
                    cursorColor: const Color(0xFF002E50),
                    style: const TextStyle(
                      fontFamily: kBodyFont,
                      fontSize: 18.0,
                      color: Color(0xFF002E50),
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 22.0),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Current Password',
                      hintStyle: kBodyTextStyle.copyWith(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFB1B1B1),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isCurrentPwd ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFF8C8C8C),
                        ),
                        color: const Color(0xFF8C8C8C),
                        onPressed: () {
                          setState(() {
                            isCurrentPwd = !isCurrentPwd;
                          });
                        },            
                      ),
                      errorStyle: const TextStyle(
                        fontFamily: kBodyFont,
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
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22.0),
                  Text(
                    'New Password',
                    style: kLabelTextStyle.copyWith(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: validate,
                    validator: ValidationBuilder(requiredMessage: 'New Password is required').required('New Password is required').minLength(1, 'New Password is required').build(),
                    controller: txtnew,
                    obscureText: isNewPwd,
                    cursorColor: const Color(0xFF002E50),
                    style: const TextStyle(
                      fontFamily: kBodyFont,
                      fontSize: 18.0,
                      color: Color(0xFF002E50),
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 22.0),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'New Password',
                      hintStyle: kBodyTextStyle.copyWith(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFB1B1B1),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isNewPwd ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFF8C8C8C),
                        ),
                        color: const Color(0xFF8C8C8C),
                        onPressed: () {
                          setState(() {
                            isNewPwd = !isNewPwd;
                          });
                        },            
                      ),
                      errorStyle: const TextStyle(
                        fontFamily: kBodyFont,
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
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22.0),
                  Text(
                    'Confirm Password',
                    style: kLabelTextStyle.copyWith(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: validate,
                    validator: ValidationBuilder(requiredMessage: 'Confirm Password is required').required('Confirm Password is required').minLength(1, 'Confirm Password is required').build(),
                    controller: txtconfirm,
                    obscureText: isConfirmPwd,
                    cursorColor: const Color(0xFF002E50),
                    style: const TextStyle(
                      fontFamily: kBodyFont,
                      fontSize: 18.0,
                      color: Color(0xFF002E50),
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 22.0),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Confirm Password',
                      hintStyle: kBodyTextStyle.copyWith(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFB1B1B1),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConfirmPwd ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFF8C8C8C),
                        ),
                        color: const Color(0xFF8C8C8C),
                        onPressed: () {
                          setState(() {
                            isConfirmPwd = !isConfirmPwd;
                          });
                        },            
                      ),
                      errorStyle: const TextStyle(
                        fontFamily: kBodyFont,
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
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100.0),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.only(left: 33.0, right: 33.0, bottom: 16.0),
            color: const Color(0xFFF8F8F8),
            child: ElevatedButton(
              onPressed: isValid ? onSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: kMainColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
              ), 
              child: Text(
                'Save',
                style: kMainTextStyle.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
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
          'Change Password',
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