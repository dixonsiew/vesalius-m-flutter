import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';

class DetailContent extends StatelessWidget {

  final String text;

  const DetailContent({
    super.key, 
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 5.0),
      child: Row(
        children: [
          Container(
            width: 5.0,
            height: 5.0,
            margin: const EdgeInsets.only(right: 15.0, top: 8.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}