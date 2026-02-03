import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';

class NoRecord extends StatelessWidget {
  
  final String msg;

  const NoRecord({
    super.key, 
    this.msg = 'You do not have any past medical history at the moment.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/imgs/medical-record.png',
            width: 73.61,
            height: 96.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              msg,
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFB1B1B1),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}