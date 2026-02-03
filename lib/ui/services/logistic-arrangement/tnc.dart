import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

import 'request.dart';

class TnC extends StatelessWidget {

  final String? data;
  final bool showAgree;
  
  const TnC({
    super.key,
    this.data,
    this.showAgree = false,
  });

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: showAgree ? 144.0 : 0),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      data ?? '',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showAgree) ...[
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppElevatedButton(
                    text: 'Agree',
                    onPressed: () {
                      Get.to(() => const Request());
                    },
                  ),
                  const SizedBox(height: 16.0),
                  AppOutlinedButton(
                    text: 'Decline',
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Terms & Conditions',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}