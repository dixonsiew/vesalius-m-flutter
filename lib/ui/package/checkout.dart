import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/ui/package/billing_detail.dart';
import 'package:vesalius_m_flutter/ui/package/checkout_ok.dart';

class Checkout extends StatefulWidget {

  final String amount;

  const Checkout({
    Key? key, 
    required this.amount,
  }) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

enum PaymentMethod { creditCard, fpx }

class _CheckoutState extends State<Checkout> {

  PaymentMethod? paymentMethod = PaymentMethod.creditCard;
  bool isLoading = false;

  Widget buildContent() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Order Details',
              style: kLabelTextStyle.copyWith(
                fontSize: 16.0,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            padding: const EdgeInsets.only(left: 16.0, right: 14.0, top: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(235, 235, 235, 0.7),
                  blurRadius: 7.0,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'images/imgs/pckc2.png',
                  width: 56.0,
                  height: 56.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Post Covid-19 Screening Package',
                        style: kMainTextStyle.copyWith(
                          fontFamily: kBodyFont,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'RM 450.00',
                            style: kBodyTextStyle.copyWith(
                              fontWeight: FontWeight.w700,
                              color: kMainColor,
                            ),
                          ),
                          Text(
                            'x1',
                            style: kMainTextStyle.copyWith(
                              fontFamily: kBodyFont,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 17.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Billing Details',
                  style: kLabelTextStyle.copyWith(
                    fontSize: 16.0,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.toNamed(BillingDetail.routeName);
                  },
                  icon: Image.asset(
                    'images/icon/edit.png',
                    width: 16.0,
                    height: 16.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            padding: const EdgeInsets.only(left: 14.5, right: 10.0, top: 12.0, bottom: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(219, 219, 219, 0.3),
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
                const SizedBox(width: 12.5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kon Jia Her',
                        style: kMainTextStyle.copyWith(
                          fontFamily: kBodyFont,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '016-2700438',
                        style: kMainTextStyle.copyWith(
                          fontFamily: kBodyFont,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Block A-12, Pavillion Residence, 52000 Kuala Lumpur',
                        style: kMainTextStyle.copyWith(
                          fontFamily: kBodyFont,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Payment Method',
              style: kLabelTextStyle.copyWith(
                fontSize: 16.0,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  paymentMethod = PaymentMethod.creditCard;
                });
              },
              child: Container(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(219, 219, 219, 0.3),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Radio<PaymentMethod>(
                      value: PaymentMethod.creditCard,
                      groupValue: paymentMethod,
                      activeColor: kMainColor,
                      onChanged: (PaymentMethod? val) {
                        setState(() {
                          paymentMethod = val;
                        });
                      },
                    ),
                    const SizedBox(width: 10.0),
                    Image.asset(
                      'images/icon/credit-card.png',
                      width: 32.0,
                      height: 16.0,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 20.0),
                    Text(
                      'Credit Card / Debit Card',
                      style: kMainTextStyle.copyWith(
                        fontFamily: kBodyFont,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  paymentMethod = PaymentMethod.fpx;
                });
              },
              child: Container(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(219, 219, 219, 0.3),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Radio<PaymentMethod>(
                      value: PaymentMethod.fpx,
                      groupValue: paymentMethod,
                      activeColor: kMainColor,
                      onChanged: (PaymentMethod? val) {
                        setState(() {
                          paymentMethod = val;
                        });
                      },
                    ),
                    const SizedBox(width: 10.0),
                    Image.asset(
                      'images/icon/fpx.png',
                      width: 32.0,
                      height: 16.0,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      'Online Banking',
                      style: kMainTextStyle.copyWith(
                        fontFamily: kBodyFont,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 160.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: const Color(0xFFF8F8F8),
        leading: const BackBtn(color: Color(0xFF002E50)),
        centerTitle: true,
        title: Text(
          'Checkout',
          style: kMainTextStyle.copyWith(
            fontSize: 16.0,
            color: const Color(0xFF002E50),
          ),
        ),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(),
        child: SafeArea(
          child: isLoading ? Container() : Stack(
            children: [
              buildContent(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0, bottom: 27.0),
                  color: const Color(0xFFF8F8F8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Payment',
                            style: kMainTextStyle.copyWith(
                              fontFamily: kBodyFont,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'RM ${widget.amount}',
                            style: kTitleTextStyle.copyWith(
                              fontSize: 20.0,
                              color: kMainColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed(CheckoutOK.routeName);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 5.0,
                          backgroundColor: kMainColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                        ),
                        child: Text(
                          'Place Order',
                          style: kMainTextStyle.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
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