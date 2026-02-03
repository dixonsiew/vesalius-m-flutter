import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackBtn extends StatelessWidget {

  final Color color;
  final void Function()? onBack;

  const BackBtn({
    Key? key, 
    required this.color,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onBack == null) {
          Get.back();
        }

        else {
          onBack!();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Image.asset(
              'images/icon/back.png',
              width: 24.0,
              height: 12.0,
              fit: BoxFit.cover,
            ),
          ),
        ],   
      ),
    );
  }
}