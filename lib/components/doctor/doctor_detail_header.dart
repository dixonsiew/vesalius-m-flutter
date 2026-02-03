import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';

class DetailHeader extends StatelessWidget {
  
  final String title;

  const DetailHeader({
    super.key, 
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      width: double.infinity,
      color: kSearchDoctorBgColor,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          fontFamily: kBodyFont,
          color: Colors.white,
        ),
      ),
    );
  }
}