import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/required_label.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/logistic-arrangement/request2_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/services/logistic-arrangement/request_ctrl.dart';
import 'package:vesalius_m_flutter/models/doctype_data.dart';
import 'package:vesalius_m_flutter/models/logistic_arrangement_data.dart';
import 'package:vesalius_m_flutter/ui/services/little-explorer/select_doctype.dart';
import 'package:vesalius_m_flutter/ui/services/little-explorer/select_relationship.dart';
import 'package:vesalius_m_flutter/ui/services/logistic-arrangement/request3.dart';

import 'request.dart';

class Request2 extends StatefulWidget {
  
  const Request2({super.key});

  @override
  State<Request2> createState() => _Request2State();
}

class _Request2State extends State<Request2> {

  DateTime? dobdt;
  late final TextEditingController txtname;
  late final TextEditingController txtdob;
  late final TextEditingController txtidtype;
  late final TextEditingController txtidnum;
  late final TextEditingController txtrel;
  final formKey = GlobalKey<FormState>();

  final Request2Ctrl ctrl = Get.put(Request2Ctrl());
  final RequestCtrl requestCtrl = Get.put(RequestCtrl());

  @override
  void initState() {
    super.initState();
    txtname = TextEditingController();
    txtdob = TextEditingController();
    txtidtype = TextEditingController();
    txtidnum = TextEditingController();
    txtrel = TextEditingController();
    LogisticReqForm2? frm = requestCtrl.reqForm2;
    if (frm != null) {
      txtname.text = frm.name;
      txtdob.text = frm.dob;
      txtidtype.text = frm.idType;
      txtidnum.text = frm.idNum;
      txtrel.text = frm.relationship;
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
    txtrel.dispose();
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

  void validateForm() {
    validate(txtname.text);
    validate(txtdob.text);
    validate(txtidtype.text);
    validate(txtidnum.text);
    validate(txtrel.text);
  }

  void onNext() {
    LogisticReqForm2 frm = LogisticReqForm2(
      name: txtname.text,
      dob: txtdob.text,
      idType: txtidtype.text,
      idNum: txtidnum.text,
      relationship: txtrel.text,
    );
    requestCtrl.setReqForm2(frm);
    Get.to(() => const Request3());
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
                      const SizedBox(height: 24.0),
                      const ReqLbl(s: 'Companion Name'),
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
                          validator: ValidationBuilder(requiredMessage: 'Companion Name is required').required().minLength(1, 'Companion Name is required').build(),
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

                      const ReqLbl(s: 'Companion DOB'),
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
                          validator: ValidationBuilder(requiredMessage: 'Companion DOB is required').required().minLength(10, 'Companion DOB is required').build(),
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

                      const ReqLbl(s: 'Relationship to Patient'),
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
                          validator: ValidationBuilder(requiredMessage: 'Relationship to Patient is required').required().minLength(1, 'Relationship to Patient is required').build(),
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
        child: buildForm(),
      ),
    );
  }
}