import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';

class QrScan extends StatelessWidget {

  const QrScan({super.key});

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: '',
      body: QRCodeDartScanView(
        scanInvertedQRCode: true,
        typeScan: TypeScan.live,
        onCapture: (Result result) {
          try {
            String s = result.text;
            final x = base64Decode(s);
            String k = utf8.decode(x);
            if (k.contains('IH-WAYFINDING-QR')) {
              Get.back(result: s);
            }
          }

          catch (_) {

          }
        },
      ),
    );
  }
}