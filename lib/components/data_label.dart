import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';

class DataLabel extends StatelessWidget {

  final String label;
  final String data;

  const DataLabel({
    super.key, 
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
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              fontFamily: kBodyFont,
            ),
          ),
        ),
        Expanded(
          child: Text(
            data,
            style: const TextStyle(
              fontSize: 15.0,
              fontFamily: kBodyFont,
            ),
          ),
        ),
      ],
    );
  }
}