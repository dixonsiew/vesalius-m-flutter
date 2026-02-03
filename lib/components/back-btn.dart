import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';

class BackBtn extends StatelessWidget {

  final Color color;
  final FontWeight? fontWeight;
  final void Function()? onBack;

  BackBtn({
    required this.color,
    this.fontWeight,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onBack == null) {
          Navigator.pop(context);
        }

        else {
          onBack!();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 10.0),
          Icon(
            Icons.arrow_back_ios,
            color: color,
          ),
          Text(
            'Back',
            style: TextStyle(
              color: color,
              fontSize: 18.0,
              fontFamily: kTitleFont,
              fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
            ),
          ),
        ],   
      ),
    );
  }
}