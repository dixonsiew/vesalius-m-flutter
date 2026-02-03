import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/required_label.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/golden-pearl/register_exp2_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/services/golden-pearl/register_exp_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/country_data.dart';
import 'package:vesalius_m_flutter/models/doctype_data.dart';
import 'package:vesalius_m_flutter/models/goldenpearlmembership_data.dart';
import 'package:vesalius_m_flutter/services/common_service.dart';
import 'package:vesalius_m_flutter/ui/select_tel.dart';
import 'package:vesalius_m_flutter/ui/services/little-explorer/select_doctype.dart';
import 'package:vesalius_m_flutter/ui/services/little-explorer/select_gender.dart';
import 'package:vesalius_m_flutter/ui/services/little-explorer/select_nationality.dart';

import 'register_exp.dart';
import 'register_exp3.dart';

class RegisterExp2 extends StatefulWidget {

  const RegisterExp2({super.key});

  @override
  State<RegisterExp2> createState() => _RegisterExp2State();
}

class _RegisterExp2State extends State<RegisterExp2> {

  DateTime? dobdt;
  late final TextEditingController txtname;
  late final TextEditingController txtdob;
  late final TextEditingController txtidtype;
  late final TextEditingController txtidnum;
  late final TextEditingController txtgender;
  late final TextEditingController txtnat;
  late final TextEditingController txtemail;
  late final TextEditingController txtcontact1;
  late final TextEditingController txtcontact2;
  late final TextEditingController txthp1;
  late final TextEditingController txthp2;
  final formKey = GlobalKey<FormState>();

  final RegisterExp2Ctrl ctrl = Get.put(RegisterExp2Ctrl());
  final RegisterExpCtrl registerExpCtrl = Get.put(RegisterExpCtrl());

  @override
  void initState() {
    super.initState();
    txtname = TextEditingController();
    txtdob = TextEditingController();
    txtidtype = TextEditingController();
    txtidnum = TextEditingController();
    txtgender = TextEditingController();
    txtnat = TextEditingController();
    txtemail = TextEditingController();
    txtcontact1 = TextEditingController();
    txtcontact2 = TextEditingController();
    txthp1 = TextEditingController();
    txthp2 = TextEditingController();
    NokForm? frm = registerExpCtrl.nokForm;
    if (frm != null) {
      txtname.text = frm.name;
      txtdob.text = frm.dob;
      txtidtype.text = frm.idType;
      txtidnum.text = frm.idNum;
      txtgender.text = frm.gender;
      txtnat.text = frm.nationality;
      txtemail.text = frm.email;
      txtcontact1.text = frm.homeContact1;
      txtcontact2.text = frm.homeContact2;
      txthp1.text = frm.hp1;
      txthp2.text = frm.hp2;
      dobdt = Jiffy.parse(frm.dob, pattern: 'dd/MM/yyyy').dateTime;
      Future.delayed(const Duration(milliseconds: 100), () => validateForm());
    }
  }

  @override
  void dispose() {
    txtname.dispose();
    txtdob.dispose();
    txtidtype.dispose();
    txtidnum.dispose();
    txtgender.dispose();
    txtnat.dispose();
    txtemail.dispose();
    txtcontact1.dispose();
    txtcontact2.dispose();
    txthp1.dispose();
    txthp2.dispose();
    super.dispose();
  }

