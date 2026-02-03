import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/services/medical_history.dart';

class MedicalHistoryAuth extends StatefulWidget {

  static const String routeName = '/MedicalHistoryAuth';

  const MedicalHistoryAuth({Key? key}) : super(key: key);

  @override
  State<MedicalHistoryAuth> createState() => _MedicalHistoryAuthState();
}

class _MedicalHistoryAuthState extends State<MedicalHistoryAuth> {

  bool isPwd = true;
  bool isValid = false;
  bool isLoading = false;
  late final TextEditingController txtpwd;

  @override
  void initState() {
    super.initState();
    txtpwd = TextEditingController();
  }

  @override
  void dispose() {
    txtpwd.dispose();
    super.dispose();
  }

  void validate(String s) {
    if (txtpwd.text.isEmpty) {
      setState(() {
        isValid = false;
      });
    }

    else {
      setState(() {
        isValid = true;
      });
    }
  }

  Widget buildContent() {
    return Stack(
      children: [
        Scrollbar(
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 25.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Please enter your password for accessing your medical history. You may have to repeat this process again if you wish you access the reports again after 30 mins.',
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Password',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: kBgColor2.withOpacity(0.1),
                      offset: const Offset(0, 4.0),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: TextField(
                  controller: txtpwd,
                  obscureText: isPwd,
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
                      color: const Color(0xFFBDC2CC),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPwd ? Icons.visibility_off : Icons.visibility,
                        color: kTextColor1,
                      ),
                      color: kTextColor1,
                      onPressed: () {
                        setState(() {
                          isPwd = !isPwd;
                        });
                      },            
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                    ),
                  ),
                  onChanged: validate,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: kMainColor,
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kMainColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: kBgColor1,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: !isValid ? null : () {
                  Get.toNamed(MedicalHistory.routeName);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5.0,
                  backgroundColor: kMainColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                ),
                child: Text(
                  'Submit',
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: kBgColor1,
        leading: const BackBtn(color: kTextColor1),
        centerTitle: true,
        title: Text(
          'Medical History',
          style: kTextStyle1.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: kTextColor1,
          ),
        ),
        elevation: 0.0,
      ),
      backgroundColor: kBgColor1,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(),
        child: SafeArea(
          child: buildContent(),
        ),
      ),
    );
  }
}