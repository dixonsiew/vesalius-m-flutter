import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/required_label.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/little-explorer/register_exp2_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/services/little-explorer/register_exp3_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/services/little-explorer/register_exp_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/country_data.dart';
import 'package:vesalius_m_flutter/models/kidsmembership_data.dart';
import 'package:vesalius_m_flutter/services/clubs_service.dart';
import 'package:vesalius_m_flutter/services/common_service.dart';
import 'package:vesalius_m_flutter/services/guest_service.dart';
import 'package:vesalius_m_flutter/ui/select_country.dart';
import 'package:vesalius_m_flutter/ui/services/little_explorer.dart';

import 'register_exp.dart';
import 'select_language.dart';
import 'select_relationship.dart';

class RegisterExp3 extends StatefulWidget {

  const RegisterExp3({super.key});

  @override
  State<RegisterExp3> createState() => _RegisterExp3State();
}

class _RegisterExp3State extends State<RegisterExp3> {

  late final TextEditingController txtaddr;
  late final TextEditingController txtpostcode;
  late final TextEditingController txtstate;
  late final TextEditingController txtcountry;
  late final TextEditingController txtrel;
  late final TextEditingController txtlang;
  final formKey = GlobalKey<FormState>();

  final RegisterExp3Ctrl ctrl = Get.put(RegisterExp3Ctrl());
  final RegisterExpCtrl registerExpCtrl = Get.put(RegisterExpCtrl());
  final RegisterExp2Ctrl registerExp2Ctrl = Get.put(RegisterExp2Ctrl());

  @override
  void initState() {
    super.initState();
    txtaddr = TextEditingController();
    txtpostcode = TextEditingController();
    txtstate = TextEditingController();
    txtcountry = TextEditingController();
    txtrel = TextEditingController();
    txtlang = TextEditingController(text: 'English');
    ctrl.setSelectedLanguage('English');
    KidsGuardianForm? frm = registerExpCtrl.kidsGuardianForm;
    if (frm != null) {
      txtaddr.text = frm.addr;
      txtpostcode.text = frm.postcode;
      txtstate.text = frm.state;
    }

    load();
  }

  @override
  void dispose() {
    txtaddr.dispose();
    txtpostcode.dispose();
    txtstate.dispose();
    super.dispose();
  }

