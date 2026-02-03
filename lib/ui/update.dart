import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';

class Update extends StatelessWidget {

  const Update({super.key});

  void onPopInvokedWithResult(bool didPop, result) async {
    if (didPop) return;
    bool b = await showConfirmDialog('Are you sure you want to exit ?');
    if (b) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
          toolbarHeight: 0.0,
          backgroundColor: kBgColor1,
          elevation: 0.0,
        ),
        backgroundColor: kBgColor1,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 80.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'images/imgs/update.png',
                      width: 127.44,
                      height: 240.0,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 40.0),
                    Text(
                      'Update Available!',
                      style: kTextStyle1.copyWith(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Please update your app to continue.',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF697586),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                    child: AppElevatedButton(
                      text: 'Update Now',
                      onPressed: () {
                        String url = Platform.isAndroid ? kAppUrl : kIOSAppUrl;
                        launchURL(url);
                      },
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}