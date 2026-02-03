import 'package:flutter/cupertino.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../constants.dart';

class AppScalingText extends StatelessWidget {

  final String text;

  AppScalingText(this.text);

  @override
  Widget build(BuildContext context) {
    return ScalingText(
      text,
      style: kProgressTextStyle,
    );
  }
}

class AppActivityIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator();
  }
}