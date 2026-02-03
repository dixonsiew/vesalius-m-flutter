import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

extension StringExtension on String? {

  String? capitalize() {
    if (this == null) {
      return null;
    }

    return "${this![0].toUpperCase()}${this?.substring(1).toLowerCase()}";
  }

  String? titleCase() {
    if (this == null) {
      return null;
    }

    List<String>? a = this?.split(' ');
    List<String> ls = [];
    for (int i = 0; i < a!.length; i++) {
      ls.add(a[i].capitalize!);
    }

    return ls.join(' ');
  }

  String? replaceWhitespacesUsingRegex(String replace) {
    if (this == null) {
      return null;
    }

    // This pattern means "at least one space, or more"
    // \\s : space
    // +   : one or more 
    final pattern = RegExp('\\s+');
    return this!.replaceAll(pattern, replace);
  }
}

void handleError(DioError error, void Function() onYes) async {
  String msg = error.message;
  if (error.type == DioErrorType.connectTimeout) {
    msg = 'Connection Timeout';
  }

  else if (error.type == DioErrorType.receiveTimeout) {
    msg = 'Receive Timeout';
  }

  else if (error.type == DioErrorType.response) {
    msg = 'Error occurred - ${error.response!.statusCode}';
  }

  bool b = await showConfirmDialog00('Error', '$msg. Do you want to retry ?', 'No', 'Yes');
  if (b) {
    onYes();
  }
}

String formatDateTime(String ds) {
  String s = ds;
  DateTime? dt = DateTime.tryParse(ds);

  if (dt != null) {
    DateFormat fmt = DateFormat('dd MMM yyyy');
    s = fmt.format(dt);
  }

  return s;
}

Future<void> showCustomDialog(String title, String subTitle, String btnText) async {
  await Get.dialog(CupertinoAlertDialog(
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 18.0,
        fontFamily: kBodyFont,
      ),
    ),
    content: Text(
      subTitle,
      style: const TextStyle(
        fontSize: 16.0,
        fontFamily: kBodyFont,
        color: Color(0xFF727272),
      ),
    ),
    actions: [
      CupertinoButton(
        child: Text(
          btnText,
          style: const TextStyle(
            color: kMainColor,
            fontSize: 18.0,
            fontFamily: kBodyFont,
            fontWeight: FontWeight.bold,
          ),
        ), 
        onPressed: () => Get.back(),
      ),
    ],
  ));
}

Future<void> showCustomDialogBak(String title, String subTitle, String btnText, BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.only(top: 24.0, bottom: 0),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  subTitle,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFF727272),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 15.0),
              Container(
                width: double.infinity,
                height: 1.0,
                color: const Color(0xFFE0E0E0),
              ),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    btnText,
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  );
}

Future<bool> showConfirmDialog(String text) async {
  return await Get.dialog(AlertDialog(
    contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0, bottom: 35.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    backgroundColor: Colors.white,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Image.asset(
              'images/icon/close.png',
              width: 16.0,
              height: 16.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          text,
          style: kBodyTextStyle.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 38.0),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Get.back(result: false);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: kMainColor,
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 40.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                  side: const BorderSide(
                    color: kMainColor,
                  ),
                ),
                child: Text(
                  'No',
                  style: kBodyTextStyle.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: kMainColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 17.0),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Get.back(result: true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kMainColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 40.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                ),
                child: Text(
                  'Yes',
                  style: kBodyTextStyle.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  )) ?? false;
}

