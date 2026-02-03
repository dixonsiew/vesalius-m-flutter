import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/required_label.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/logistic-arrangement/request3_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/services/logistic-arrangement/request_ctrl.dart';
import 'package:vesalius_m_flutter/models/logistic_arrangement_data.dart';
import 'package:vesalius_m_flutter/ui/services/logistic-arrangement/select_slot.dart';

import 'confirm_detail.dart';
import 'request.dart';

// https://www.figma.com/file/cT4oYFlZM988czBEhXCDdU/IH-Hospital-Mobile-App?node-id=5550%3A13298&mode=dev

class Request3 extends StatefulWidget {

  const Request3({super.key});

  @override
  State<Request3> createState() => _Request3State();
}

class _Request3State extends State<Request3> {

  DateTime? arrdt;
  DateTime? arrtx;
  String pickdt = '';
  String picktx = '';
  late final TextEditingController txtairline;
  late final TextEditingController txtflight;
  late final TextEditingController txtarrivaldt;
  late final TextEditingController txtarrivaltime;
  late final TextEditingController txtpickupslot;
  // late final TextEditingController txtpickupdt;
  // late final TextEditingController txtpickuptime;
  final formKey = GlobalKey<FormState>();

  final Request3Ctrl ctrl = Get.put(Request3Ctrl());
  final RequestCtrl requestCtrl = Get.put(RequestCtrl());

  @override
  void initState() {
    super.initState();
    txtairline = TextEditingController();
    txtflight = TextEditingController();
    txtarrivaldt = TextEditingController();
    txtarrivaltime = TextEditingController();
    txtpickupslot = TextEditingController();
    // txtpickupdt = TextEditingController();
    // txtpickuptime = TextEditingController();
    LogisticReqForm3? frm = requestCtrl.reqForm3;
    if (frm != null) {
      txtairline.text = frm.name;
      txtflight.text = frm.num;
      txtarrivaldt.text = frm.arrDate;
      txtarrivaltime.text = frm.arrTime;
      txtpickupslot.text = '${frm.pickDate} ${frm.pickTime}';
      pickdt = frm.pickDate;
      picktx = frm.pickTime;
      // txtpickupdt.text = frm.pickDate;
      // txtpickuptime.text = frm.pickTime;
      arrdt = Jiffy.parse(frm.arrDate, pattern: 'dd/MM/yyyy').dateTime;
      // pickdt = Jiffy.parse(frm.pickDate, pattern:'dd/MM/yyyy').dateTime;
      arrtx = Jiffy.parse('2023-01-01 ${frm.arrTime}:00.000').dateTime;
      // picktx = Jiffy.parse('2023-01-01 ${frm.pickTime}:00.000').dateTime;
      Future.delayed(const Duration(milliseconds: 100), () => validateForm());
    }
  }

  @override
  void dispose() {
    txtairline.dispose();
    txtflight.dispose();
    txtarrivaldt.dispose();
    txtarrivaltime.dispose();
    txtpickupslot.dispose();
    // txtpickupdt.dispose();
    // txtpickuptime.dispose();
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
    validate(txtairline.text);
    validate(txtflight.text);
    validate(txtarrivaldt.text);
    validate(txtarrivaltime.text);
    validate(txtpickupslot.text);
    // validate(txtpickupdt.text);
    // validate(txtpickuptime.text);
  }

  void onNext() {
    LogisticReqForm3 frm = LogisticReqForm3(
      name: txtairline.text, 
      num: txtflight.text, 
      arrDate: txtarrivaldt.text, 
      arrTime: txtarrivaltime.text, 
      pickDate: ctrl.selectedSlot?.pickUpDate ?? pickdt, 
      pickTime: ctrl.selectedSlot?.pickUpTime ?? picktx,
    );
    requestCtrl.setReqForm3(frm);
    Get.to(() => ConfirmDetail());
  }

  DateTime get arrDateFirst {
    DateTime dt = DateTime.now();
    DateTime dx = DateTime(dt.year, dt.month, dt.day).add(const Duration(days: 2));
    return dx;
  }

  DateTime get arrDateLast {
    //DateTime? dt = pickdt;
    DateTime dx = Jiffy.now().add(years: 1).dateTime;
    // if (dt != null) {
    //   return dt;
    // }

    return dx;
  }

  // DateTime get pickDateFirst {
  //   DateTime? dt = arrdt;
  //   DateTime dx = DateTime.now();
  //   if (dt != null) {
  //     return dt;
  //   }

  //   return dx;
  // }

  // DateTime get pickDateLast {
  //   DateTime? dt = arrdt;
  //   if (dt != null) {
  //     return Jiffy.parseFromDateTime(dt).add(years: 1).dateTime;
  //   }
    
  //   return Jiffy.now().add(years: 1).dateTime;
  // }

