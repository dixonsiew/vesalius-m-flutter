import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/ui/services/medical_history.dart';

class MedicalHistoryAuth extends StatefulWidget {

  const MedicalHistoryAuth({super.key});

  @override
  State<MedicalHistoryAuth> createState() => _MedicalHistoryAuthState();
}

class _MedicalHistoryAuthState extends State<MedicalHistoryAuth> {

  bool isPwd = true;
  bool isValid = false;
  bool isLoading = false;
  ScrollController scr = ScrollController();
  late final TextEditingController txtpwd;

  @override
  void initState() {
    super.initState();
    txtpwd = TextEditingController();
  }

  @override
  void dispose() {
    scr.dispose();
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
          controller: scr,
          child: ListView(
            controller: scr,
            shrinkWrap: true,
            children: [
              const SizedBox(height: 48.0),
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
              const SizedBox(height: 30.0),
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
                      color: kBgColor2.withValues(alpha: 0.1),
                      offset: const Offset(0.0, 4.0),
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
                      color: kTextColor5,
                    ),
                    suffixIcon: Material(
                      color: Colors.white,
                      type: MaterialType.transparency,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isPwd = !isPwd;
                          });
                        }, 
                        icon: Icon(
                          isPwd ? Icons.visibility_off : Icons.visibility,
                          color: kTextColor1,
                        ),
                        color: kTextColor1,
                        splashRadius: 22.0,         
                      ),
                    ),
                    enabledBorder: kEnabledBorder,
                    focusedBorder: kFocusedBorder,
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
                      foregroundColor: kPrimaryColor,
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
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
              child: AppElevatedButton(
                text: 'Submit',
                onPressed: !isValid ? null : () {
                  Get.to(() => const MedicalHistory());
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Medical History',
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        blur: kBlur,
        progressIndicator: const AppActivityIndicator(),
        child: SafeArea(
          child: buildContent(),
        ),
      ),
    );
  }
}