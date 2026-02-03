import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/cart_model.dart';
import 'package:vesalius_m_flutter/ui/package/checkout.dart';

class Cart extends StatefulWidget {

  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {

  bool isLoading = false;

  String get amount {
    int n = context.read<CartModel>().cartItemCount;
    double price = n * 450.00;
    return price.toStringAsFixed(2);
  }

  Widget buildContent() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
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
                    'images/imgs/pckc1.png',
                    width: 100.0,
                    height: 100.0,
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
                        const SizedBox(height: 8.0),
                        Text(
                          'RM $amount',
                          style: kTitleTextStyle.copyWith(
                            fontSize: 14.0,
                            color: kMainColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: context.read<CartModel>().cartItemCount < 1 ? null : () {
                                  context.read<CartModel>().removeCartItem();
                                },
                                icon: Image.asset(
                                  'images/icon/minus2.png',
                                  width: 24.0,
                                  height: 24.0,
                                  fit: BoxFit.cover,
                                ),
                                alignment: Alignment.bottomLeft,
                                padding: EdgeInsets.zero,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 25.0),
                                child: SizedBox(
                                  width: 30.0,
                                  child: Text(
                                    '${context.watch<CartModel>().cartItemCount}',
                                    style: kMainTextStyle.copyWith(
                                      fontSize: 16.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  context.read<CartModel>().addCartItem(1);
                                },
                                icon: Image.asset(
                                  'images/icon/plus2.png',
                                  width: 24.0,
                                  height: 24.0,
                                  fit: BoxFit.cover,
                                ),
                                alignment: Alignment.bottomRight,
                                padding: EdgeInsets.zero,
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    
                                  },
                                  icon: Image.asset(
                                    'images/icon/bin.png',
                                    width: 24.0,
                                    height: 24.0,
                                    fit: BoxFit.cover,
                                  ),
                                  alignment: Alignment.bottomRight,
                                  padding: EdgeInsets.zero,
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
          'My Cart',
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
                            'RM $amount',
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
                          Get.to(() => Checkout(amount: amount));
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 5.0,
                          backgroundColor: kMainColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                        ),
                        child: Text(
                          'Checkout',
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