import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/ui/main_layout.dart';
import 'package:vesalius_m_flutter/ui/profile/my_package.dart';

class IpaySubmitTest extends StatefulWidget {

  const IpaySubmitTest({super.key});

  @override
  State<IpaySubmitTest> createState() => _IpaySubmitTestState();
}

class _IpaySubmitTestState extends State<IpaySubmitTest> {

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    Future.delayed(const Duration(seconds: 3), () async {
      Get.offAll(() => const MainLayout(index: 2));
      Get.to(() => const MyPackage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: kBgColor1);
  }
}