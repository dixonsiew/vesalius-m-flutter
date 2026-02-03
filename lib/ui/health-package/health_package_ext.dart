import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class HealthPackageExt extends StatefulWidget {

  final String link;

  const HealthPackageExt({
    super.key,
    required this.link,
  });

  @override
  State<HealthPackageExt> createState() => _HealthPackageExtState();
}

class _HealthPackageExtState extends State<HealthPackageExt> {

  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  final GlobalKey webViewKey = GlobalKey();

  final HealthPackageExtCtrl ctrl = Get.put(HealthPackageExtCtrl());

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(
        color: kPrimaryColor,
      ),
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          ctrl.setIsLoading(true);
          webViewController?.reload();
        }
        
        else if (defaultTargetPlatform == TargetPlatform.iOS) {
          ctrl.setIsLoading(true);
          webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
    ctrl.setIsLoading(true);
  }

  Widget buildContent() {
    return InAppWebView(
      key: webViewKey,
      initialUrlRequest: URLRequest(url: WebUri(widget.link)),
      initialUserScripts: UnmodifiableListView<UserScript>([]),
      pullToRefreshController: pullToRefreshController,
      onWebViewCreated: (controller) async {
        webViewController = controller;
      },
      onLoadStop: (controller, url) async {
        pullToRefreshController?.endRefreshing();
        ctrl.setIsLoading(false);
      },
      onReceivedError: (controller, req, error) {
        pullToRefreshController?.endRefreshing();
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
        title: '',
        body: SafeArea(
          child: Stack(
            children: [
              buildContent(),
              Obx(() => ctrl.isLoading ? const Center(child: AppActivityIndicator()) : const Stack()),
            ],
          ),
        ),
        actions: [
          Obx(() =>
            IconButton(
              onPressed: ctrl.isLoading ? null : () {
                if (ctrl.isLoading == false) {
                  ctrl.setIsLoading(true);
                  webViewController?.reload();
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

class HealthPackageExtCtrl extends GetxController {

  final _isLoading = false.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  bool get isLoading => _isLoading.value;
}