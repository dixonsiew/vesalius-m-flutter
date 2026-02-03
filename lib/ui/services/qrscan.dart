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
          Get.back(result: result.text);
        }
      ),
    );
  }
}