import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/required_label.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/health-package/billing_detail_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/billing_data.dart';
import 'package:vesalius_m_flutter/models/country_data.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/services/common_service.dart';
import 'package:vesalius_m_flutter/ui/select_country.dart';
import 'package:vesalius_m_flutter/ui/select_tel.dart';

import 'checkout.dart';

final kInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 12.0),
  filled: true,
  fillColor: Colors.white,
  hintText: '',
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
);

class BillingDetail extends StatefulWidget {

  const BillingDetail({super.key});

  @override
  State<BillingDetail> createState() => _BillingDetailState();
}

class _BillingDetailState extends State<BillingDetail> {

  late final TextEditingController txtfullname;
  late final TextEditingController txtemail;
  late final TextEditingController txtaddr1;
  late final TextEditingController txtaddr2;
  late final TextEditingController txtaddr3;
  late final TextEditingController txtcity;
  late final TextEditingController txtstate;
  late final TextEditingController txtpostcode;
  late final TextEditingController txtcountry;
  late final TextEditingController txtcontact1;
  late final TextEditingController txtcontact2;
  final formKey = GlobalKey<FormState>();

  final BillingDetailCtrl ctrl = Get.put(BillingDetailCtrl());

  @override
  void initState() {
    super.initState();
    txtfullname = TextEditingController();
    txtemail = TextEditingController();
    txtaddr1 = TextEditingController();
    txtaddr2 = TextEditingController();
    txtaddr3 = TextEditingController();
    txtcity = TextEditingController();
    txtstate = TextEditingController();
    txtpostcode = TextEditingController();
    txtcountry = TextEditingController();
    txtcontact1 = TextEditingController();
    txtcontact2 = TextEditingController();
    ctrl.setIsSameAsProfile(false);
    ctrl.setSelectedCountry(null);
    load();
  }

  @override
  void dispose() {
    txtfullname.dispose();
    txtemail.dispose();
    txtaddr1.dispose();
    txtaddr2.dispose();
    txtaddr3.dispose();
    txtcity.dispose();
    txtstate.dispose();
    txtpostcode.dispose();
    txtcountry.dispose();
    txtcontact1.dispose();
    txtcontact2.dispose();
    super.dispose();
  }

