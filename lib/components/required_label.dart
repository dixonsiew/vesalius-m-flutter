import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';

class ReqLbl extends StatelessWidget {

  final String s;

  const ReqLbl({super.key, required this.s});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: s,
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
          ),
          TextSpan(
            text: ' *',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: kTextColor3,
            ),
          ),
        ],
      ),
    );
  }
}