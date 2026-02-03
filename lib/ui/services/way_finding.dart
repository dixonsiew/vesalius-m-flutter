import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/ui/services/qrscan.dart';

class WayFinding extends StatefulWidget {

  const WayFinding({super.key});

  @override
  State<WayFinding> createState() => _WayFindingState();
}

class _WayFindingState extends State<WayFinding> {

  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();

  late final WayFindingCtrl ctrl = Get.put(WayFindingCtrl());

  @override
  void initState() {
    super.initState();
    ctrl.setIsLoading(true);
  }

  Widget buildContent() {
    return InAppWebView(
      key: webViewKey,
      initialUrlRequest: URLRequest(url: WebUri(kServerNavUrl)),
      initialUserScripts: UnmodifiableListView<UserScript>([]),
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
      onLoadStop: (controller, url) async {
        ctrl.setIsLoading(false);
      },
      onReceivedError: (controller, req, error) {
        ctrl.setIsLoading(false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool b, result) async {
        if (b) return;
        if (await webViewController?.canGoBack() ?? false) {
          webViewController?.goBack();
        }

        else {
          Get.back();
        }
      },
      child: InnerPage(
        title: 'Way Finding',
        body: SafeArea(
          child: Stack(
            children: [
              buildContent(),
              Obx(() => ctrl.isLoading ? const Center(child: AppActivityIndicator()) : const Stack()),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final res = await Get.to<String?>(() => const QrScan());
              if (res != null) {
                if (res.contains(kServerNavUrl)) {
                  webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(res)));
                }

                else {
                  showCustomDialog('Error', 'Invalid QR Code', 'Dismiss');
                }
              }
            },
            icon: const Icon(
              Icons.qr_code,
            ),
            color: kPrimaryColor,
            disabledColor: kColor1,
          ),
          Obx(() =>
            IconButton(
              onPressed: ctrl.isLoading ? null : () {
                if (ctrl.isLoading == false) {
                  ctrl.setIsLoading(true);
                  webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(kServerNavUrl)));
                }
              },
              icon: const Icon(
                Icons.refresh,
              ),
              color: kPrimaryColor,
              disabledColor: kColor1,
            ),
          ),
        ],
      ),
    );
  }
}

class WayFindingCtrl extends GetxController {

  final _isLoading = false.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  bool get isLoading => _isLoading.value;
}