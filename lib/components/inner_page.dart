import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_m_flutter/constants.dart';

import 'back_btn.dart';

class InnerPage extends StatelessWidget {

  final String title;
  final Widget? body;
  final Color? backgroundColor;
  final List<Widget>? actions;

  const InnerPage({
    super.key,
    required this.title,
    this.body,
    this.backgroundColor,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: kBgColor1,
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
        elevation: 2.0,
        actions: actions,
      ),
      backgroundColor: backgroundColor ?? kBgColor1,
      body: body,
    );
  }
}