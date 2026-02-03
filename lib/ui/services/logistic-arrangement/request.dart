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
import 'package:vesalius_m_flutter/controllers/services/logistic-arrangement/request_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctype_data.dart';
import 'package:vesalius_m_flutter/models/family_data.dart';
import 'package:vesalius_m_flutter/models/logistic_arrangement_data.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/services/common_service.dart';
import 'package:vesalius_m_flutter/ui/services/little-explorer/select_doctype.dart';
import 'package:vesalius_m_flutter/ui/services/little-explorer/select_nationality.dart';

import 'request2.dart';
import 'request3.dart';
import 'select_patient.dart';
import 'select_doctor.dart';

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
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: const BorderSide(color: kColor10),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: const BorderSide(color: kColor10),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: const BorderSide(color: kTextColor3),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: const BorderSide(color: kTextColor3),
  ),
);

class Request extends StatefulWidget {

  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {

  DateTime? dobdt;
  late final TextEditingController txtname;
  late final TextEditingController txtdob;
  late final TextEditingController txtidtype;
  late final TextEditingController txtidnum;
  late final TextEditingController txtnat;
  late final TextEditingController txtemail;
  late final TextEditingController txtdoc;
  late final TextEditingController txtcom;
  final formKey = GlobalKey<FormState>();

  final RequestCtrl ctrl = Get.put(RequestCtrl());
  final SelectPatientCtrl selectPatientCtrl = Get.put(SelectPatientCtrl());
  final SelectDoctorCtrl selectDoctorCtrl = Get.put(SelectDoctorCtrl());

  @override
  void initState() {
    super.initState();
    txtname = TextEditingController();
    txtdob = TextEditingController();
    txtidtype = TextEditingController();
    txtidnum = TextEditingController();
    txtnat = TextEditingController();
    txtemail = TextEditingController();
    txtdoc = TextEditingController();
    txtcom = TextEditingController(text: ctrl.visitWithCompanion);
    ctrl.setSelf(true);
    load();
  }

  @override
  void dispose() {
    txtname.dispose();
    txtdob.dispose();
    txtidtype.dispose();
    txtidnum.dispose();
    txtnat.dispose();
    txtemail.dispose();
    txtdoc.dispose();
    txtcom.dispose();
    super.dispose();
  }

  void load() async {
    ctrl.setUserDetails(await DataManager.instance.getUserDetails());
    ctrl.setPatientDetails(await DataManager.instance.getPatientDetails());
    try {
      ctrl.setIsLoading(true);
      final ln = await CommonService.getNationalities();
      ctrl.setNationalityList(ln);
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
    
    setForm();
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
    validate(txtidnum.text);
    validate(txtnat.text);
    validate(txtemail.text);
  }

  void setForm() {
    txtname.text = '${ctrl.user?.firstName} ${ctrl.user?.middleName ?? ''} ${ctrl.user?.lastName ?? ''}'.trim();
    txtdob.text = ctrl.user?.dob ?? '';
    txtidnum.text = patientNRIC;
    txtemail.text = ctrl.user?.email ?? '';
    txtnat.text = ctrl.user?.nationality ?? '';
    ctrl.setSelectedNationality(ctrl.user?.nationality ?? '');
    validateForm();
  }

  void resetForm() {
    txtname.text = '';
    txtdob.text = '';
    txtidnum.text = '';
    txtnat.text = '';
    txtemail.text = '';
    dobdt = null;
    ctrl.setSelectedPatient(null);
    ctrl.setSelectedNationality('');
    validateForm();
  }

  void setFamily(Family o) {
    txtdob.text = o.dob ?? '';
    txtidnum.text = o.nricPassport ?? '';
    txtemail.text = o.email ?? '';
    txtnat.text = o.nationality ?? '';
    ctrl.setSelectedNationality(o.nationality ?? '');
    validateForm();
  }

  String get patientNRIC {
    String s = '';
    if (ctrl.patient != null) {
      Document? doc = ctrl.patient!.documents.firstWhereOrNull((o) => o.code == 'ID');
      if (doc != null) {
        s = doc.value ?? '';
      }
    }

    return s;
  }

  void onNext() {
    LogisticReqForm frm = LogisticReqForm(
      name: txtname.text,
      dob: txtdob.text,
      idType: txtidtype.text,
      idNum: txtidnum.text,
      nationality: txtnat.text,
      email: txtemail.text,
      doc: txtdoc.text,
      visitWithCompanion: txtcom.text,
    );
    ctrl.setReqForm(frm);
    if (ctrl.visitWithCompanion == 'Yes') {
      Get.to(() => const Request2());
    }
    
    else {
      Get.to(() => const Request3());
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
                color: kColor3,
                thickness: 1,
              ),
              endChild: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'General Info',
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
                    border: Border.all(color: kColor3),
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
                color: kColor3,
                thickness: 1,
              ),
              endChild: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Flight Details',
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
                      Row(
                        children: [
                          Obx(() =>
                            Checkbox(
                              shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                              activeColor: kPrimaryColor,
                              value: ctrl.isSelf,
                              onChanged: (value) {
                                ctrl.setSelf(value ?? false);
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
                            'Request for myself',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      const ReqLbl(s: 'Patient Name'),
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
                        child: Obx(() =>
                          TextFormField(
                            onTap: ctrl.isSelf ? null : () async {
                              final s = await Get.to<Family?>(() => SelectPatient(selected: ctrl.selectedPatient));
                              if (s != null) {
                                ctrl.setSelectedPatient(s);
                                txtname.text = selectPatientCtrl.dataName;
                                validate(txtname.text);
                                setFamily(s);
                              }
                            },
                            autovalidateMode: AutovalidateMode.always,
                            onChanged: validate,
                            validator: ValidationBuilder(requiredMessage: 'Patient Name is required').required().minLength(1, 'Patient Name is required').build(),
                            controller: txtname,
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
                      ),
                      /* Container(
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
                          validator: ValidationBuilder(requiredMessage: 'Patient Name is required').required().minLength(1, 'Patient Name Name is required').build(),
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
                      ), */
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

                      const ReqLbl(s: 'Primary Doctor to visit'),
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
                            final s = await Get.to<String?>(() => SelectDoctor(selected: ctrl.selectedDoctor));
                            if (s != null) {
                              ctrl.setSelectedDoctor(s);
                              txtdoc.text = selectDoctorCtrl.dataName;
                              validate(s);
                            }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: 'Primary Doctor to visit is required').required().minLength(1, 'Primary Doctor to visit is required').build(),
                          controller: txtdoc,
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

                      const ReqLbl(s: 'Visit With Companion'),
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
                            String s = ctrl.visitWithCompanion;
                            s = s == 'No' ? 'Yes' : 'No';
                            ctrl.setVisitWithCompanion(s);
                            txtcom.text = s;
                            validate(s);
                            // final s = await Get.to<String?>(() => SelectNationality(selected: ctrl.selectedNationality));
                            // if (s != null) {
                            //   ctrl.setSelectedNationality(s);
                            //   txtnat.text = s;
                            //   validate(s);
                            // }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          //onChanged: validate,
                          //validator: ValidationBuilder(requiredMessage: 'Visit With Companion is required').required().minLength(1, 'Visit With Companion is required').build(),
                          controller: txtcom,
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
      title: 'New Request',
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