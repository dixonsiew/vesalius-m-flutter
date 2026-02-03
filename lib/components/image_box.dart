import 'dart:io';

import 'package:flutter/material.dart';

class ImageBox extends StatelessWidget {

  final File imageFile;
  final void Function(Key) onTap;

  const ImageBox({
    super.key,
    required this.imageFile,
    required this.onTap,
  });

  bool get isPdf {
    if (imageFile.path.contains('.pdf')) {
      return true;
    }

    return false;
  }

  ImageProvider get image {
    if (isPdf) {
      return const AssetImage('images/imgs/pdffile.png');
    }

    return FileImage(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88.0,
      height: 88.0,
      child: Stack(
        children: [
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE5E5E5).withValues(alpha: 0.1),
                  offset: const Offset(0, 4.0),
                  blurRadius: 4.0,
                ),
              ],
              image: DecorationImage(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                onTap.call(key!);
              },
              child: Image.asset(
                'images/icon/close1.png',
                width: 16.0,
                height: 16.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}