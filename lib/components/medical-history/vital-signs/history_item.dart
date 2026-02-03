import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';

class HistoryItem extends StatelessWidget {

  final String recordedDate;
  final String val;

  const HistoryItem({
    super.key, 
    required this.recordedDate,
    required this.val,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.89, vertical: 19.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            recordedDate,
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: kTextColor2,
            ),
          ),
          Text(
            val,
            style: kTextStyle1.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              color: kTextColor1,
            ),
          ),
        ],
      ),
    );
  }
}