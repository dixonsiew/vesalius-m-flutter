import 'dart:convert';

import 'package:flutter/material.dart';

class DoctorImage extends StatelessWidget {

  final String? img;

  const DoctorImage({
    super.key,
    this.img,
  });

  @override
  Widget build(BuildContext context) {
    String? image = img;
    Image im = Image.asset('images/imgs/no_image.png', fit: BoxFit.cover);
    if (image != null && image != '') {
      int i = image.indexOf('base64,');
      String data = image;
      if (i < 0) {
        data = image.trim();
      }

      else {
        data = image.substring(i + 7).trim();
      }
      im = Image.memory(
        base64Decode(data),
        fit: BoxFit.cover,
      );
    }

    return im;
  }
}