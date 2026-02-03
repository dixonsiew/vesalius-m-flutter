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
import 'package:vesalius_m_flutter/controllers/services/golden-pearl/register_exp_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctype_data.dart';
import 'package:vesalius_m_flutter/models/goldenpearlmembership_data.dart';
import 'package:vesalius_m_flutter/services/common_service.dart';
import 'package:vesalius_m_flutter/ui/services/little-explorer/select_doctype.dart';
import 'package:vesalius_m_flutter/ui/services/little-explorer/select_gender.dart';
import 'package:vesalius_m_flutter/ui/services/little-explorer/select_nationality.dart';

import 'register_exp2.dart';

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

class RegisterExp extends StatefulWidget {

  const RegisterExp({super.key});

  @override
  State<RegisterExp> createState() => _RegisterExpState();
}

class _RegisterExpState extends State<RegisterExp> {

  DateTime? dobdt;
  late final TextEditingController txtname;
  late final TextEditingController txtdob;
  late final TextEditingController txtidtype;
  late final TextEditingController txtidnum;
  late final TextEditingController txtgender;
  late final TextEditingController txtnat;
  late final TextEditingController txtemail;
  final formKey = GlobalKey<FormState>();

  final RegisterExpCtrl ctrl = Get.put(RegisterExpCtrl());

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
    ctrl.setRegisterSelf(false);
    load();
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
    super.dispose();
  }

  void load() async {
    ctrl.setUserDetails(await DataManager.instance.getUserDetails());
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
    txtname.text = '${ctrl.user?.firstName} ${ctrl.user?.middleName ?? ''} ${ctrl.user?.lastName ?? ''}'.trim();
    txtdob.text = ctrl.user?.dob ?? '';
    txtemail.text = ctrl.user?.email ?? '';
    if (txtdob.text.isNotEmpty) {
      final Jiffy df = Jiffy.parse(txtdob.text, pattern: 'dd/MM/yyyy');
      final DateTime dx = df.dateTime;
      final String x = df.yMd;
      if (dx.isBefore(dobLastDate) && dx.isAfter(dobFirstDate)) {
        dobdt = dx;
      }

      else if (x == Jiffy.parseFromDateTime(dobLastDate).yMd || x == Jiffy.parseFromDateTime(dobFirstDate).yMd) {
        dobdt = dx;
      }

      else {
        txtdob.text = '';
        showCustomDialog('Error', 'The Date of Birth ${ctrl.user?.dob} does not meet the age requirement', 'Dismiss');
      }
    }
    
    txtgender.text = ctrl.user?.sex ?? 'Male';
    txtnat.text = ctrl.user?.nationality ?? '';
    ctrl.setSelectedGender(ctrl.user?.sex ?? 'Male');
    ctrl.setSelectedNationality(ctrl.user?.nationality ?? '');
    validateForm();
  }

  void resetForm() {
    txtname.text = '';
    txtdob.text = '';
    txtgender.text = '';
    txtnat.text = '';
    txtemail.text = '';
    dobdt = null;
    ctrl.setSelectedGender('');
    ctrl.setSelectedNationality('');
    validateForm();
  }

  DateTime get dobLastDate {
    final dt = DateTime.now();
    return Jiffy.parseFromDateTime(DateTime(dt.year, dt.month, dt.day)).subtract(years: 60).dateTime;
  }

  DateTime get dobFirstDate {
    final dt = DateTime.now();
    return Jiffy.parseFromDateTime(DateTime(dt.year, dt.month, dt.day)).subtract(years: 101).dateTime;
  }

  void onNext() {
    GoldenPearlMembershipForm frm = GoldenPearlMembershipForm(
      name: txtname.text, 
      dob: txtdob.text, 
      idType: ctrl.selectedDocType?.code ?? 'NRIC', 
      idNum: txtidnum.text, 
      gender: txtgender.text, 
      nationality: txtnat.text, 
      email: txtemail.text,
    );
    ctrl.setMembershipForm(frm);
    Get.to(() => const RegisterExp2());
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: kPrimaryColor),
                  ),
                  child: Center(
                    child: Text(
                      '1',
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              afterLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
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
                    border: Border.all(color: const Color(0xFFDADADA)),
                  ),
                  child: Center(
                    child: Text(
                      '2',
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor2,
                      ),
                    ),
                  ),
                ),
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
                thickness: 1,
              ),
              endChild: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Next of Kin',
                  style: kTextStyle1.copyWith(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
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
                      const SizedBox(height: 16.0),
                      if (AuthManager.instance.isLogin) ...[
                        Row(
                          children: [
                            Obx(() =>
                              Checkbox(shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
                              'Register myself as member',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                      ],

                      Text(
                        "Senior Citizen's Name *",
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
                          validator: ValidationBuilder(requiredMessage: "Senior Citizen's Name is required").required().minLength(1, "Senior Citizen's Name is required").build(),
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
                
                      Text(
                        'Date of Birth',
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
                            DateTime? dob = await showDatePicker(
                              context: context,
                              initialDate: dobdt == null ? dobFirstDate : dobdt!,
                              firstDate: dobFirstDate,
                              lastDate: dobLastDate,
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
                
                      Text(
                        'Email Address',
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
                          validator: ValidationBuilder(optional: true).email('Email is invalid').build(),
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