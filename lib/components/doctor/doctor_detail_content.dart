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
        crossAxisAlignment: CrossAxisAlignment.start,
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
              style: const TextStyle(
                fontSize: 16.0,
                fontFamily: kBodyFont,
                color: Color(0xFF4B4B4B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}