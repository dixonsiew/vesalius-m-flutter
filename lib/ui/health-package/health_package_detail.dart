import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/health_package_ctrl.dart';

import 'my_cart.dart';

class HealthPackageDetail extends StatelessWidget {

  static const String routeName = '/HealthPackageDetail';

  final HealthPackageDetailCtrl ctrl = Get.put(HealthPackageDetailCtrl());
  final HealthPackageCtrl healthPackageCtrl = Get.put(HealthPackageCtrl());

  HealthPackageDetail({super.key});

  Widget buildContent() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'images/imgs/pc1.png',
              width: double.infinity,
              height: 375.0,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Cardiac Health Screening Package',
                style: kTextStyle1.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'RM 1029.00',
                style: kTextStyle1.copyWith(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'DESCRIPTION',
                style: kTextStyle1.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: kTextColor2,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Our health screening centre is dedicated to the pursuit of a healthy life, by advocating regular screening to our patients and their loved ones. Because we know, regular screenings leads to early detection and treatment.',
                style: kTextStyle1.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor4,
                ),
              ),
            ),
            const SizedBox(height: 45.0),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 16.0, bottom: 16.0),
              child: Row(
                children: [
                  Obx(() =>
                    IconButton(
                      onPressed: ctrl.count < 1 ? null : () {
                        if (ctrl.count > 0) {
                          int c = ctrl.count;
                          ctrl.setCount(--c);
                        }
                      },
                      splashRadius: 28.0,
                      icon: Obx(() =>
                        Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: ctrl.count < 1 ? const Color(0xFFDBDBDB).withOpacity(0.3) : kSecondaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.remove,
                              size: 16.0,
                              color: ctrl.count < 1 ? const Color(0xFFB1B1B1) : kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Obx(() =>
                    Text(
                      '${ctrl.count}',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    onPressed: () {
                      int c = ctrl.count;
                      ctrl.setCount(++c);
                    },
                    splashRadius: 28.0,
                    icon: Container(
                      width: 32.0,
                      height: 32.0,
                      decoration: const BoxDecoration(
                        color: kSecondaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          size: 16.0,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width:34.0),
                  Expanded(
                    child: AppElevatedButton(
                      text: 'Add To Cart',
                      onPressed: () {
                        healthPackageCtrl.setCount(ctrl.count);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Health Packages',
      body: SafeArea(
        child: buildContent(),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Stack(
            children: [
              IconButton(
                onPressed: () {
                  Get.to(() => const MyCart());
                },
                icon: Image.asset(
                  'images/icon/cart.png',
                  width: 16.0,
                  height: 14.18,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 9.0,
                right: 12.0,
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Center(
                    child: Obx(() =>
                      Text(
                        '${healthPackageCtrl.count}',
                        style: const TextStyle(
                          fontSize: 9.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}