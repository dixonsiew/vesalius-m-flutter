import 'dart:convert';

import 'package:flutter/material.dart';

class KidsClubImage extends StatelessWidget {

  final String? img;
  final double height;
  final BoxFit fit;

  const KidsClubImage({
    super.key,
    this.img,
    required this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    String? image = img;
    Image im = Image.asset('images/imgs/no_image_available.png', fit: BoxFit.cover);
    if (image != null && image != '' && image.contains('asset') == false) {
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
        height: height,
        fit: fit,
      );
    }

    return im;
  }
}

class KidsActivityImage extends StatelessWidget {

  final String? img;
  final double width;
  final double height;
  final BoxFit fit;

  const KidsActivityImage({
    super.key,
    this.img,
    required this.width,
    required this.height,
    this.fit = BoxFit.fitHeight,
  });

  @override
  Widget build(BuildContext context) {
    String? image = img;
    Image im = Image.asset('images/imgs/no_image_available.png', fit: BoxFit.cover);
    if (image != null && image != '' && image.contains('asset') == false) {
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
        width: width,
        height: height,
        fit: fit,
      );
    }

    return im;
  }
}