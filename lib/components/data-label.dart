import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';

class DataLabel extends StatelessWidget {

  final String label;
  final String data;

  DataLabel({
    required this.label,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: kBodyFont,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            data,
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: kBodyFont,
            ),
          ),
        ),
      ],
    );
  }
}