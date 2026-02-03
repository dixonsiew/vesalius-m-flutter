import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/payment_data.dart';

class CheckoutOK extends StatelessWidget {

  final WallexRes? data;

  const CheckoutOK({
    super.key,
    this.data,
  });

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 144.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/icon/tick3.png',
                  width: 72.0,
                  height: 72.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 24.0),
                Text(
                  'Transaction Submitted Successfully',
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    '',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: kColor2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (data != null && data!.paymentUrl.isNotEmpty) ...[
                  TextButton(
                    onPressed: () {
                      launchURL(data!.paymentUrl);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: kPrimaryColor,
                    ),
                    child: Text(
                      'Click here to pay',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Link Expiry Date: ${data!.expDateTime}',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: kColor2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppElevatedButton(
                  text: 'Dismiss',
                  onPressed: () {
                    Get.back();
                  },
                ),
                /* const SizedBox(height: 16.0),
                AppOutlinedButton(
                  text: 'Later',
                  onPressed: () {
                    if (AuthManager.instance.isLogin) {
                      Get.until((route) => Get.currentRoute == MainLayout.routeName);
                    }
                        
                    else {
                      Get.until((route) => Get.currentRoute == Guest.routeName);
                    }
                  },
                ), */
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: '',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}