  void load() async {
    ctrl.setUserDetails(await DataManager.instance.getUserDetails());
    try {
      ctrl.setIsLoading(true);
      final lw = <Future<dynamic>>[
        CommonService.getCountries(),
        CommonService.getTelCountries(),
      ];
      final lr = await Future.wait<dynamic>(lw);
      final List<Country> lx = lr[0];
      final List<CountryTel> lt = lr[1];
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
      ctrl.setTelList(lt);
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

  void onSelectCountry() async {
    final c = await Get.to<Country?>(() => SelectCountry(selected: ctrl.selectedCountry, list: ctrl.countryList));
    if (c != null) {
      ctrl.setSelectedCountry(c);
      txtcountry.text = c.countryName;
      validateForm();
    }
  }

  void onSelectTel() async {
    final c = await Get.to<CountryTel?>(() => SelectTel(selected: ctrl.selectedTel, list: ctrl.telList));
    if (c != null) {
      ctrl.setSelectedTel(c);
      txtcontact1.text = c.telCode ?? '';
      validateForm();
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

  Widget buildCountry(Country x) {
    return CountryItem(
      key: ValueKey('${x.countryCode}-${x.countryName}'),
      data: x, 
      onTap: () {
        ctrl.setSelectedCountry(x);
        txtcontact1.text = x.telCode ?? '';
        validateForm();
        Get.back();
      });
  }

  List<Widget> buildCountryList() {
    return ctrl.countryList.map((x) => buildCountry(x)).toList();
  }

  void showCountryLookup() async {
    final c = await Get.to<Country?>(() => SelectCountry(list: ctrl.countryList));
    ctrl.setSelectedCountry(c);
    validateForm();

    /* Get.dialog(AlertDialog(
      scrollable: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: kBgColor1,
      content: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: SingleChildScrollView(
              child: Obx(() =>
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buildCountryList(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 16.0, bottom: 24.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: kColor6.withValues(alpha: 0.21),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: TextField(
                controller: txtsearch,
                autofocus: false,
                cursorColor: kPrimaryColor,
                textInputAction: TextInputAction.search,
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
                  hintText: '',
                  hintStyle: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: kTextColor5,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 15.0),
                    child: Icon(
                      Icons.search,
                      color: kPrimaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide(color: kColor1.withValues(alpha: 0.35)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide(color: kColor1.withValues(alpha: 0.35)),
                  ),
                ),
                onChanged: (s) {
                  if (s.isEmpty) {
                    ctrl.setTempCountryList(ctrl.tcountryList);
                  }

                  else {
                    final lx = ctrl.tcountryList.where((x) => x.countryCode.toLowerCase().contains(s.toLowerCase()) ||
                    x.countryName.toLowerCase().contains(s.toLowerCase())).toList();
                    ctrl.setTempCountryList(lx);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    )); */
  }

  void validateForm() {
    validate(txtfullname.text);
    validate(txtemail.text);
    validate(txtaddr1.text);
    validate(txtcountry.text);
    validate(txtcontact1.text);
    validate(txtcontact2.text);
  }

  void setForm() {
    txtfullname.text = '${ctrl.user?.firstName} ${ctrl.user?.middleName ?? ''} ${ctrl.user?.lastName ?? ''}'.trim();
    txtemail.text = ctrl.user?.email ?? '';
    txtaddr1.text = ctrl.user?.address1 ?? ctrl.user?.address ?? '';
    txtaddr2.text = ctrl.user?.address2 ?? '';
    txtaddr3.text = ctrl.user?.address3 ?? '';
    txtcity.text = ctrl.user?.cityState ?? '';
    txtpostcode.text = ctrl.user?.postalCode ?? '';
    txtcountry.text = '';
    txtcontact1.text = '';
    txtcontact2.text = ctrl.user?.contactNo ?? '';
    String? country = ctrl.user?.country;
    if (country != null) {
      final countryRef = ctrl.countryList.firstWhereOrNull((x) => x.countryName.trim().toUpperCase() == country.trim().toUpperCase());
      if (countryRef != null) {
        ctrl.setSelectedCountry(countryRef);
        txtcountry.text = countryRef.countryName;
      }

      final telRef = ctrl.telList.firstWhereOrNull((x) => x.countryName.trim().toUpperCase() == country.trim().toUpperCase());
      if (telRef != null) {
        ctrl.setSelectedTel(telRef);
        txtcontact1.text = telRef.telCode ?? '';
      }
    }

    validateForm();
  }

  void resetForm() {
    txtfullname.text = '';
    txtemail.text = '';
    txtaddr1.text = '';
    txtaddr2.text = '';
    txtaddr3.text = '';
    txtcity.text = '';
    txtpostcode.text = '';
    txtcountry.text = '';
    txtcontact1.text = '';
    txtcontact2.text = '';
    ctrl.setSelectedCountry(null);
    ctrl.setSelectedTel(null);
    validateForm();
  }

  void onReset() {
    ctrl.setIsSameAsProfile(false);
    resetForm();
  }

  void saveBilling() {
    if (ctrl.selectedCountry == null) {
      showCustomDialog('Error', 'Please select country', 'Dismiss');
      return;
    }

    final o = Billing(
      fullName: txtfullname.text, 
      email: txtemail.text, 
      address1: txtaddr1.text, 
      address2: txtaddr2.text, 
      address3: txtaddr3.text, 
      city: txtcity.text, 
      state: txtstate.text, 
      postcode: txtpostcode.text, 
      contact1: txtcontact1.text, 
      contact2: txtcontact2.text,
    );
    ctrl.setBilling(o);
    Get.to(() => const Checkout());
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
                      const SizedBox(height: 18.0),
                      if (AuthManager.instance.isLogin) ...[
                        Row(
                          children: [
                            Checkbox(
                              shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                              activeColor: kPrimaryColor,
                              value: ctrl.isSameAsProfile,
                              onChanged: (value) {
                                ctrl.setIsSameAsProfile(value ?? false);
                                if (value == true) {
                                  setForm();
                                }
                                
                                else {
                                  resetForm();
                                }
                              },
                            ),
                            Expanded(
                              child: Text(
                                'Same as profile',
                                style: kTextStyle1.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: kTextColor1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22.0),
                        Text(
                          'Patient Name',
                          style: kTextStyle1.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: kTextColor1,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: kColor12.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: kColor10),
                            boxShadow: [
                              BoxShadow(
                                color: kBgColor2.withValues(alpha: 0.1),
                                offset: const Offset(0.0, 4.0),
                                blurRadius: 4.0,
                              ),
                            ],
                          ),
                          child: Text(
                            '${ctrl.user?.firstName} ${ctrl.user?.middleName ?? ''} ${ctrl.user?.lastName ?? ''}'.trim(),
                            style: kTextStyle1.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22.0),
                      ],
                      const ReqLbl(s: 'Payor Full Name'),
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
                          validator: ValidationBuilder(requiredMessage: 'Payor Full Name is required').required().minLength(1, 'Payor Full Name is required').build(),
                          controller: txtfullname,
                          cursorColor: kTextColor1,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: kInputDecoration.copyWith(
                            hintText: 'e.g.John Smith',
                          ),
                        ),
                      ),
                      const SizedBox(height: 22.0),
                      const ReqLbl(s: 'Email'),
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
                          validator: ValidationBuilder(requiredMessage: 'Email is required').required().minLength(1, 'Email is required').regExp(kRegExpEmail, 'Email is invalid').email('Email is invalid').build(),
                          controller: txtemail,
                          cursorColor: kTextColor1,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: kInputDecoration.copyWith(
                            hintText: 'e.g.JohnSmith@abc.com',
                          ),
                        ),
                      ),
                      const SizedBox(height: 22.0),
                      const ReqLbl(s: 'Address 1'),
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
                          validator: ValidationBuilder(requiredMessage: 'Address 1 is required').required().minLength(1, 'Address 1 is required').build(),
                          controller: txtaddr1,
                          cursorColor: kTextColor1,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: kInputDecoration.copyWith(
                            hintText: 'e.g. 123, Main Street',
                          ),
                        ),
                      ),
                      const SizedBox(height: 22.0),
                      Text(
                        'Address 2',
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
                          controller: txtaddr2,
                          cursorColor: kTextColor1,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: kInputDecoration.copyWith(
                            hintText: 'e.g. 123, Main Street',
                          ),
                        ),
                      ),
                      const SizedBox(height: 22.0),
                      Text(
                        'Address 3',
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
                          controller: txtaddr3,
                          cursorColor: kTextColor1,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: kInputDecoration.copyWith(
                            hintText: 'e.g. 123, Main Street',
                          ),
                        ),
                      ),
                      const SizedBox(height: 22.0),
                      Text(
                        'City/Town',
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
                          controller: txtcity,
                          cursorColor: kTextColor1,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: kInputDecoration.copyWith(
                            hintText: 'City/Town',
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
                      const SizedBox(height: 6.0),
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
                      const SizedBox(height: 22.0),
                      const ReqLbl(s: 'Country'),
                      const SizedBox(height: 6.0),
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
                          onTap: onSelectCountry,
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
                      const SizedBox(height: 22.0),
                      const ReqLbl(s: 'Contact Number'),
                      const SizedBox(height: 6.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 78.85,
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
                              onTap: onSelectTel,
                              autovalidateMode: AutovalidateMode.always,
                              onChanged: validate,
                              validator: ValidationBuilder(requiredMessage: 'Contact Number is required').required().minLength(1, 'Contact Number is required').build(),
                              controller: txtcontact1,
                              readOnly: true,
                              cursorColor: kTextColor1,
                              style: const TextStyle(
                                fontFamily: kBodyFont,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                              decoration: kInputDecoration.copyWith(
                                hintText: '+60',
                              ),
                            ),
                          ),
                          const SizedBox(width: 13.0),
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
                                onChanged: validate,
                                validator: ValidationBuilder(requiredMessage: 'Contact Number is required').required().minLength(1, 'Contact Number is required').maxLength(20, 'Contact Number is invalid').build(),
                                controller: txtcontact2,
                                cursorColor: kTextColor1,
                                keyboardType: TextInputType.number,
                                maxLength: 20,
                                style: const TextStyle(
                                  fontFamily: kBodyFont,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: kTextColor1,
                                ),
                                decoration: kInputDecoration.copyWith(
                                  hintText: 'e.g 123338888',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6.0),
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
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppOutlinedButton(
                  text: 'Reset',
                  onPressed: onReset,
                ),
                const SizedBox(height: 16.0),
                Obx(() =>
                  AppElevatedButton(
                    text: 'Next',
                    onPressed: !ctrl.isValid ? null : () {
                      saveBilling();
                    },
                  ),
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
      title: 'Add Billing Details',
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

class CountryItem extends StatelessWidget {

  final Country data;
  final void Function() onTap;

  const CountryItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kColor1)),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '(${data.countryCode}) ${data.countryName.toUpperCase()}',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: kTextColor1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}