  void onSelectTime(void Function(DateTime) onTimeChange, DateTime? tx) {
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Material(
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TimePickerSpinner(
                  time: tx,
                  is24HourMode: true,
                  isForce2Digits: true,
                  normalTextStyle: const TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.7,
                    color: Color(0xFF9A99A2),
                  ),
                  highlightedTextStyle: const TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.7,
                    color: Color(0xFF232326),
                  ),
                  onTimeChange: onTimeChange,
                ),
                ElevatedButton(
                  onPressed:() {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50.0),
                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: Text(
                    'Confirm Time',
                    style: kTextStyle1.copyWith(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                  'Flight Details',
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
                      const ReqLbl(s: 'Airline Name'),
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
                          validator: ValidationBuilder(requiredMessage: 'Airline Name is required').required().minLength(1, 'Airline Name is required').build(),
                          controller: txtairline,
                          cursorColor: kTextColor1,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: kInputDecoration.copyWith(
                            hintText: 'e.g.MAS, AirAsia',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      const ReqLbl(s: 'Flight Number'),
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
                          validator: ValidationBuilder(requiredMessage: 'Flight Number is required').required().minLength(1, 'Flight Number is required').build(),
                          controller: txtflight,
                          cursorColor: kTextColor1,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: kInputDecoration.copyWith(
                            hintText: 'e.g.MH613',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      const ReqLbl(s: 'Flight Arrival Date'),
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
                              initialDate: arrdt == null ? arrDateFirst : arrdt!,
                              firstDate: arrDateFirst,
                              lastDate: arrDateLast,
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
                                    dialogTheme: DialogTheme(
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
                              txtarrivaldt.text = '$dobDay/$dobMonth/${dob.year}';
                              arrdt = DateTime(dob.year, dob.month, dob.day);
                              validate(txtarrivaldt.text);
                            }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: 'Flight Arrival Date is required').required().minLength(10, 'Flight Arrival Date is required').build(),
                          controller: txtarrivaldt,
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

                      const ReqLbl(s: 'Flight Arrival Time'),
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
                          onTap: () {
                            onSelectTime((dt) {
                              arrtx = dt;
                              txtarrivaltime.text = formatDate(dt, [HH, ':', nn]);
                              validate(txtarrivaltime.text);
                            }, arrtx ?? DateTime.now());
                          },
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: 'Flight Arrival Time is required').required().minLength(1, 'Flight Arrival Time is required').build(),
                          controller: txtarrivaltime,
                          readOnly: true,
                          cursorColor: kTextColor1,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: kInputDecoration.copyWith(
                            hintText: 'Select Time',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      const ReqLbl(s: 'Requested Pick Up Slot'),
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
                            final x = await Get.to<LogisticSlot?>(() => SelectSlot(
                              selected: ctrl.selectedSlot,
                              arrDt: txtarrivaldt.text,
                              arrTx: txtarrivaltime.text,
                              withCompanion: requestCtrl.visitWithCompanion == 'Yes' ? true : false,
                            ));
                            if (x != null) {
                              ctrl.setSelectedSlot(x);
                              txtpickupslot.text = '${x.pickUpDate} ${x.pickUpTime}';
                              pickdt = x.pickUpDate;
                              picktx = x.pickUpTime;
                              validate(txtpickupslot.text);
                            }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: 'Requested Pick Up Slot is required').required().minLength(1, 'Requested Pick Up Slot is required').build(),
                          controller: txtpickupslot,
                          readOnly: true,
                          cursorColor: kTextColor1,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: kInputDecoration.copyWith(
                            hintText: 'Select Slot',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      /* Text(
                        'Requested Pick Up Date *',
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
                              initialDate: pickdt == null ? pickDateFirst : pickdt!,
                              firstDate: pickDateFirst,
                              lastDate: pickDateLast,
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
                                    dialogTheme: DialogTheme(
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
                              txtpickupdt.text = '$dobDay/$dobMonth/${dob.year}';
                              pickdt = DateTime(dob.year, dob.month, dob.day);
                              validate(txtpickupdt.text);
                            }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: 'Requested Pick Up Date is required').required().minLength(10, 'Requested Pick Up Date is required').build(),
                          controller: txtpickupdt,
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
                        'Requested Pick Up Time *',
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
                            final x = await Get.to<LogisticSlot?>(() => SelectSlot(
                              selected: ctrl.selectedSlot,
                              arrDt: '${txtarrivaldt.text} ${txtarrivaltime.text}',
                            ));
                            if (x != null) {
                              ctrl.setSelectedSlot(x);
                              txtpickuptime.text = x.pickUpTime;
                              validate(txtpickuptime.text);
                            }
                            /* onSelectTime((dt) {
                              picktx = dt;
                              txtpickuptime.text = formatDate(dt, [HH, ':', nn]);
                              validate(txtpickuptime.text);
                            }, picktx ?? DateTime.now()); */
                          },
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: validate,
                          validator: ValidationBuilder(requiredMessage: 'Requested Pick Up Time is required').required().minLength(1, 'Requested Pick Up Time is required').build(),
                          controller: txtpickuptime,
                          readOnly: true,
                          cursorColor: kTextColor1,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: kInputDecoration.copyWith(
                            hintText: 'Select Time',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0), */
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