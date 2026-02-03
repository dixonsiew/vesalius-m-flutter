import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/required_label.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/new_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/patient_info2_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/patient_info_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/country_data.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/patient_info_data.dart';
import 'package:vesalius_m_flutter/services/common_service.dart';
import 'package:vesalius_m_flutter/services/guest_service.dart';
import 'package:vesalius_m_flutter/ui/select_tel.dart';

import 'new_appointment.dart';
import 'patient_info.dart';

class PatientInfo2 extends StatefulWidget {

  final DoctorInfo doctorInfo;

  const PatientInfo2({
    super.key,
    required this.doctorInfo,
  });

  @override
  State<PatientInfo2> createState() => _PatientInfo2State();
}

class _PatientInfo2State extends State<PatientInfo2> {

  late final TextEditingController txtaddr1;
  late final TextEditingController txtaddr2;
  late final TextEditingController txtcity;
  late final TextEditingController txtpostcode;
  late final TextEditingController txtstate;
  late final TextEditingController txtcontact1;
  late final TextEditingController txtcontact2;
  late final TextEditingController txtemail;
  final formKey = GlobalKey<FormState>();

  final PatientInfo2Ctrl ctrl = Get.put(PatientInfo2Ctrl());
  final PatientInfoCtrl patientInfoCtrl = Get.put(PatientInfoCtrl());
  final NewAppointmentCtrl newAppointmentCtrl = Get.put(NewAppointmentCtrl());

  @override
  void initState() {
    super.initState();
    txtaddr1 = TextEditingController();
    txtaddr2 = TextEditingController();
    txtcity = TextEditingController();
    txtpostcode = TextEditingController();
    txtstate = TextEditingController();
    txtcontact1 = TextEditingController();
    txtcontact2 = TextEditingController();
    txtemail = TextEditingController();
    PatientForm? frm = patientInfoCtrl.patient;
    if (frm != null) {
      txtaddr1.text = frm.addr1;
      txtaddr2.text = frm.addr2;
      txtcity.text = frm.city;
      txtpostcode.text = frm.postcode;
      txtstate.text = frm.state;
      txtcontact1.text = frm.contact1;
      txtcontact2.text = frm.contact2;
      txtemail.text = frm.email;
    }
  }

  @override
  void dispose() {
    txtaddr1.dispose();
    txtaddr2.dispose();
    txtcity.dispose();
    txtpostcode.dispose();
    txtstate.dispose();
    txtcontact1.dispose();
    txtcontact2.dispose();
    txtemail.dispose();
    super.dispose();
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

  void validate(String s) {
    bool b = formKey.currentState!.validate();

    if (s.isEmpty) {
      ctrl.setIsValid(false);
    }

    else {
      ctrl.setIsValid(b);
    }
  }

  void onNext() async {
    PatientForm? x = patientInfoCtrl.patient!;
    x.addr1 = txtaddr1.text;
    x.addr2 = txtaddr2.text;
    x.city = txtcity.text;
    x.postcode = txtpostcode.text;
    x.state = txtstate.text;
    x.contact1 = txtcontact1.text;
    x.contact2 = txtcontact2.text;
    x.email = txtemail.text;
    patientInfoCtrl.setPatient(x);
    try {
      final o = {
        'fullName': x.name,
        'dob': x.dob,
        'identificationNumber': x.idnum,
        'gender': x.gender,
        'maritalStatus': x.marital,
        'nationality': x.nationality,
        'country': x.country,
        'address1': x.addr1,
        'address2': x.addr2,
        'townCity': x.city,
        'postcode': x.postcode,
        'state': x.state,
        'contactNumber': '${x.contact1}${x.contact2}',
        'email': x.email
      };
      FocusManager.instance.primaryFocus?.unfocus();
      ctrl.setIsLoading(true);
      final patient = await GuestModeService.postNewPatient(o);
      newAppointmentCtrl.setRetPatient(patient);
      ctrl.setIsLoading(false);
      Get.to(() => NewAppointment(doctorInfo: widget.doctorInfo));
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleSubmitError(error, 'Unable to create new patient at the moment. Please check your internet connection or try again later.', null);
    }

    catch (_) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', 'Unable to create new patient at the moment. Please check your internet connection or try again later.', 'Dismiss');
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
                      Text(
                        'Address 1',
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
                      const SizedBox(height: 24.0),

                      Text(
                        'Address 2',
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
                      const SizedBox(height: 24.0),

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
                      const SizedBox(height: 24.0),

                      Text(
                        'Contact Number',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
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
                              onTap: loadTel,
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
                                validator: ValidationBuilder(requiredMessage: 'Contact Number is required').required().minLength(1, 'Contact Number is required').build(),
                                controller: txtcontact2,
                                cursorColor: kTextColor1,
                                keyboardType: TextInputType.number,
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
                          validator: ValidationBuilder(requiredMessage: 'Email Address is required').required().minLength(1, 'Email Address is required').email('Email Address is invalid').build(),
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