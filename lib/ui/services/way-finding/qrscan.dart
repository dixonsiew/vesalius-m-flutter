import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner_with_effect/qr_scanner_with_effect.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';

class QrScan extends StatefulWidget {

  const QrScan({super.key});

  @override
  State<QrScan> createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool isComplete = false;

  void onQrScannerViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      controller.pauseCamera();

      await Future<void>.delayed(const Duration(milliseconds: 300));
      String r = result?.code ?? '';
      if (r.isNotEmpty) {
        manageQRData(r);
      }

      else {
        controller.resumeCamera();
      }
    });
  }

  void manageQRData(String myQrCode) async {
    try {
      final x = base64Decode(myQrCode);
      String k = utf8.decode(x);
      if (k.contains('IH-WAYFINDING-QR')) {
        controller?.stopCamera();
        setState(() {
          isComplete = true;
        });
        Get.back(result: myQrCode);
        return;
      }
    }

    catch (_) {

    }

    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    controller?.stopCamera();
    super.dispose();
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: '',
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return QrScannerWithEffect(
            isScanComplete: isComplete,
            qrKey: qrKey,
            onQrScannerViewCreated: onQrScannerViewCreated,
            qrOverlayBorderColor: Colors.greenAccent,
            cutOutSize: (MediaQuery.of(context).size.width < 300 || MediaQuery.of(context).size.height < 400) ? 250.0 : 300.0,
            onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
            effectGradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1],
              colors: [
                Colors.greenAccent,
                Colors.greenAccent,
              ],
            ),
          );
        },
      ),
    );
  }
}