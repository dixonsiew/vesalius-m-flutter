import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackBtn extends StatelessWidget {

  final Color color;
  final void Function()? onBack;

  const BackBtn({
    super.key, 
    required this.color,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        onPressed: () {
          if (onBack == null) {
            Get.back();
          }
    
          else {
            onBack!.call();
          }
        },
        icon: Icon(
          Icons.chevron_left,
          color: color,
          size: 32.0,
        ),
      ),
    );
  }
}