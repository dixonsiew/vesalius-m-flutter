import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:barcode_scan2/barcode_scan2.dart' as bs;
import 'package:get/get.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/sign_up_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/country_data.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';
import 'package:vesalius_m_flutter/services/common_service.dart';
import 'package:vesalius_m_flutter/ui/sign-in/verify_email_code.dart';

import 'select_country.dart';
import 'select_tel.dart';
import 'sign_in.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(this);
  }
}

class SignUp extends StatefulWidget {

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String playerId = '';
  DateTime? dobdt;
  late final TextEditingController txtprn;
  late final TextEditingController txtfullname;
  late final TextEditingController txtic;
  late final TextEditingController txtdob;
  late final TextEditingController txtemail;
  late final TextEditingController txtpwd;
  late final TextEditingController txtcfmpwd;
  late final TextEditingController txtcontact1;
  late final TextEditingController txtcontact2;
  late final TextEditingController txtbarcode;
  final formKey = GlobalKey<FormState>();

  final SignUpCtrl ctrl = Get.put(SignUpCtrl());

  static final _possibleFormats = bs.BarcodeFormat.values.toList()
    ..removeWhere((e) => e == bs.BarcodeFormat.unknown);
  List<bs.BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  void initState() {
    super.initState();
    txtprn = TextEditingController();
    txtfullname = TextEditingController();
    txtic = TextEditingController();
    txtdob = TextEditingController();
    txtemail = TextEditingController();
    txtpwd = TextEditingController();
    txtcfmpwd = TextEditingController();
    txtcontact1 = TextEditingController();
    txtcontact2 = TextEditingController();
    txtbarcode = TextEditingController();
    initPlatformState();
  }

  @override
  void dispose() {
    txtprn.dispose();
    txtfullname.dispose();
    txtic.dispose();
    txtdob.dispose();
    txtemail.dispose();
    txtpwd.dispose();
    txtcfmpwd.dispose();
    txtcontact1.dispose();
    txtcontact2.dispose();
    txtbarcode.dispose();
    super.dispose();
  }

  void initPlatformState() {
    playerId = AuthManager.instance.getPlayerId();
  }

