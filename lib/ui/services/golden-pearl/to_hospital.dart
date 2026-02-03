import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';

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


class ToHospital extends StatefulWidget {

  const ToHospital({super.key});

  @override
  State<ToHospital> createState() => _ToHospitalState();
}

class _ToHospitalState extends State<ToHospital> {

  final formKey = GlobalKey<FormState>();

  DateTime? dobdt;

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
    ));
  }

  void onSubmit() {
    showSuccess();
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
                      Text(
                        'Pick Up Location',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                      const SizedBox(height: 10.0),
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
                            hintText: 'e.g.John Smith',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Checkbox(
                            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            activeColor: kPrimaryColor,
                            value: true,
                            onChanged: (value) {
                            },
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'Same as Profile Address',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        "Ride Type",
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: const Color(0xFFC7CCD6)),
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
                          borderRadius: BorderRadius.circular(5.0),
                          child: InkWell(
                            onTap: () {
                
                            },
                            borderRadius: BorderRadius.circular(5.0),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 14.0, top: 10.0, bottom: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Please Select',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        color: kTextColor1,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.expand_more,
                                    color: kTextColor1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 162.0,
                            child: Text(
                              'Pick Up Date',
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
                      const SizedBox(height: 6.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 162.0,
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
                                  // txtdob.text = '$dobDay/$dobMonth/${dob.year}';
                                  dobdt = DateTime(dob.year, dob.month, dob.day);
                                }
                              },
                              autovalidateMode: AutovalidateMode.always,
                              // onChanged: validate,
                              // validator: ValidationBuilder(requiredMessage: 'Fullname is required').required().minLength(1, 'Fullname is required').build(),
                              //controller: txtdob,
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
                                //controller: txtstate,
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      /*
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 162.0,
                            child: Text(
                              'Return Pick Up Date',
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
                              'Return Pick Up Time',
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
                            width: 162.0,
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
                                  // txtdob.text = '$dobDay/$dobMonth/${dob.year}';
                                  dobdt = DateTime(dob.year, dob.month, dob.day);
                                }
                              },
                              autovalidateMode: AutovalidateMode.always,
                              // onChanged: validate,
                              // validator: ValidationBuilder(requiredMessage: 'Fullname is required').required().minLength(1, 'Fullname is required').build(),
                              //controller: txtdob,
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
                                //controller: txtstate,
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
                          ),
                        ],
                      ),
                      */
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
            child: AppElevatedButton(
              text: 'Submit Request',
              onPressed: onSubmit
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: buildForm(),
    );
  }
}