  void load() async {
    try {
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
      setForm();
      ctrl.setIsLoading(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, load);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
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

  void validateForm() {
    validate(txtaddr.text);
    validate(txtcountry.text);
    validate(txtrel.text);
  }

  void setForm() {
    if (!registerExp2Ctrl.isRegisterSelf) return;
    txtaddr.text = registerExpCtrl.user?.address ?? '';
    txtpostcode.text = registerExpCtrl.user?.postalCode ?? '';
    txtstate.text = registerExpCtrl.user?.cityState ?? '';
    String? country = registerExpCtrl.user?.country;
    if (country != null) {
      final countryRef = ctrl.countryList.firstWhereOrNull((x) => x.countryName.trim().toUpperCase() == country.trim().toUpperCase());
      if (countryRef != null) {
        ctrl.setSelectedCountry(countryRef);
        txtcountry.text = countryRef.countryName;
      }
    }

    validateForm();
  }

  void showSuccess() {
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
              'images/icon/tick.png',
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Member Added Successfully',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'You have added ',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor6,
                    ),
                  ),
                  TextSpan(
                    text: '${registerExpCtrl.kidsMembershipForm?.name} ',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                  TextSpan(
                    text: 'as club member.',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor6,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Done',
              onPressed: () {
                Get.back();
                Get.until((route) => Get.currentRoute == LittleExplorer.routeName);
              },
            ),
          ],
        ),
      ),
    ));
  }

  void onSubmit() async {
    final frm1 = registerExpCtrl.kidsMembershipForm!;
    final frm2 = registerExpCtrl.kidsGuardianForm!;
    try {
      final o = {
        'kidsName': frm1.name,
        'kidsDob': frm1.dob,
        'kidsDocType': frm1.idType,
        'kidsDocNumber': frm1.idNum,
        'kidsGender': frm1.gender,
        'kidsNationality': frm1.nationality,
        'kidsEmail': frm1.email,
        'guardianName': frm2.name,
        'guardianDob': frm2.dob,
        'guardianDocType': frm2.idType,
        'guardianDocNumber': frm2.idNum,
        'guardianGender': frm2.gender,
        'guardianNationality': frm2.nationality,
        'guardianEmail': frm2.email,
        'guardianHomeContact': '${frm2.homeContact1}${frm2.homeContact2}',
        'guardianMobileContact': '${frm2.hp1}${frm2.hp2}',
        'guardianAddress1': txtaddr.text,
        'guardianAddress2': '',
        'guardianAddress3': '',
        'guardianPostCode': txtpostcode.text,
        'guardianState': txtstate.text,
        'guardianCountryCode': ctrl.selectedCountry?.countryCode ?? 'MY',
        'relationship': ctrl.selectedRelationship == '' ? 'Son' : ctrl.selectedRelationship,
        'preferredLanguage': ctrl.selectedLanguage == '' ? 'Others' : ctrl.selectedLanguage
      };
      ctrl.setIsLoading(true);
      if (AuthManager.instance.isLogin) {
        await ClubsService.postLittleKidsMembership(o);
      }

      else {
        await GuestModeService.postLittleKidsMembership(o);
      }
      
      ctrl.setIsLoading(false);
      showSuccess();
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleSubmitError(error, 'Unable to create new membership at the moment. Please check your internet connection or try again later.', null);
    }

    catch (_) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', 'Unable to create new membership at the moment. Please check your internet connection or try again later.', 'Dismiss');
    }
  }

  Widget buildStep() {
    return SizedBox(
      width: double.infinity,
      height: 40.0,
      child: Row(
        children: [
          Expanded(
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              isFirst: true,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: kPrimaryColor),
                  ),
                  child: Center(
                    child: Text(
                      '1',
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              afterLineStyle: const LineStyle(
                color: kPrimaryColor,
                thickness: 1,
              ),
              endChild: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Explorers’ Information',
                  style: kTextStyle1.copyWith(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              isLast: true,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: kColor12.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: kPrimaryColor),
                  ),
                  child: Center(
                    child: Text(
                      '2',
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              beforeLineStyle: const LineStyle(
                color: kPrimaryColor,
                thickness: 1,
              ),
              endChild: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Guardian Information',
                  style: kTextStyle1.copyWith(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
                      const SizedBox(height: 16.0),
                      buildStep(),
                      const SizedBox(height: 24.0),
                      const ReqLbl(s: 'Address'),
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
                          validator: ValidationBuilder(requiredMessage: 'Address is required').required().minLength(1, 'Address is required').build(),
                          controller: txtaddr,
                          cursorColor: kTextColor1,
                          maxLines: 4,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: kInputDecoration.copyWith(
                            hintText: 'Address',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 103.0,
                            child: Text(
                              'Postcode',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24.0),
                          Expanded(
                            child: Text(
                              'State',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 103.0,
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
                              controller: txtpostcode,
                              cursorColor: kTextColor1,
                              style: const TextStyle(
                                fontFamily: kBodyFont,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                              decoration: kInputDecoration.copyWith(
                                hintText: 'Postcode',
                              ),
                            ),
                          ),
                          const SizedBox(width: 24.0),
                          Expanded(
                            child: Container(
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
                                controller: txtstate,
                                cursorColor: kTextColor1,
                                style: const TextStyle(
                                  fontFamily: kBodyFont,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: kTextColor1,
                                ),
                                decoration: kInputDecoration.copyWith(
                                  hintText: 'State',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                
                      const ReqLbl(s: 'Country'),
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
                          onTap: () async {
                            final c = await Get.to<Country?>(() => SelectCountry(selected: ctrl.selectedCountry, list: ctrl.countryList));
                            if (c != null) {
                              ctrl.setSelectedCountry(c);
                              txtcountry.text = c.countryName;
                              validate(c.countryName);
                            }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: 'Country is required').required().minLength(1, 'Country is required').build(),
                          controller: txtcountry,
                          readOnly: true,
                          showCursor: true,
                          cursorColor: kTextColor1,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: kInputDecoration.copyWith(
                            hintText: 'Please Select',
                            suffixIcon: const Icon(
                              Icons.expand_more,
                              color: kTextColor1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                
                      const ReqLbl(s: 'Relationship'),
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
                          onTap: () async {
                            final s = await Get.to<String?>(() => SelectRelationship(selected: ctrl.selectedRelationship));
                            if (s != null) {
                              ctrl.setSelectedRelationship(s);
                              txtrel.text = s;
                              validate(s);
                            }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: 'Relationship is required').required().minLength(1, 'Relationship is required').build(),
                          controller: txtrel,
                          readOnly: true,
                          showCursor: true,
                          cursorColor: kTextColor1,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: kInputDecoration.copyWith(
                            hintText: 'Please Select',
                            suffixIcon: const Icon(
                              Icons.expand_more,
                              color: kTextColor1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                
                      Text(
                        'Preferred Language',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
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
                          onTap: () async {
                            final s = await Get.to<String?>(() => SelectLanguage(selected: ctrl.selectedLanguage));
                            if (s != null) {
                              ctrl.setSelectedLanguage(s);
                              txtlang.text = s;
                            }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          controller: txtlang,
                          readOnly: true,
                          showCursor: true,
                          cursorColor: kTextColor1,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: kInputDecoration.copyWith(
                            hintText: 'Please Select',
                            suffixIcon: const Icon(
                              Icons.expand_more,
                              color: kTextColor1,
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() =>
                  AppElevatedButton(
                    text: 'Confirm',
                    onPressed: !ctrl.isValid ? null : onSubmit,
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
      title: 'Register',
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