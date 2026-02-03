import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_m_flutter/constants.dart';

import 'back_btn.dart';

class InnerPage extends StatelessWidget {

  final String title;
  final Widget? body;
  final Color? backgroundColor;
  final Color? appBarBackgroundColor;
  final List<Widget>? actions;
  final double? elevation;
  final bool resizeToAvoidBottomInset;

  const InnerPage({
    super.key,
    required this.title,
    this.body,
    this.backgroundColor,
    this.appBarBackgroundColor,
    this.actions,
    this.elevation,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: appBarBackgroundColor ?? kBgColor1),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: appBarBackgroundColor ?? kBgColor1,
        leading: const BackBtn(color: kTextColor1),
        centerTitle: true,
        title: Text(
          title,
          style: kTextStyle1.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: kTextColor1,
          ),
        ),
        elevation: elevation ?? 2.0,
        actions: actions,
      ),
      backgroundColor: backgroundColor ?? kBgColor1,
      body: body,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}