  void loadCountry() async {
    try {
      if (ctrl.countryList.isEmpty) {
        ctrl.setIsLoading(true);
        final lx = await CommonService.getCountries();
        lx.sort((a, b) {
          return a.countryName.toLowerCase().compareTo(b.countryName.toLowerCase());
        });
        final cx1 = lx.firstWhereOrNull((x) => x.countryName.toLowerCase() == 'malaysia');
        final cx2 = lx.firstWhereOrNull((x) => x.countryName.toLowerCase() == 'singapore');
        final cx3 = lx.firstWhereOrNull((x) => x.countryName.toLowerCase() == 'indonesia');
        if (cx3 != null) {
          lx.removeWhere((x) => x.countryName.toLowerCase() == 'indonesia');
          lx.insert(0, cx3);
        }

        if (cx2 != null) {
          lx.removeWhere((x) => x.countryName.toLowerCase() == 'singapore');
          lx.insert(0, cx2);
        }

        if (cx1 != null) {
          lx.removeWhere((x) => x.countryName.toLowerCase() == 'malaysia');
          lx.insert(0, cx1);
        }

        ctrl.setCountryList(lx);
        ctrl.setIsLoading(false);
      }

      final c = await Get.to<Country?>(() => SelectCountry(selected: ctrl.selectedCountry, list: ctrl.countryList));
      ctrl.setSelectedCountry(c);
      FocusManager.instance.primaryFocus?.unfocus();
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, loadCountry);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  void loadTel() async {
    try {
      if (ctrl.telList.isEmpty) {
        ctrl.setIsLoading(true);
        final lx = await CommonService.getTelCountries();
        ctrl.setTelList(lx);
        ctrl.setIsLoading(false);
      }

      final c = await Get.to<CountryTel?>(() => SelectTel(selected: ctrl.selectedTel, list: ctrl.telList));
      ctrl.setSelectedTel(c);
      txtcontact1.text = c?.telCode ?? '';
      validate(txtcontact1.text);
      FocusManager.instance.primaryFocus?.unfocus();
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, loadTel);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  Future<void> scanBarcode() async {
    final result = await bs.BarcodeScanner.scan(
      options: bs.ScanOptions(
        strings: {
          'cancel': 'Cancel',
          'flash_on': 'Flash on',
          'flash_off': 'Flash off',
        },
        restrictFormat: selectedFormats,
        useCamera: 0,
        autoEnableFlash: false,
        android: const bs.AndroidOptions(
          aspectTolerance: 0.00,
          useAutoFocus: true,
        ),
      ),
    );
    txtbarcode.text = result.rawContent;
    // final bc = await Get.to<String?>(() => BarcodeScan());
    // if (bc != null) {
    //   txtbarcode.text = bc;
    // }
    
    // String barcodeScanRes;
    // try {
    //   barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
    //   txtbarcode.text = barcodeScanRes;
    // } on PlatformException {
    //   showCustomDialog('Failed', 'Failed to get platform version.', 'Dismiss');
    // }
  }

  void validate(String s) {
    bool b = formKey.currentState!.validate();

    if (s.isEmpty) {
      ctrl.setIsValid(false);
    }

    else {
      if (ctrl.signUpOpt == SignUpOpt.email) {
        String s1 = txtpwd.text;
        String s2 = txtcfmpwd.text;
        if (s1.isNotEmpty && s2.isNotEmpty && s1 == s2) {
          ctrl.setIsValid(true & b);
        }

        else if (s1.isNotEmpty && s2.isNotEmpty && s1 != s2) {
          ctrl.setIsValid(false);
        }
      }

      else {
        ctrl.setIsValid(b);
      }
    }
  }

  void showSuccess(String type) async {
    String ms = type == 'email' ? 'The verification code has been sent to your email.\nPlease check your email.' : 'Please proceed to sign in';
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
              'Your account is created',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              ms,
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Next',
              onPressed: () {
                Get.back();
                if (type == 'email') {
                  Get.to(() => VerifyEmailCode(
                    type: 'verify-email-signup',
                    email: txtemail.text,
                  ));
                }
                
                else {
                  Get.offAll(() => const SignIn());
                }
              },
            ),
          ],
        ),
      ),
    ));
  }

  Future<bool> showConfirm() async {
    return await Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please ensure that all information provided matches your registered hospital records.',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back(result: false);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kTextColor2,
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      side: const BorderSide(
                        color: kColor1,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18.0),
                Expanded(
                  child: AppElevatedButton(
                    text: 'Proceed',
                    onPressed: () => Get.back(result: true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )) ?? false;
  }

  void onSignUpMobile() async {
    try {
      String hp2 = txtcontact2.text.trimFirstZero();
      String mobile = '${txtcontact1.text}$hp2';
      ctrl.setIsLoading(true);
      UserBranch? branchDetails = DataManager.instance.branchDetails;
      num branchId = branchDetails == null ? 1 : branchDetails.branch!.branchId!;
      await AdminService.signUpV2(branchId, txtprn.text, txtdob.text, mobile, '', txtfullname.text, txtic.text, '***', playerId, 1);
      AuthManager.instance.isFirstTimeLogin = true;
      AuthManager.instance.isFirstTimeBiometric = true;
      await DataManager.instance.write('isFirstTimeLogin', '1');
      await DataManager.instance.write('isFirstTimeBiometric', '1');
      await DataManager.instance.remove('__biometric-username__');
      await DataManager.instance.remove('__biometric-uuid__');
      await DataManager.instance.removeItem('biometric');
      await DataManager.instance.write('signinType', '1');
      await DataManager.instance.write('contact1', txtcontact1.text);
      await DataManager.instance.write('contact2', hp2);
      ctrl.setIsLoading(false);
      showSuccess('mobile');
      
      // Get.to(() => VerifyOTP(
      //   type: 'verify-mobile-signup',
      //   mobile: mobile,
      //   contact1: txtcontact1.text,
      //   contact2: hp2,
      // ));
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      if (error.type == DioExceptionType.badResponse) {
        final mx = error.response?.data as Map;
        if (mx.containsKey('errorMessage')) {
          showCustomDialog('Error', mx['errorMessage'], 'Dismiss');
        }

        else if (mx.containsKey('message')) {
          showCustomDialog('Error', mx['message'], 'Dismiss');
        }
        
        else {
          showCustomDialog('Error', kError, 'Dismiss');
        }
      }

      else {
        showCustomDialog('Error', kError, 'Dismiss');
      }
    }

    catch (_) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', kError, 'Dismiss');
    }
  }

  void onSignUpEmail() async {
    try {
      String s2 = txtpwd.text;
      String s3 = txtcfmpwd.text;
    
      if (s2 != s3) {
        showCustomDialog('Error', 'Password does not match with confirm password', 'Dismiss');
        return;
      }
      
      ctrl.setIsLoading(true);
      UserBranch? branchDetails = DataManager.instance.branchDetails;
      num branchId = branchDetails == null ? 1 : branchDetails.branch!.branchId!;
      await AdminService.signUpV2(branchId, txtprn.text, txtdob.text, '', txtemail.text, txtfullname.text, txtic.text, txtpwd.text, playerId, 2);
      AuthManager.instance.isFirstTimeLogin = true;
      AuthManager.instance.isFirstTimeBiometric = true;
      await DataManager.instance.write('isFirstTimeLogin', '1');
      await DataManager.instance.write('isFirstTimeBiometric', '1');
      await DataManager.instance.remove('__biometric-username__');
      await DataManager.instance.remove('__biometric-uuid__');
      await DataManager.instance.removeItem('biometric');
      await DataManager.instance.write('signinType', '2');
      await DataManager.instance.write('username', txtemail.text);
      ctrl.setIsLoading(false);
      showSuccess('email');
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      if (error.type == DioExceptionType.badResponse) {
        final mx = error.response?.data as Map;
        if (mx.containsKey('errorMessage')) {
          showCustomDialog('Error', mx['errorMessage'], 'Dismiss');
        }

        else if (mx.containsKey('message')) {
          showCustomDialog('Error', mx['message'], 'Dismiss');
        }
        
        else {
          showCustomDialog('Error', kError, 'Dismiss');
        }
      }

      else {
        showCustomDialog('Error', kError, 'Dismiss');
      }
    }

    catch (_) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', kError, 'Dismiss');
    }
  } 

  void onSubmit() async {
    bool b = await showConfirm();
    if (b) {
      if (ctrl.signUpOpt == SignUpOpt.email) {
        onSignUpEmail();
      }
      
      else {
        onSignUpMobile();
      }
    }
  }

  Widget buildForm() {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 130.0),
            child: Scrollbar(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25.0),
                      Text(
                        'PRN',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor3,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kBgColor2.withValues(alpha: 0.1),
                              offset: const Offset(0.0, 4.0),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: '').required().minLength(1, '').build(),
                          controller: txtprn,
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
                            hintText: 'xx-xxxxxx',
                            hintStyle: kTextStyle1.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor5,
                            ),
                            errorStyle: const TextStyle(
                              fontFamily: kBodyFont,
                              color: kTextColor3,
                            ),
                            enabledBorder: kEnabledBorder,
                            focusedBorder: kFocusedBorder,
                            errorBorder: kErrorBorder,
                            focusedErrorBorder: kFocusedErrorBorder,
                          ),
                        ),
                      ),
                      Text(
                        'Full Name',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor3,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kBgColor2.withValues(alpha: 0.1),
                              offset: const Offset(0.0, 4.0),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: '').required().minLength(1, '').build(),
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
                            enabledBorder: kEnabledBorder,
                            focusedBorder: kFocusedBorder,
                            errorBorder: kErrorBorder,
                            focusedErrorBorder: kFocusedErrorBorder,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        'NRIC / Passport',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor3,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kBgColor2.withValues(alpha: 0.1),
                              offset: const Offset(0.0, 4.0),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: '').required().minLength(1, '').build(),
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
                            hintText: 'e.g.96xxxx-xx-xxxx',
                            hintStyle: kTextStyle1.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor5,
                            ),
                            errorStyle: const TextStyle(
                              fontFamily: kBodyFont,
                              color: kTextColor3,
                            ),
                            enabledBorder: kEnabledBorder,
                            focusedBorder: kFocusedBorder,
                            errorBorder: kErrorBorder,
                            focusedErrorBorder: kFocusedErrorBorder,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        'Date of Birth',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor3,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kBgColor2.withValues(alpha: 0.1),
                              offset: const Offset(0.0, 4.0),
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
                                    dialogTheme: DialogThemeData(
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
                              validate(txtdob.text);
                            }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: '').required().minLength(10, '').build(),
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
                            hintText: '(DD/MM/YYYY)',
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
                              color: kPrimaryColor3,
                            ),
                            enabledBorder: kEnabledBorder,
                            focusedBorder: kFocusedBorder,
                            disabledBorder: kEnabledBorder,
                            errorBorder: kErrorBorder,
                            focusedErrorBorder: kFocusedErrorBorder,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        'Email',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor3,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kBgColor2.withValues(alpha: 0.1),
                              offset: const Offset(0.0, 4.0),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: '').required().minLength(1, '').email('Email is invalid').build(),
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
                            enabledBorder: kEnabledBorder,
                            focusedBorder: kFocusedBorder,
                            errorBorder: kErrorBorder,
                            focusedErrorBorder: kFocusedErrorBorder,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        'Password',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor3,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kBgColor2.withValues(alpha: 0.1),
                              offset: const Offset(0.0, 4.0),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: Obx(() =>
                          TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            onChanged: validate,
                            validator: ValidationBuilder(requiredMessage: '').required().minLength(8, 'Password must be at least 8 characters in length').regExp(kRegExpPassword, 'Password must be alphanumeric').build(),
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
                              hintText: 'Enter password',
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
                              enabledBorder: kEnabledBorder,
                              focusedBorder: kFocusedBorder,
                              errorBorder: kErrorBorder,
                              focusedErrorBorder: kFocusedErrorBorder,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        'Confirm Password',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor3,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kBgColor2.withValues(alpha: 0.1),
                              offset: const Offset(0.0, 4.0),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: Obx(() =>
                          TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            onChanged: validate,
                            validator: ValidationBuilder(requiredMessage: '').required().minLength(8, 'Confirm Password must be at least 8 characters in length').regExp(kRegExpPassword, 'Confirm Password must be alphanumeric').build(),
                            controller: txtcfmpwd,
                            obscureText: ctrl.isCfmPwd,
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
                                    ctrl.setIsCfmPwd(!ctrl.isCfmPwd);
                                  }, 
                                  icon: Obx(() =>
                                    Icon(
                                      ctrl.isCfmPwd ? Icons.visibility_off : Icons.visibility,
                                      color: kTextColor1,
                                    ),
                                  ),
                                  color: kTextColor1,
                                  splashRadius: 22.0,           
                                ),
                              ),
                              enabledBorder: kEnabledBorder,
                              focusedBorder: kFocusedBorder,
                              errorBorder: kErrorBorder,
                              focusedErrorBorder: kFocusedErrorBorder,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                    ],
                  ),
                ),
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
                    '*For registered patients of CVSKL only',
                    style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: kPrimaryColor2,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33.0),
                  child: Obx(() =>
                    AppElevatedButton(
                      text: 'Sign Up',
                      onPressed: !ctrl.isValid ? null : onSubmit,
                     // onPressed: onSubmit,
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
                        foregroundColor: kPrimaryColor2,
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
                /* Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33.0),
                  child: AppElevatedButton(
                    text: 'Scan Barcode',
                    onPressed: scanBarcode,
                  ),
                ),
                const SizedBox(height: 8.0), */
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
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: buildForm(),
          ),
        ),
      ),
    );
  }
}

