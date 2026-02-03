import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';

class NoRecord extends StatelessWidget {
  
  final String msg;

  const NoRecord({
    Key? key, 
    this.msg = 'You do not have any past medical history at the moment.',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/imgs/medical-record.png',
            width: 96.0,
            height: 96.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              msg,
              style: kBodyTextStyle.copyWith(
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