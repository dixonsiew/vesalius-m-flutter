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
      children: [
        Flexible(
          child: Text(
            label,
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: kTextColor2,
            ),
          ),
        ),
        Expanded(
          child: Text(
            data,
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
          ),
        ),
      ],
    );
  }
}