/* class BarcodeScan extends StatelessWidget {

  final MobileScannerController cameraController = MobileScannerController();

  BarcodeScan({super.key});

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Barcode Scanner',
      actions: [
        IconButton(
          color: Colors.white,
          icon: ValueListenableBuilder(
            valueListenable: cameraController.torchState,
            builder: (context, state, child) {
              switch (state) {
                case TorchState.off:
                  return const Icon(Icons.flash_off, color: Colors.grey);
                case TorchState.on:
                  return const Icon(Icons.flash_on, color: Colors.yellow);
              }
            },
          ),
          iconSize: 32.0,
          onPressed: () => cameraController.toggleTorch(),
        ),
        IconButton(
          color: Colors.white,
          icon: ValueListenableBuilder(
            valueListenable: cameraController.cameraFacingState,
            builder: (context, state, child) {
              switch (state) {
                case CameraFacing.front:
                  return const Icon(Icons.camera_front, color: kPrimaryColor);
                case CameraFacing.back:
                  return const Icon(Icons.camera_rear, color: kPrimaryColor);
              }
            },
          ),
          iconSize: 32.0,
          onPressed: () => cameraController.switchCamera(),
        ),
      ],
      body: MobileScanner(
        // fit: BoxFit.contain,
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          // final Uint8List? image = capture.image;
          String? barcodex;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
            barcodex = barcode.rawValue;
          }

          if (barcodex != null) {
            Get.back(result: barcodex);
          }
        },
      ),
    );
  }
} */