Future<bool> showConfirmDialog00(String title, String subTitle, String btnNoText, String btnYesText) async {
  return await Get.dialog(CupertinoAlertDialog(
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 18.0,
        fontFamily: kBodyFont,
      ),
    ),
    content: Text(
      subTitle,
      style: const TextStyle(
        fontSize: 16.0,
        fontFamily: kBodyFont,
        color: Color(0xFF727272),
      ),
    ),
    actions: [
      CupertinoButton(
        child: Text(
          btnNoText,
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 18.0,
            fontFamily: kBodyFont,
          ),
        ), 
        onPressed: () => Get.back(result: false),
      ),
      CupertinoButton(
        child: Text(
          btnYesText,
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 18.0,
            fontFamily: kBodyFont,
            fontWeight: FontWeight.bold,
          ),
        ), 
        onPressed: () => Get.back(result: true),
      ),
    ],
  )) ?? false;
}

Future<bool> showConfirmDialogBak(String title, String subTitle, String btnNoText, String btnYesText, BuildContext context) async {
  return await showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.only(top: 24.0, bottom: 0),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  subTitle,
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 15.0),
              Container(
                height: 1.0,
                color: const Color(0xFFE0E0E0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        btnNoText,
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontSize: 19.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1.0,
                    height: 50.0,
                    color: const Color(0xFFE0E0E0),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Get.back(result: true);
                      },
                      child: Text(
                        btnYesText,
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  ) ?? false;
}

Future<String?> showConfirmDialogWithInput(String title, String subTitle, String btnNoText, String btnYesText, String hintText) async {
  final inputController = TextEditingController();
  bool validated = false;

  return await Get.dialog(StatefulBuilder(
    builder: (context, setState) => CupertinoAlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          fontFamily: kBodyFont,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            subTitle,
            style: const TextStyle(
              fontSize: 16.0,
              fontFamily: kBodyFont,
              color: Color(0xFF727272),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: inputController.text == '' && validated ? 5.0 : 25.0),

          inputController.text == '' && validated ? 
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: Text(
              '$hintText is required!',
              style: const TextStyle(
                fontSize: 14.0,
                fontFamily: kBodyFont,
              ),
            ),
          ) : Container(),

          CupertinoTextField(
            controller: inputController,
            cursorColor: const Color(0xFF999494),
            placeholder: 'Reason',
          ),
        ],
      ),
      actions: [
        CupertinoButton(
          child: Text(
            btnNoText,
            style: const TextStyle(
              color: kPrimaryColor,
              fontSize: 18.0,
              fontFamily: kBodyFont,
            ),
          ), 
          onPressed: () => Get.back(),
        ),
        CupertinoButton(
          child: Text(
            btnYesText,
            style: const TextStyle(
              color: kPrimaryColor,
              fontSize: 18.0,
              fontFamily: kBodyFont,
              fontWeight: FontWeight.bold,
            ),
          ), 
          onPressed: () {
            setState(() {
              validated = true;
            });
            if (inputController.text != '') {
              Get.back(result: inputController.text);
            }
          },
        ),
      ],
    ),
  ));
}

Future<String> showConfirmDialogWithInputBak(String title, String subTitle, String btnNoText, String btnYesText, String hintText, BuildContext context) async {
  final inputController = TextEditingController();
  bool validated = false;

  return await showDialog(
    context: context, 
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.only(top: 24.0, bottom: 0),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      subTitle,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: inputController.text == '' && validated ? 5.0 : 25.0),

                  inputController.text == '' && validated ? 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: Text(
                      '$hintText is required!',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ) : Container(),

                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: TextField(
                      controller: inputController,
                      cursorColor: const Color(0xFF999494),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                        hintText: hintText,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Color(0xFF999494)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Color(0xFF999494)),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20.0),
                  Container(
                    height: 1.0,
                    color: const Color(0xFFE0E0E0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            btnNoText,
                            style: const TextStyle(
                              color: kPrimaryColor,
                              fontSize: 19.0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1.0,
                        height: 50.0,
                        color: const Color(0xFFE0E0E0),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              validated = true;
                            });
                            if (inputController.text != '') {
                              Get.back(result: inputController.text);
                            }
                          },
                          child: Text(
                            btnYesText,
                            style: const TextStyle(
                              color: kPrimaryColor,
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  );
}