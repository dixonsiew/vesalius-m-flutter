import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';

class DetailHeader extends StatelessWidget {
  
  final String title;

  DetailHeader({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(bottom: 10.0),
      width: double.infinity,
      color: kHomeBgColor,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: kBodyFont,
          color: Colors.white,
        ),
      ),
    );
  }
}