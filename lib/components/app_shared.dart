import 'package:flutter/cupertino.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../constants.dart';

class AppScalingText extends StatelessWidget {

  final String text;

  const AppScalingText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScalingText(
      text,
      style: kProgressTextStyle,
    );
  }
}

class AppActivityIndicator extends StatelessWidget {

  const AppActivityIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoActivityIndicator();
  }
}