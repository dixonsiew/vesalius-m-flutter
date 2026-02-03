import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/health_package_ctrl.dart';

import 'health-package/health_package_detail.dart';
import 'health-package/my_cart.dart';

class HealthPackage extends StatefulWidget {

  static const String routeName = '/HealthPackage';

  const HealthPackage({super.key});

  @override
  State<HealthPackage> createState() => _HealthPackageState();
}

class _HealthPackageState extends State<HealthPackage> {

  final HealthPackageCtrl ctrl = Get.put(HealthPackageCtrl());

  Widget buildContent() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: SizedBox(
              width: double.infinity,
              height:  MediaQuery.of(context).size.height,
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 32.0,
                  mainAxisSpacing: 24.0,
                  mainAxisExtent: 232.0,
                ),
                children: const [
                  PackageItem(
                    image: 'pck1.png',
                    name: 'Cardiac Health Screening Package',
                    price: 1029.00,
                  ),
                  PackageItem(
                    image: 'pck2.png',
                    name: 'Blood Screening Package',
                    price: 108.00,
                  ),
                  PackageItem(
                    image: 'pck2.png',
                    name: 'HPV Vaccination x 3 Doses',
                    price: 1488.00,
                  ),
                ],
              ),
            ),
          ),
        ],
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
                        '${ctrl.count}',
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

class PackageItem extends StatelessWidget {

  final String image;
  final String name;
  final double price;

  const PackageItem({
    super.key, 
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDBDBDB).withOpacity(0.3),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: () {
            Get.to(() => HealthPackageDetail());
          },
          borderRadius: BorderRadius.circular(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
                child: Image.asset(
                  'images/imgs/$image',
                  width: 148.0,
                  height: 148.0,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name,
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: kTextColor4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 14.0),
                child: Text(
                  'RM ${price.toStringAsFixed(2)}',
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}