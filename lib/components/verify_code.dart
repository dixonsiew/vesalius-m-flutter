import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/constants.dart';

const kTextStyle = TextStyle(
  fontSize: 32.0,
  fontWeight: FontWeight.bold,
  color: kPrimaryColor,
);

class VerifyCode extends StatefulWidget {

  final String code;
  final void Function(String s) onAllDigitsEntered;

  const VerifyCode({
    super.key,
    this.code = '',
    required this.onAllDigitsEntered,
  });

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {

  late FocusNode focusNode1;
  late FocusNode focusNode2;
  late FocusNode focusNode3;
  late FocusNode focusNode4;
  late FocusNode focusNode5;
  late FocusNode focusNode6;
  final formKey = GlobalKey<FormState>();
  late TextEditingController txt1 = TextEditingController();
  late TextEditingController txt2 = TextEditingController();
  late TextEditingController txt3 = TextEditingController();
  late TextEditingController txt4 = TextEditingController();
  late TextEditingController txt5 = TextEditingController();
  late TextEditingController txt6 = TextEditingController();

  final VerifyCodeCtrl ctrl = Get.put(VerifyCodeCtrl());

  @override
  void initState() {
    super.initState();
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();
    focusNode4 = FocusNode();
    focusNode5 = FocusNode();
    focusNode6 = FocusNode();
    txt1 = TextEditingController();
    txt2 = TextEditingController();
    txt3 = TextEditingController();
    txt4 = TextEditingController();
    txt5 = TextEditingController();
    txt6 = TextEditingController();
    load();
  }

  @override
  void dispose() {
    txt1.dispose();
    txt2.dispose();
    txt3.dispose();
    txt4.dispose();
    txt5.dispose();
    txt6.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    focusNode5.dispose();
    focusNode6.dispose();
    super.dispose();
  }

  void load() async {
    if (widget.code.isNotEmpty) {
      txt1.text = widget.code[0];
      txt2.text = widget.code[1];
      txt3.text = widget.code[2];
      txt4.text = widget.code[3];
      txt5.text = widget.code[4];
      txt6.text = widget.code[5];
      ctrl.setDigit(0, widget.code[0]);
      ctrl.setDigit(1, widget.code[1]);
      ctrl.setDigit(2, widget.code[2]);
      ctrl.setDigit(3, widget.code[3]);
      ctrl.setDigit(4, widget.code[4]);
      ctrl.setDigit(5, widget.code[5]);
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Row(
          children: [
            Flexible(
              child: Obx(() =>
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: (s) {
                    validate(s);
                    ctrl.setDigit(0, s);
                    if (s.isNotEmpty) {
                      focusNode2.requestFocus();
                    }
    
                    if (ctrl.isAllDigitsEntered) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }

                    widget.onAllDigitsEntered.call(ctrl.digits.join());
                  },
                  validator: ValidationBuilder(requiredMessage: '').required('').build(),
                  controller: txt1,
                  focusNode: focusNode1,
                  cursorColor: kPrimaryColor,
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  style: kTextStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.only(left: 4.0, right: 0.0, top: 6.0, bottom: 2.0),
                    counterStyle: const TextStyle(color: Colors.transparent),
                    errorStyle: const TextStyle(color: Colors.transparent),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ctrl.digits[0].isEmpty ? const Color(0xFFDADADA) : kPrimaryColor,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFDADADA),
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24.0),
            Flexible(
              child: Obx(() =>
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: (s) {
                    validate(s);
                    ctrl.setDigit(1, s);
                    if (s.isNotEmpty) {
                      focusNode3.requestFocus();
                    }
    
                    if (ctrl.isAllDigitsEntered) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }

                    widget.onAllDigitsEntered.call(ctrl.digits.join());
                  },
                  validator: ValidationBuilder(requiredMessage: '').required('').build(),
                  controller: txt2,
                  focusNode: focusNode2,
                  cursorColor: kPrimaryColor,
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.next,
                  style: kTextStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.only(left: 4.0, right: 0.0, top: 6.0, bottom: 2.0),
                    counterStyle: const TextStyle(color: Colors.transparent),
                    errorStyle: const TextStyle(color: Colors.transparent),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ctrl.digits[1].isEmpty ? const Color(0xFFDADADA) : kPrimaryColor,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFDADADA),
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24.0),
            Flexible(
              child: Obx(() =>
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: (s) {
                    validate(s);
                    ctrl.setDigit(2, s);
                    if (s.isNotEmpty) {
                      focusNode4.requestFocus();
                    }
    
                    if (ctrl.isAllDigitsEntered) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }

                    widget.onAllDigitsEntered.call(ctrl.digits.join());
                  },
                  validator: ValidationBuilder(requiredMessage: '').required('').build(),
                  controller: txt3,
                  focusNode: focusNode3,
                  cursorColor: kPrimaryColor,
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.next,
                  style: kTextStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.only(left: 4.0, right: 0.0, top: 6.0, bottom: 2.0),
                    counterStyle: const TextStyle(color: Colors.transparent),
                    errorStyle: const TextStyle(color: Colors.transparent),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ctrl.digits[2].isEmpty ? const Color(0xFFDADADA) : kPrimaryColor,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFDADADA),
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24.0),
            Flexible(
              child: Obx(() =>
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: (s) {
                    validate(s);
                    ctrl.setDigit(3, s);
                    if (s.isNotEmpty) {
                      focusNode5.requestFocus();
                    }
    
                    if (ctrl.isAllDigitsEntered) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }

                    widget.onAllDigitsEntered.call(ctrl.digits.join());
                  },
                  validator: ValidationBuilder(requiredMessage: '').required('').build(),
                  controller: txt4,
                  focusNode: focusNode4,
                  cursorColor: kPrimaryColor,
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.next,
                  style: kTextStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.only(left: 4.0, right: 0.0, top: 6.0, bottom: 2.0),
                    counterStyle: const TextStyle(color: Colors.transparent),
                    errorStyle: const TextStyle(color: Colors.transparent),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ctrl.digits[3].isEmpty ? const Color(0xFFDADADA) : kPrimaryColor,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFDADADA),
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24.0),
            Flexible(
              child: Obx(() =>
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: (s) {
                    validate(s);
                    ctrl.setDigit(4, s);
                    if (s.isNotEmpty) {
                      focusNode6.requestFocus();
                    }
    
                    if (ctrl.isAllDigitsEntered) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }

                    widget.onAllDigitsEntered.call(ctrl.digits.join());
                  },
                  validator: ValidationBuilder(requiredMessage: '').required('').build(),
                  controller: txt5,
                  focusNode: focusNode5,
                  cursorColor: kPrimaryColor,
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.next,
                  style: kTextStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.only(left: 4.0, right: 0.0, top: 6.0, bottom: 2.0),
                    counterStyle: const TextStyle(color: Colors.transparent),
                    errorStyle: const TextStyle(color: Colors.transparent),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ctrl.digits[4].isEmpty ? const Color(0xFFDADADA) : kPrimaryColor,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFDADADA),
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24.0),
            Flexible(
              child: Obx(() =>
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: (s) {
                    validate(s);
                    ctrl.setDigit(5, s);
                    if (s.isNotEmpty) {
                      focusNode6.requestFocus();
                    }
    
                    if (ctrl.isAllDigitsEntered) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }

                    widget.onAllDigitsEntered.call(ctrl.digits.join());
                  },
                  validator: ValidationBuilder(requiredMessage: '').required('').build(),
                  controller: txt6,
                  focusNode: focusNode6,
                  cursorColor: kPrimaryColor,
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.done,
                  style: kTextStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.only(left: 4.0, right: 0.0, top: 6.0, bottom: 2.0),
                    counterStyle: const TextStyle(color: Colors.transparent),
                    errorStyle: const TextStyle(color: Colors.transparent),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ctrl.digits[5].isEmpty ? const Color(0xFFDADADA) : kPrimaryColor,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFDADADA),
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerifyCodeCtrl extends GetxController {

  final _isValid = false.obs;
  final _digits = ['', '', '', '', '', ''].obs;

  void setIsValid(bool b) {
    _isValid.value = b;
  }

  void setDigit(int i, String s) {
    _digits[i] = s;
  }

  bool get isAllDigitsEntered {
    return digits[0].isNotEmpty && digits[1].isNotEmpty && digits[2].isNotEmpty && digits[3].isNotEmpty && digits[4].isNotEmpty && digits[5].isNotEmpty;
  }

  bool get isValid => _isValid.value;
  List<String> get digits => [..._digits];
}