import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';

class TopRed extends StatelessWidget {

  const TopRed({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 220.0,
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: Border(
              top: BorderSide(
                color: kSecondaryBgColor,
                style: BorderStyle.solid,
                width: 105.0,
              ),
              right: BorderSide(
                color: Colors.transparent,
                style: BorderStyle.solid,
                width: 230.0,
              ),
              bottom: BorderSide(
                color: Colors.transparent,
                style: BorderStyle.solid,
                width: 0,
              ),
              left: BorderSide(
                color: Colors.transparent,
                style: BorderStyle.solid,
                width: 0,
              ),
            ),
          ),
        ),
        Container(
          width: 200.0,
          decoration: const ShapeDecoration(
            color: Colors.transparent,
            shape: Border(
              top: BorderSide(
                color: kPrimaryBgColor,
                style: BorderStyle.solid,
                width: 90.0,
              ),
              right: BorderSide(
                color: Colors.transparent,
                style: BorderStyle.solid,
                width: 200.0,
              ),
              bottom: BorderSide(
                color: Colors.transparent,
                style: BorderStyle.solid,
                width: 0,
              ),
              left: BorderSide(
                color: Colors.transparent,
                style: BorderStyle.solid,
                width: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}