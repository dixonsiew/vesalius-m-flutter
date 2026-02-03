import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/health-package/checkout_ctrl.dart';

import 'checkout_ok.dart';

class Checkout extends StatefulWidget {

  static const String routeName = '/Checkout';

  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {

  final CheckoutCtrl ctrl = Get.put(CheckoutCtrl());

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
                  const SizedBox(height: 20.0),
                  Text(
                    'Order Details',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor2,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEBEBEB).withOpacity(0.7),
                          blurRadius: 7.0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/imgs/py1.png',
                          width: 56.0,
                          height: 56.0,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Cardiac Health Screening Package',
                                style: kTextStyle1.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: kTextColor1,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.ideographic,
                                children: [
                                  Text(
                                    'RM 1029.00',
                                    style: kTextStyle1.copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  Text(
                                    'x1',
                                    style: kTextStyle1.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: kTextColor1,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Billing Details',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          
                        },
                        child: const Icon(
                          Icons.edit,
                          color: kPrimaryColor,
                          size: 24.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.5, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDBDBDB).withOpacity(0.3),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'images/icon/location4.png',
                          width: 24.0,
                          height: 24.0,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Abu bin Ahmad',
                                style: kTextStyle1.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: kTextColor1,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                '016-2700438',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: kTextColor1,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Block A-12, Pavillion Residence, 52000 Kuala Lumpur',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: kTextColor1,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    'Payment Method',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor2,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
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
                          ctrl.setPaymentMethod(PaymentMethod.creditCard);
                        },
                        borderRadius: BorderRadius.circular(5.0),
                        child: Theme(
                          data: ThemeData(
                            unselectedWidgetColor: kPrimaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Obx(() =>
                                  Radio<PaymentMethod>(
                                    value: PaymentMethod.creditCard,
                                    groupValue: ctrl.paymentMethod,
                                    activeColor: kPrimaryColor,
                                    onChanged: (value) {
                                      ctrl.setPaymentMethod(value);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Image.asset(
                                  'images/icon/credit-card.png',
                                  width: 32.0,
                                  height: 16.0,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: Text(
                                    'Credit Card / Debit Card',
                                    style: kTextStyle1.copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: kTextColor1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
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
                          ctrl.setPaymentMethod(PaymentMethod.fpx);
                        },
                        borderRadius: BorderRadius.circular(5.0),
                        child: Theme(
                          data: ThemeData(unselectedWidgetColor: kPrimaryColor),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Obx(() =>
                                  Radio<PaymentMethod>(
                                    value: PaymentMethod.fpx,
                                    groupValue: ctrl.paymentMethod,
                                    activeColor: kPrimaryColor,
                                    onChanged: (value) {
                                      ctrl.setPaymentMethod(value);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Image.asset(
                                  'images/icon/fpx.png',
                                  width: 32.0,
                                  height: 16.0,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: Text(
                                    'Online Banking',
                                    style: kTextStyle1.copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: kTextColor1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
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
                  text: 'Place Order',
                  onPressed: () {
                    Get.to(() => const CheckoutOK());
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
      title: 'Checkout',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}