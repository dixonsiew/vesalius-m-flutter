import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';

class ExternalHospital extends StatefulWidget {
  
  static const String routeName = '/ExternalHospital';

  const ExternalHospital({Key? key}) : super(key: key);

  @override
  State<ExternalHospital> createState() => _ExternalHospitalState();
}

class _ExternalHospitalState extends State<ExternalHospital> {

  InAppWebViewController? webViewController;
  double progress = 0;
  final GlobalKey webViewKey = GlobalKey();

  void launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }

    else {
      await showCustomDialog('Failed', 'Unable to launch: $url', 'Dismiss');
    }
  }

  void onBack() async {
    if (webViewController == null) {
      Get.back();
    }

    else {
      if (await webViewController!.canGoBack()) {
        webViewController!.goBack();
      }

      else {
        Get.back();
      }
    }
  }

  Future<bool> onWillPop() async {
    if (webViewController == null) {
      return true;
    }

    if (await webViewController!.canGoBack()) {
      webViewController!.goBack();
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
          toolbarHeight: kAppToolbarHeight,
          automaticallyImplyLeading: false,
          leadingWidth: 100.0,
          backgroundColor: const Color(0xFFF8F8F8),
          leading: BackBtn(color: kMainColor, onBack: onBack),
          elevation: 0.0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                onPressed: () {
                  webViewController?.reload();
                },
                icon: const Icon(
                  Icons.refresh,
                  color: kMainColor,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFF8F8F8),
        body: Column(
          children: [
            Visibility(
              visible: progress < 1.0,
              child: LinearProgressIndicator(
                value: progress,
                color: kMainColor,
                backgroundColor: Colors.black12,
              ),
            ),
            Expanded(
              child: InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: Uri.parse('https://www.islandhospital.com/en/about-us')),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    useShouldOverrideUrlLoading: true,
                    javaScriptCanOpenWindowsAutomatically: true,
                  ),
                ),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;
                  if (![
                    "http",
                    "https",
                    "javascript",
                    "about"
                  ].contains(uri.scheme)) {
                    launchURL(uri.toString());
                    return NavigationActionPolicy.CANCEL;
                  }
      
                  return NavigationActionPolicy.ALLOW;
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}