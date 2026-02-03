import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/no_network.dart';
import 'package:vesalius_m_flutter/components/verify_code.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/sign-in/verify_otp_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';
import 'package:vesalius_m_flutter/ui/main_layout.dart';
import 'package:vesalius_m_flutter/ui/sign_in.dart';

class VerifyOTP extends StatelessWidget {

  final String type;
  final String mobile;
  final String contact1;
  final String contact2;
  final String code;

  final VerifyOTPCtrl ctrl = Get.put(VerifyOTPCtrl());

  VerifyOTP({
    super.key,
    required this.type,
    required this.mobile,
    required this.contact1,
    required this.contact2,
    this.code = '',
  });

  void showSuccess() async {
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
              'Success',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              type == 'verify-mobile-signup-signin' ? 
              'Your account has been successfully verified' :
              'Your account has been successfully created.',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Sign In',
              onPressed: () {
                Get.back();
                Get.offAll(() => const SignIn());
              },
            ),
          ],
        ),
      ),
    ));
  }

  void onSubmit() async {
    String tac = ctrl.digits;
    if (type == 'verify-mobile-signin') {
      try {
        ctrl.setIsLoading(true);
        final m = await UserService.postVerifySmsTacSignIn(mobile, tac);
        await DataManager.instance.removeItem('isFirstTimeLogin');
        await DataManager.instance.removeItem('isFirstTimeBiometric');
        await AuthManager.instance.set(m['token'], m['role'], false, false, mobile, true, 1, contact1, contact2);
        if (m['role'] == 'USER') {
          UserDetails? o = await UserService.getUser();
          if (o != null) {
            await DataManager.instance.setUserDetails(o);
            if (o.userBranches.isNotEmpty) {
              await DataManager.instance.setBranchDetails(o.userBranches.first);
              PatientDetails? patientData = await VesaliusService.getVesaliusPatientData(o.userBranches.first.branch!.branchId!, o.userBranches.first.prn!);
              if (patientData != null) {
                await DataManager.instance.setPatientDetails(patientData);
                DataManager.instance.setPrn(o.userBranches.first.prn!);
                //await OneSignal.shared.setExternalUserId(o.userBranches![0].prn!);
                //await StorageDataManager.addUser(o.email!);
                // await DataManager.setUserDetails(o);
              }
            }
          }
        }
        ctrl.setIsLoading(false);
        Get.offAll(() => const MainLayout());
      }

      on DioException catch (error) {
        ctrl.setIsLoading(false);
        if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 400) {
          final mx = error.response?.data as Map?;
          if (mx?.containsKey('message') ?? false) {
            showCustomDialog('Error', mx?['message'], 'Dismiss');
          }

          else {
            showCustomDialog('Verifying Failed', 'Please enter a valid code', 'Dismiss');
          }
        }

        else if (error.type == DioExceptionType.connectionError) {
          Get.to(() => NoNetwork(
            onPressed: () {
              onSubmit();
            },
          ));
        }

        else {
          showCustomDialog('Verifying Failed', 'Please enter a valid code', 'Dismiss');
        }
      }

      catch (_) {
        ctrl.setIsLoading(false);
        showCustomDialog('Verifying Failed', 'Please enter a valid code', 'Dismiss');
      }
    }

    /* else if (type == 'verify-mobile-signup' || type == 'verify-mobile-signup-signin') {
      try {
        ctrl.setIsLoading(true);
        final b = await UserService.postVerifySmsTacSignUp(mobile, tac);
        await DataManager.instance.removeItem('isFirstTimeLogin');
        AuthManager.instance.isFirstTimeLogin = false;
        ctrl.setIsLoading(false);
        if (b) {
          showSuccess();
        }
      }

      catch (_) {
        ctrl.setIsLoading(false);
        showCustomDialog('Verifying Failed', 'Please enter a valid code', 'Dismiss');
      }
    } */
  }

  Widget buildForm() {
    return Stack(
      children: [
        Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 52.0),
                Image.asset(
                  'images/imgs/star2.png',
                  width: 108.0,
                  height: 34.0,
                  fit: BoxFit.contain,
                ),
                /* SizedBox(
                  width: 110.0,
                  child: Container(
                    padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11.1),
                      color: kColor13.withValues(alpha: 0.5),
                    ),
                    child: Text(
                      '******',
                      style: kTextStyle1.copyWith(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ), */
                const SizedBox(height: 32.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Please enter the One Time Password (OTP) sent to ',
                          style: kTextStyle2.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor2,
                          ),
                        ),
                        TextSpan(
                          text: '$mobile.',
                          style: kTextStyle2.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: kTextColor2,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32.0),
                VerifyCode(
                  onAllDigitsEntered: (s) {
                    ctrl.setDigits(s);
                  },
                ),
                const SizedBox(height: 52.0),
                /* Obx(() =>
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'code expires in ',
                          style: kTextStyle1.copyWith(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: kTextColor2,
                          ),
                        ),
                        TextSpan(
                          text: '00:${ctrl.secVal}',
                          style: kTextStyle1.copyWith(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: kTextColor3,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ), */
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: kBgColor1,
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Obx(() =>
              AppElevatedButton(
                text: 'Confirm',
                onPressed: ctrl.isValid == false ? null : onSubmit,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      child: InnerPage(
        title: 'OTP Verification',
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
      ),
    );
  }
}