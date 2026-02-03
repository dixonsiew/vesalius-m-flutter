import 'package:flutter/material.dart';

class BackBtn extends StatelessWidget {

  final Color color;
  final FontWeight fontWeight;

  BackBtn({
    @required this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
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
              fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
            ),
          ),
        ],   
      ),
    );
  }
}