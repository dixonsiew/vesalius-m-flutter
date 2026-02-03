import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

import 'billing_detail.dart';

class MyCart extends StatefulWidget {

  static const String routeName = '/MyCart';

  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 123.0),
          child: Scrollbar(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 24.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDBDBDB).withOpacity(0.3),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Image.asset(
                                'images/imgs/px1.png',
                                width: 100.0,
                                height: 100.0,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      'Cardiac Health Screening Package',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: kTextColor4,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      'RM 1029.00',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            
                                          },
                                          splashRadius: 24.0,
                                          icon: Container(
                                            width: 24.0,
                                            height: 24.0,
                                            decoration: const BoxDecoration(
                                              color: kSecondaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.remove,
                                                size: 16.0,
                                                color: kPrimaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        const Text(
                                          '1',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: kTextColor4,
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        IconButton(
                                          onPressed: () {
                                            
                                          },
                                          splashRadius: 24.0,
                                          icon: Container(
                                            width: 24.0,
                                            height: 24.0,
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
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              onPressed: () {
                                                
                                              },
                                              icon: Image.asset(
                                                'images/icon/delete.png',
                                                width: 26.44,
                                                height: 24.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Payment',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: kTextColor2,
                      ),
                    ),
                    Text(
                      'RM 1029.00',
                      style: kTextStyle1.copyWith(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 23.0),
                AppElevatedButton(
                  text: 'Checkout',
                  onPressed: () {
                    Get.to(() => const BillingDetail());
                  },
                ),
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
      title: 'My Cart',
      body:  SafeArea(
        child: buildContent(),
      ),
    );
  }
}