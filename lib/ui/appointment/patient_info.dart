import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/new_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/patient_info_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/country_data.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/patient_info_data.dart';
import 'package:vesalius_m_flutter/services/common_service.dart';
import 'package:vesalius_m_flutter/services/guest_service.dart';
import 'package:vesalius_m_flutter/ui/appointment/patient_info2.dart';
import 'package:vesalius_m_flutter/ui/appointment/select_marital.dart';
import 'package:vesalius_m_flutter/ui/select_country.dart';
import 'package:vesalius_m_flutter/ui/services/little-explorer/select_gender.dart';
import 'package:vesalius_m_flutter/ui/services/little-explorer/select_nationality.dart';

import 'new_appointment.dart';

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

class PatientInfo extends StatefulWidget {

  final DoctorInfo doctorInfo;

  const PatientInfo({
    super.key,
    required this.doctorInfo,
  });

  @override
  State<PatientInfo> createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {

  DateTime? dobdt;
  late final TextEditingController txtpat;
  late final TextEditingController txtidnum;
  late final TextEditingController txtname;
  late final TextEditingController txtdob;
  late final TextEditingController txtnric;
  late final TextEditingController txtgender;
  late final TextEditingController txtmar;
  late final TextEditingController txtnat;
  late final TextEditingController txtcountry;
  final formKey = GlobalKey<FormState>();

  final PatientInfoCtrl ctrl = Get.put(PatientInfoCtrl());
  final NewAppointmentCtrl newAppointmentCtrl = Get.put(NewAppointmentCtrl());

  @override
  void initState() {
    super.initState();
    txtpat = TextEditingController();
    txtidnum = TextEditingController();
    txtname = TextEditingController();
    txtdob = TextEditingController();
    txtnric = TextEditingController();
    txtgender = TextEditingController();
    txtmar = TextEditingController();
    txtnat = TextEditingController();
    txtcountry = TextEditingController();
    txtpat.text = ctrl.patientType;
    load();
  }

  @override
  void dispose() {
    txtpat.dispose();
    txtidnum.dispose();
    txtname.dispose();
    txtdob.dispose();
    txtnric.dispose();
    txtgender.dispose();
    txtmar.dispose();
    txtnat.dispose();
    txtcountry.dispose();
    super.dispose();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      final ln = await CommonService.getNationalities();
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

      ctrl.setNationalityList(ln);
      ctrl.setCountryList(lx);
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
              'The Identification Number provided does not exist in our hospital records. Please retry.',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Done',
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    ));
  }

  void onNext() async {
    if (ctrl.patientType == 'Returning Patient') {
      try {
        FocusManager.instance.primaryFocus?.unfocus();
        ctrl.setIsLoading(true);
        final o = await GuestModeService.getRetPatient({ 'identificationNumber': txtidnum.text });
        newAppointmentCtrl.setRetPatient(o);
        ctrl.setIsLoading(false);
        Get.to(() => NewAppointment(doctorInfo: widget.doctorInfo));
      }

      on DioException catch (error) {
        ctrl.setIsLoading(false);
        if (error.type == DioExceptionType.badResponse) {
          if (error.response?.statusCode == 400) {
            showError();
            return;
          }
        }

        handleLoadError(error, onNext);
      }

      catch (error) {
        ctrl.setIsLoading(false);
        showCustomDialog('Error', error.toString(), 'Dismiss');
      }
    }

    else {
      final o = PatientForm(
        name: txtname.text,
        dob: txtdob.text,
        idnum: txtnric.text,
        gender: txtgender.text,
        marital: txtmar.text,
        nationality: txtnat.text,
        country: txtcountry.text,
        addr1: '',
        addr2: '',
        city: '',
        postcode: '',
        state: '',
        contact1: '',
        contact2: '',
        email: '',
      );
      ctrl.setPatient(o);
      Get.to(() => PatientInfo2(doctorInfo: widget.doctorInfo));
    }
  }

  List<Widget> buildNewPatient() {
    return [
      Text(
        'Full Name',
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
          validator: ValidationBuilder(requiredMessage: "Full Name is required").required().minLength(1, "Full Name is required").build(),
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
      const SizedBox(height: 8.0),
      Text(
        'As per NRIC/Passport and registered in hospital',
        style: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          color: kTextColor5,
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

      Text(
        'NRIC / Passport / Birth Cert',
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
          validator: ValidationBuilder(requiredMessage: 'NRIC / Passport / Birth Cert is required').required('NRIC / Passport / Birth Cert is required').minLength(1, 'NRIC / Passport / Birth Cert is required').build(),
          controller: txtnric,
          cursorColor: kTextColor1,
          style: const TextStyle(
            fontFamily: kBodyFont,
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: kTextColor1,
          ),
          decoration: kInputDecoration.copyWith(
            hintText: 'e.g. 96xxxx-xx-xxxx',
          ),
        ),
      ),
      const SizedBox(height: 24.0),

      Text(
        'Gender',
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

      Text(
        'Marital Status',
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
            final s = await Get.to<String?>(() => SelectMarital(selected: ctrl.selectedMarital));
            if (s != null) {
              ctrl.setSelectedMarital(s);
              txtmar.text = s;
              // validate(s);
            }
          },
          autovalidateMode: AutovalidateMode.always,
          // onChanged: validate,
          // validator: ValidationBuilder(requiredMessage: 'Marital Status is required').required().minLength(1, 'Marital Status is required').build(),
          controller: txtmar,
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
        'Nationality',
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
            final s = await Get.to<String?>(() => SelectNationality(selected: ctrl.selectedNationality, list: ctrl.nationalityList));
            if (s != null) {
              ctrl.setSelectedNationality(s);
              txtnat.text = s;
              validate(s);
            }
          },
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
        'Country',
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
            final c = await Get.to<Country?>(() => SelectCountry(selected: ctrl.selectedCountry, list: ctrl.countryList));
            if (c != null) {
              ctrl.setSelectedCountry(c);
              txtcountry.text = c.countryName;
              // validate(c.countryName);
            }
          },
          autovalidateMode: AutovalidateMode.always,
          // onChanged: validate,
          // validator: ValidationBuilder(requiredMessage: 'Country is required').required().minLength(1, 'Country is required').build(),
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
    ];
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
                  child: Obx(() =>
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24.0),
                        Text(
                          'Patient Type',
                          style: kTextStyle1.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: kTextColor5,
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
                              String s = ctrl.patientType;
                              String v = s == 'New Patient' ? 'Returning Patient' : 'New Patient';
                              ctrl.setPatientType(v);
                              txtpat.text = v;
                            },
                            autovalidateMode: AutovalidateMode.always,
                            //onChanged: validate,
                            //validator: ValidationBuilder(requiredMessage: 'Visit With Companion is required').required().minLength(1, 'Visit With Companion is required').build(),
                            controller: txtpat,
                            readOnly: true,
                            showCursor: false,
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
                    
                        if (ctrl.patientType == 'Returning Patient') ...[
                          Text(
                            'Identification Number *',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor5,
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
                        ] else ...[
                          ...buildNewPatient(),
                        ],
                      ],
                    ),
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
      title: 'Patient Information',
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