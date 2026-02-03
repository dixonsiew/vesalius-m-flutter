import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  String titleCase() {
    var a = this.split(' ');
    List<String> ls = [];
    for (int i = 0; i < a.length; i++) {
      ls.add(a[i].capitalize());
    }

    return ls.join(' ');
  }

  String replaceWhitespacesUsingRegex(String replace) {
    if (this == null) {
      return null;
    }

    // This pattern means "at least one space, or more"
    // \\s : space
    // +   : one or more 
    final pattern = RegExp('\\s+');
    return this.replaceAll(pattern, replace);
  }
}

void handleError(BuildContext context, DioError error, void Function() onYes) async {
  String msg = error.message;
  if (error.type == DioErrorType.connectTimeout) {
    msg = 'Connection Timeout';
  }

  else if (error.type == DioErrorType.receiveTimeout) {
    msg = 'Receive Timeout';
  }

  else if (error.type == DioErrorType.response) {
    msg = 'Error occurred - ${error.response.statusCode}';
  }

  bool b = await showConfirmDialog('Error', '$msg. Do you want to retry ?', 'No', 'Yes', context);
  if (b) {
    onYes();
  }
}

String formatDateTime(String ds) {
  String s = ds;
  DateTime dt = DateTime.tryParse(ds);

  if (dt != null) {
    var fmt = DateFormat('dd MMM yyyy');
    s = fmt.format(dt);
  }

  return s;
}

Future<void> showCustomDialog(String title, String subTitle, String btnText, BuildContext context) async {
  await showCupertinoDialog(
    context: context, 
    builder: (_) => CupertinoAlertDialog(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
      content: Text(
        subTitle,
        style: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF727272),
        ),
      ),
      actions: [
        CupertinoButton(
          child: Text(
            btnText,
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ), 
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

Future<void> showCustomDialogBak(String title, String subTitle, String btnText, BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.only(top: 24.0, bottom: 0),
        content: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFF727272),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 15.0),
              Container(
                width: double.infinity,
                height: 1.0,
                color: Color(0xFFE0E0E0),
              ),
              Container(
                width: double.infinity,
                height: 50.0,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    btnText,
                    style: TextStyle(
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

Future<bool> showConfirmDialog(String title, String subTitle, String btnNoText, String btnYesText, BuildContext context) async {
  return await showCupertinoDialog(
    context: context, 
    builder: (_) => CupertinoAlertDialog(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
      content: Text(
        subTitle,
        style: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF727272),
        ),
      ),
      actions: [
        CupertinoButton(
          child: Text(
            btnNoText,
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 18.0,
            ),
          ), 
          onPressed: () => Navigator.pop(context, false),
        ),
        CupertinoButton(
          child: Text(
            btnYesText,
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ), 
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    ),
  ) ?? false;
}

Future<bool> showConfirmDialogBak(String title, String subTitle, String btnNoText, String btnYesText, BuildContext context) async {
  return await showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.only(top: 24.0, bottom: 0),
        content: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 15.0),
              Container(
                height: 1.0,
                color: Color(0xFFE0E0E0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        btnNoText,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 19.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1.0,
                    height: 50.0,
                    color: Color(0xFFE0E0E0),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        btnYesText,
                        style: TextStyle(
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

Future<String> showConfirmDialogWithInput(String title, String subTitle, String btnNoText, String btnYesText, String hintText, BuildContext context) async {
  final inputController = TextEditingController();
  bool validated = false;

  return await showCupertinoDialog(
    context: context, 
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => CupertinoAlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              subTitle,
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF727272),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: inputController.text == '' && validated ? 5.0 : 25.0),

            inputController.text == '' && validated ? 
            Padding(
              padding: EdgeInsets.only(bottom: 25.0),
              child: Text(
                '$hintText is required!',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ) : Container(),

            CupertinoTextField(
              controller: inputController,
              cursorColor: Color(0xFF999494),
              placeholder: 'Reason',
            ),
          ],
        ),
        actions: [
          CupertinoButton(
            child: Text(
              btnNoText,
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 18.0,
              ),
            ), 
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoButton(
            child: Text(
              btnYesText,
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ), 
            onPressed: () {
              setState(() {
                validated = true;
              });
              if (inputController.text != '') {
                Navigator.pop(context, inputController.text);
              }
            },
          ),
        ],
      ),
    ),
  );
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.only(top: 24.0, bottom: 0),
            content: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      subTitle,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: inputController.text == '' && validated ? 5.0 : 25.0),

                  inputController.text == '' && validated ? 
                  Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: Text(
                      '$hintText is required!',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ) : Container(),

                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: TextField(
                      controller: inputController,
                      cursorColor: Color(0xFF999494),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                        hintText: hintText,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Color(0xFF999494)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Color(0xFF999494)),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.0),
                  Container(
                    height: 1.0,
                    color: Color(0xFFE0E0E0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            btnNoText,
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 19.0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1.0,
                        height: 50.0,
                        color: Color(0xFFE0E0E0),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              validated = true;
                            });
                            if (inputController.text != '') {
                              Navigator.of(context).pop(inputController.text);
                            }
                          },
                          child: Text(
                            btnYesText,
                            style: TextStyle(
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