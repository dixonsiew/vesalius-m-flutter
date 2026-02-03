import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/golden-pearl/transport_arrangement_ctrl.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';

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

class TransportArrangement extends StatefulWidget {

  const TransportArrangement({super.key});

  @override
  State<TransportArrangement> createState() => _TransportArrangementState();
}

class _TransportArrangementState extends State<TransportArrangement> {

  DateTime? pickupdt;
  late final TextEditingController txtdt;
  final formKey = GlobalKey<FormState>();
  final TransportArrangementCtrl ctrl = Get.put(TransportArrangementCtrl());

  @override
  void initState() {
    super.initState();
    txtdt = TextEditingController();
    load();
  }

  @override
  void dispose() {
    txtdt.dispose();
    super.dispose();
  }

  void load() async {
    ctrl.setUserDetails(await DataManager.instance.getUserDetails());
  }

  void setForm() {

  }

  void resetForm() {
    
  }

  void onSelectTime() {
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
                  is24HourMode: false,
                  isForce2Digits: true,
                  normalTextStyle: const TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.7,
                    color: kColor29,
                  ),
                  highlightedTextStyle: const TextStyle(
                    fontSize: 23.0,
                    letterSpacing: 0.7,
                    color: kColor25,
                  ),
                  onTimeChange: (time) {
                    ctrl.setDate(time);
                  },
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

  void showSuccess() {
    Get.dialog(
      AlertDialog(
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
                'Request Submitted Successfully',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Your ride request has been submitted successfully. We will notify you once your ride is booked.',
                style: kTextStyle1.copyWith(
                  fontWeight: FontWeight.w400,
                  color: kTextColor6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              AppElevatedButton(
                text: 'Done',
                onPressed: () {
                  Get.back();
                    //Get.until((route) => Get.currentRoute == MainLayout.routeName);
                },
              ),
            ],
          ),
        ),
      )
    );
  }

  void onSubmit() {
    showSuccess();
  }

  Widget buildContent() {
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24.0),
                      Text(
                        'Pick Up Location',
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
                          // onChanged: validate,
                          // validator: ValidationBuilder(requiredMessage: 'Fullname is required').required().minLength(1, 'Fullname is required').build(),
                          //controller: txtname,
                          maxLines: 5,
                          cursorColor: kTextColor1,
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                          decoration: kInputDecoration.copyWith(
                            hintText: 'e.g.Home',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Checkbox(
                            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            activeColor: kPrimaryColor,
                            value: false,
                            onChanged: (value) {

                            },
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                            'Same as Profile Address',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor1,
                            ),
                          ),)
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        'To',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                          color: kColor12,
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
                          'Island Hospital',
                          style: kTextStyle1.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kColor21,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Pick Up Date',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 19.0),
                          Expanded(
                            child: Text(
                              'Pick Up Time',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                onTap: () async {
                                  DateTime? dob = await showDatePicker(
                                    context: context,
                                    initialDate: pickupdt == null ? DateTime.now() : pickupdt!,
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
                                    txtdt.text = '$dobDay/$dobMonth/${dob.year}';
                                    pickupdt = DateTime(dob.year, dob.month, dob.day);
                                  }
                                },
                                autovalidateMode: AutovalidateMode.always,
                                // onChanged: validate,
                                // validator: ValidationBuilder(requiredMessage: 'Fullname is required').required().minLength(1, 'Fullname is required').build(),
                                controller: txtdt,
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
                                  hintText: 'Select Date',
                                  suffixIcon: const Icon(
                                    Icons.event,
                                    color: kTextColor1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 19.0),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: kColor10),
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: kBgColor2.withValues(alpha: 0.1),
                                    offset: const Offset(0.0, 4.0),
                                    blurRadius: 4.0,
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                child: InkWell(
                                  onTap: onSelectTime,
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                                    child: Obx(() =>
                                      Text(
                                        ctrl.time,
                                        style: kTextStyle1.copyWith(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                          color: kTextColor1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
            AppElevatedButton(
              text: 'Submit Request',
              onPressed: () {
                onSubmit();
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Transport Arrangement',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}