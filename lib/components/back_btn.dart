import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';

class BackBtn extends StatelessWidget {

  final Color color;
  final FontWeight? fontWeight;

  const BackBtn({
    super.key, 
    required this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 10.0),
          Icon(
            Icons.arrow_back_ios,
            color: color,
          ),
          Text(
            'Back',
            style: TextStyle(
              color: color,
              fontSize: 18.0,
              fontFamily: kBodyFont,
              fontWeight: fontWeight ?? FontWeight.normal,
            ),
          ),
        ],   
      ),
    );
  }
}