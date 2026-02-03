import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/health-package/my_cart_ctrl.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/user_data_manager.dart';
import 'package:vesalius_m_flutter/ui/guest.dart';
import 'package:vesalius_m_flutter/ui/main_layout.dart';
import 'package:vesalius_m_flutter/ui/profile/my_package.dart';

import 'checkout_ok.dart';

class IpaySubmit extends StatefulWidget {

  final String? data;
  final bool repay;

  const IpaySubmit({
    super.key,
    this.data,
    this.repay = false,
  });

  @override
  State<IpaySubmit> createState() => _IpaySubmitState();
}

class _IpaySubmitState extends State<IpaySubmit> {

  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();

  final IpaySubmitCtrl ctrl = Get.put(IpaySubmitCtrl());
  final MyCartCtrl myCartCtrl = Get.put(MyCartCtrl());

  @override
  void initState() {
    super.initState();
    ctrl.setIsLoading(true);
  }

  Widget buildContent() {
    // return InAppWebView(
    //   key: webViewKey,
    //   initialData: widget.data == null ? null : InAppWebViewInitialData(
    //     data: widget.data!,
    //   ),
    //   onWebViewCreated: (controller) async {
    //     webViewController = controller;
    //   },
    // );

    return InAppWebView(
      key: webViewKey,
      initialUrlRequest: URLRequest(url: WebUri('$kServerUrl/payment/ipay88/submit?requestNo=${widget.data}')),
      initialUserScripts: UnmodifiableListView<UserScript>([]),
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
      onLoadStop: (controller, url) async {
        String? userMode = await AuthManager.instance.getUserMode();
        ctrl.setIsLoading(false);
        if (url.toString().contains('backend/response')) {
          String html = await controller.evaluateJavascript(source: "window.document.getElementsByTagName('html')[0].outerHTML;");
          if (html.contains('Payment fail')) {
            Get.back();
          }

          else if (html.contains('Thank you for payment')) {
            myCartCtrl.clear();
            await UserDataManager.instance.clearCart(userMode);
            if (AuthManager.instance.isLogin) {
              if (widget.repay) {
                Get.offAll(() => const MainLayout(index: 2));
                Get.to(() => const MyPackage());
                // Get.offUntil(GetPageRoute(page: () => const MyPackage()), (route) => (route as GetPageRoute).routeName == MainLayout.routeName);
              }

              else {
                Get.offUntil(GetPageRoute(page: () => const CheckoutOK()), (route) => (route as GetPageRoute).routeName == MainLayout.routeName);
              }
            }

            else {
              Get.offUntil(GetPageRoute(page: () => const CheckoutOK()), (route) => (route as GetPageRoute).routeName == Guest.routeName);
            }
          }
        }
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
        title: '',
        body: SafeArea(
          child: Stack(
            children: [
              buildContent(),
              Obx(() => ctrl.isLoading ? const Center(child: AppActivityIndicator()) : const Stack()),
            ],
          ),
        ),
      ),
    );
  }
}

class IpaySubmitCtrl extends GetxController {

  final _isLoading = false.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  bool get isLoading => _isLoading.value;
}