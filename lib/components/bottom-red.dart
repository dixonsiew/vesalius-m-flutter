import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';

class BottomRed extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Container(
          width: 220.0,
          decoration: ShapeDecoration(
            color: Colors.transparent,
            shape: Border(
              top: BorderSide(
                color: Colors.transparent,
                style: BorderStyle.solid,
                width: 0,
              ),
            ) +
            Border(
              right: BorderSide(
                color: Colors.transparent,
                style: BorderStyle.solid,
                width: 0,
              ),
            ) +
            Border(
              bottom: BorderSide(
                color: kSecondaryBgColor,
                style: BorderStyle.solid,
                width: 105.0,
              ),
            ) +
            Border(
              left: BorderSide(
                color: Colors.transparent,
                style: BorderStyle.solid,
                width: 230,
              ),
            )
          ),
        ),
        Container(
          width: 200.0,
          decoration: ShapeDecoration(
            color: Colors.transparent,
            shape: Border(
              top: BorderSide(
                color: Colors.transparent,
                style: BorderStyle.solid,
                width: 0,
              ),
            ) +
            Border(
              right: BorderSide(
                color: Colors.transparent,
                style: BorderStyle.solid,
                width: 0,
              ),
            ) +
            Border(
              bottom: BorderSide(
                color: kPrimaryBgColor,
                style: BorderStyle.solid,
                width: 90.0,
              ),
            ) +
            Border(
              left: BorderSide(
                color: Colors.transparent,
                style: BorderStyle.solid,
                width: 200.0,
              ),
            )
          ),
        ),
      ]
    );
  }
}