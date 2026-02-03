import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/required_label.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/little-explorer/my_membership_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/services/little-explorer/my_membership_id_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/services/little-explorer/select_member_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/kidsclub_data.dart';
import 'package:vesalius_m_flutter/services/guest_service.dart';
import 'package:vesalius_m_flutter/ui/services/little_explorer.dart';

import 'confirm_join_club_activity.dart';
import 'my_membership.dart';
import 'register_exp.dart';

class MyMembershipId extends StatefulWidget {

  final KidsClub? data;
  final int fromUI;

  const MyMembershipId({
    super.key,
    this.data,
    this.fromUI = 0,
  });

  @override
  State<MyMembershipId> createState() => _MyMembershipIdState();
}

class _MyMembershipIdState extends State<MyMembershipId> {

  late final TextEditingController txtidnum;
  final formKey = GlobalKey<FormState>();

  final MyMembershipIdCtrl ctrl = Get.put(MyMembershipIdCtrl());
  final MyMembershipCtrl myMembershipCtrl = Get.put(MyMembershipCtrl());
  final SelectMemberCtrl selectMemberCtrl = Get.put(SelectMemberCtrl());

  @override
  void initState() {
    super.initState();
    txtidnum = TextEditingController();
  }

  @override
  void dispose() {
    txtidnum.dispose();
    super.dispose();
  }

  void validate(String s) {
    bool b = formKey.currentState!.validate();

    if (s.isEmpty) {
      ctrl.setIsValid(false);
    }

    else {
      ctrl.setIsValid(b);
    }
  }

  void showError() {
    Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/icon/error1.png',
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Error',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Sorry, you have not registered yet.\nPlease register as a new member.',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Register Now',
              onPressed: () {
                Get.back();
                Get.until((route) => Get.currentRoute == LittleExplorer.routeName);
                Get.to(() => const RegisterExp());
              },
            ),
          ],
        ),
      ),
    ));
  }

  void onNext() async {
    try {
      ctrl.setIsLoading(true);
      List<KidsMembership> lx = await GuestModeService.getLittleKidsMembership(txtidnum.text);
      if (lx.isEmpty) {
        ctrl.setIsLoading(false);
        showError();
        return;
      }

      else {
        if (widget.fromUI == 0) {
          myMembershipCtrl.setList(lx);
          ctrl.setIsLoading(false);
          Get.to(() => MyMembership(data: widget.data!));
        }
        
        else {
          ctrl.setIsLoading(false);
          selectMemberCtrl.addMember(lx.first);
          Get.to(() => const ConfirmJoinClubActivity());
        }
      }
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, onNext);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  Widget buildForm() {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 144.0),
            child: Scrollbar(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24.0),
                      const ReqLbl(s: 'Identification Number'),
                      const SizedBox(height: 8.0),
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
                          validator: ValidationBuilder(requiredMessage: 'Identification Number is required').required().minLength(1, 'Identification Number is required').build(),
                          controller: txtidnum,
                          cursorColor: kTextColor1,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: kInputDecoration.copyWith(
                            hintText: 'e.g. 10xxxx-xx-xxxx',
                          ),
                        ),
                      ),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() =>
                  AppElevatedButton(
                    text: 'Next',
                    onPressed: !ctrl.isValid ? null : onNext,
                  ),
                ),
                const SizedBox(height: 16.0),
                AppOutlinedButton(
                  text: 'Cancel',
                  onPressed: () => Get.back(),
                ),
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
      title: 'My Membership',
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