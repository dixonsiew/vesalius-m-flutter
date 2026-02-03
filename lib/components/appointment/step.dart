import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/constants.dart';

class AppStep extends StatelessWidget {
  
  final String n;
  final String s;
  final bool a;

  const AppStep({
    super.key, 
    required this.n,
    required this.s,
    this.a = false,
  });

  static buildStep(int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppStep(n: '1', s: 'Visit Type', a: i >= 1),
        AppStep(n: '2', s: 'Select Date', a: i >= 2),
        AppStep(n: '3', s: 'Select Time', a: i >= 3),
        AppStep(n: '4', s: 'Select Slot', a: i >= 4),
        AppStep(n: '5', s: 'Confirm', a: i > 4),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 15.0),
        Container(
          width: 24.0,
          height: 24.0,
          decoration: BoxDecoration(
            color: a ? kPrimaryColor : Colors.white,
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(
              color: a ? kPrimaryColor : const Color(0xFFADADAD),
            ),
          ),
          child: Center(
            child: Text(
              n,
              style: kTextStyle1.copyWith(
                fontSize: 12.0,
                color: a ? Colors.white : const Color(0xFFADADAD),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          s,
          style: kTextStyle1.copyWith(
            fontSize: 10.0,
            color: a ? kPrimaryColor : const Color(0xFFADADAD),
          ),
        ),
      ],
    );
  }
}