  void loadNat() async {
    try {
      if (ctrl.nationalityList.isEmpty) {
        ctrl.setIsLoading(true);
        final lx = await CommonService.getNationalities();
        ctrl.setNationalityList(lx);
        ctrl.setIsLoading(false);
      }

      final s = await Get.to<String?>(() => SelectNationality(selected: ctrl.selectedNationality, list: ctrl.nationalityList));
      if (s != null) {
        ctrl.setSelectedNationality(s);
        txtnat.text = s;
        validate(s);
      }
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, loadNat);
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

      final o = await Get.to<CountryTel?>(() => SelectTel(selected: ctrl.selectedTel, list: ctrl.telList));
      if (o != null) {
        ctrl.setSelectedTel(o);
        txthp1.text = o.telCode ?? '';
        validate(txthp1.text);
      }
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

  void loadHomeTel() async {
    try {
      if (ctrl.telList.isEmpty) {
        ctrl.setIsLoading(true);
        final lx = await CommonService.getTelCountries();
        ctrl.setTelList(lx);
        ctrl.setIsLoading(false);
      }

      final o = await Get.to<CountryTel?>(() => SelectTel(selected: ctrl.selectedTel, list: ctrl.telList));
      if (o != null) {
        ctrl.setSelectedHomeTel(o);
        txtcontact1.text = o.telCode ?? '';
        validate(txtcontact1.text);
      }
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
    validate(txtname.text);
    validate(txtdob.text);
    validate(txtidtype.text);
    validate(txtgender.text);
    validate(txtnat.text);
    validate(txtemail.text);
  }

  void setForm() {
    txtname.text = '${registerExpCtrl.user?.firstName} ${registerExpCtrl.user?.middleName ?? ''} ${registerExpCtrl.user?.lastName ?? ''}'.trim();
    txtdob.text = registerExpCtrl.user?.dob ?? '';
    txtemail.text = registerExpCtrl.user?.email ?? '';
    txtcontact2.text = registerExpCtrl.user?.contactNo ?? '';
    if (txtdob.text.isNotEmpty) {
      dobdt = Jiffy.parse(txtdob.text, pattern: 'dd/MM/yyyy').dateTime;
    }

    txtgender.text = registerExpCtrl.user?.sex ?? 'Male';
    txtnat.text = registerExpCtrl.user?.nationality ?? '';
    ctrl.setSelectedGender(registerExpCtrl.user?.sex ?? 'Male');
    ctrl.setSelectedNationality(registerExpCtrl.user?.nationality ?? '');
    validateForm();
  }

  void resetForm() {
    txtname.text = '';
    txtdob.text = '';
    txtgender.text = '';
    txtnat.text = '';
    txtemail.text = '';
    txtcontact2.text = '';
    ctrl.setSelectedGender('');
    ctrl.setSelectedNationality('');
    validateForm();
  }

  void onNext() {
    NokForm frm = NokForm(
      name: txtname.text, 
      dob: txtdob.text, 
      idType: ctrl.selectedDocType?.code ?? 'NRIC',
      idNum: txtidnum.text, 
      gender: ctrl.selectedGender == '' ? 'Male' : ctrl.selectedGender, 
      nationality: ctrl.selectedNationality == '' ? 'Malaysian' : ctrl.selectedNationality, 
      email: txtemail.text, 
      homeContact1: txtcontact1.text, 
      homeContact2: txtcontact2.text, 
      hp1: txthp1.text, 
      hp2: txthp2.text, 
      addr: '', 
      postcode: '', 
      state: '', 
      country: 'MY', 
      relationship: 'Others', 
      language: 'CN',
    );
    registerExpCtrl.setNokForm(frm);
    Get.to(() => const RegisterExp3());
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
                  "Senior Citizen's Information",
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
                    color: const Color(0xFFF4F4F4).withValues(alpha: 0.8),
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
                  'Next of Kin',
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
                      if (registerExpCtrl.isRegisterSelf == false && AuthManager.instance.isLogin) ...[
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Obx(() =>
                              Checkbox(
                                shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                activeColor: kPrimaryColor,
                                value: ctrl.isRegisterSelf,
                                onChanged: (value) {
                                  ctrl.setRegisterSelf(value ?? false);
                                  if (value == true) {
                                    setForm();
                                  }
                                
                                  else {
                                    resetForm();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              'Same as profile',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16.0),
                      Text(
                        "NOK's Name *",
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
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: "NOK's Name is required").required().minLength(1, "NOK's Name is required").build(),
                          controller: txtname,
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
                      const SizedBox(height: 24.0),

                      const ReqLbl(s: 'Date of Birth'),
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
                          validator: ValidationBuilder(requiredMessage: 'DOB is required').required().minLength(10, 'DOB is required').build(),
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
                          decoration: kInputDecoration.copyWith(
                            hintText: 'DD/MM/YYYY',
                            suffixIcon: const Icon(
                              Icons.event,
                              color: kTextColor1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                
                      const ReqLbl(s: 'Identification Type'),
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
                            final x = await Get.to<DocType?>(() => SelectDocType(selected: ctrl.selectedDocType));
                            if (x != null) {
                              ctrl.setSelectedDocType(x);
                              txtidtype.text = x.name;
                              validate(txtidtype.text);
                            }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: 'Identification Type is required').required().minLength(1, 'Identification Type is required').build(),
                          controller: txtidtype,
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
                      const SizedBox(height: 24.0),
                
                      const ReqLbl(s: 'Gender'),
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
                            final s = await Get.to<String?>(() => SelectGender(selected: ctrl.selectedGender));
                            if (s != null) {
                              ctrl.setSelectedGender(s);
                              txtgender.text = s;
                              validate(s);
                            }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: 'Gender is required').required().minLength(1, 'Gender is required').build(),
                          controller: txtgender,
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
                
                      const ReqLbl(s: 'Nationality'),
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
                          onTap: loadNat,
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: 'Nationality is required').required().minLength(1, 'Nationality is required').build(),
                          controller: txtnat,
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
                
                      const ReqLbl(s: 'Email Address'),
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
                          validator: ValidationBuilder(requiredMessage: 'Email is required').required().minLength(1, 'Email is required').email('Email is invalid').build(),
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
                      const SizedBox(height: 24.0),
                
                      Text(
                        'Home Contact Number',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                      const SizedBox(height: 8.0),
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
                              onTap: loadHomeTel,
                              autovalidateMode: AutovalidateMode.always,
                              // onChanged: validate,
                              // validator: ValidationBuilder(requiredMessage: 'Contact Number is required').required().minLength(1, 'Contact Number is required').build(),
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
                                hintText: '+03',
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
                                // onChanged: validate,
                                // validator: ValidationBuilder(requiredMessage: 'Contact Number is required').required().minLength(1, 'Contact Number is required').build(),
                                controller: txtcontact2,
                                cursorColor: kTextColor1,
                                style: const TextStyle(
                                  fontFamily: kBodyFont,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: kTextColor1,
                                ),
                                decoration: kInputDecoration.copyWith(
                                  hintText: '123338888',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        'Mobile Contact Number',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                      const SizedBox(height: 8.0),
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
                              onTap: loadTel,
                              autovalidateMode: AutovalidateMode.always,
                              // onChanged: validate,
                              // validator: ValidationBuilder(requiredMessage: 'Contact Number is required').required().minLength(1, 'Contact Number is required').build(),
                              controller: txthp1,
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
                                // onChanged: validate,
                                // validator: ValidationBuilder(requiredMessage: 'Contact Number is required').required().minLength(1, 'Contact Number is required').build(),
                                controller: txthp2,
                                cursorColor: kTextColor1,
                                style: const TextStyle(
                                  fontFamily: kBodyFont,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: kTextColor1,
                                ),
                                decoration: kInputDecoration.copyWith(
                                  hintText: '123338888',
                                ),
                              ),
                            ),
                          ),
                        ],
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