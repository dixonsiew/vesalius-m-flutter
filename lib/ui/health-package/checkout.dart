import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/package_image.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/health-package/billing_detail_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/health-package/checkout_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/health-package/my_cart_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/cart_data.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/user_data_manager.dart';
import 'package:vesalius_m_flutter/services/guest_service.dart';
import 'package:vesalius_m_flutter/services/user_package_service.dart';
import 'package:vesalius_m_flutter/ui/guest.dart';
import 'package:vesalius_m_flutter/ui/health-package/ipay_submit.dart';
import 'package:vesalius_m_flutter/ui/main_layout.dart';

import 'checkout_ok.dart';
import 'my_cart.dart';

class Checkout extends StatefulWidget {

  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {

  ScrollController scr = ScrollController();

  final CheckoutCtrl ctrl = Get.put(CheckoutCtrl());
  final MyCartCtrl myCartCtrl = Get.put(MyCartCtrl());
  final BillingDetailCtrl billingDetailCtrl = Get.put(BillingDetailCtrl());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  Future<void> validateCart() async {
    try {
      ctrl.setIsLoading(true);
      final o = {
        'package': myCartCtrl.cartList.map((x) => {
          'package_id': x.id,
          'quantityPurchased': x.quantity
        }).toList()
      };
      if (AuthManager.instance.isLogin) {
        final m = await UserPackageService.checkCartValidity(o);
        if (m != null) {
          myCartCtrl.setCartIsValid(m.cartIsValid);
          if (m.cartIsValid == false) {
            myCartCtrl.setInvalidPackages(m.invalidPackages);
          }

          else {
            myCartCtrl.setInvalidPackages([]);
          }
        }

        else {
          myCartCtrl.setCartIsValid(false);
          myCartCtrl.setInvalidPackages([]);
        }
      }

      else {
        final m = await GuestModeService.checkCartValidity(o);
        if (m != null) {
          myCartCtrl.setCartIsValid(m.cartIsValid);
          if (m.cartIsValid == false) {
            myCartCtrl.setInvalidPackages(m.invalidPackages);
          }

          else {
            myCartCtrl.setInvalidPackages([]);
          }
        }

        else {
          myCartCtrl.setCartIsValid(false);
          myCartCtrl.setInvalidPackages([]);
        }
      }

      ctrl.setIsLoading(false);
      if (myCartCtrl.cartIsValid) {
        onCheckout();
      }

      else {
        Get.until((route) => Get.currentRoute == MyCart.routeName);
      }
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, validateCart);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  void onCheckoutIpay() async {
    try {
      ctrl.setIsLoading(true);
      final user = await DataManager.instance.getUserDetails();
      List<dynamic> lp = [];
      final billing = billingDetailCtrl.billing;
      for (int i = 0; i < myCartCtrl.cartList.length; i++) {
        final p = myCartCtrl.cartList[i];
        if (AuthManager.instance.isLogin) {
          lp.add({
            'patientPrn': user!.prn ?? '',
            'patientName': '${user.firstName} ${user.middleName ?? ''} ${user.lastName ?? ''}'.trim(),
            'package_id': p.package.packageId,
            'packageName': p.package.packageName,
            'packagePrice': p.package.packagePrice,
            'quantityPurchased': p.quantity
          });
        }
        
        else {
          lp.add({
            'package_id': p.package.packageId,
            'packageName': p.package.packageName,
            'packagePrice': p.package.packagePrice,
            'quantityPurchased': p.quantity
          });
        }
      }
      if (AuthManager.instance.isLogin) {
        final o = {
          'userPackage': lp,
          'userPackagePayment': {
            'billingFullname': billing?.fullName,
            'billingAddress1': billing?.address1,
            'billingAddress2': billing?.address2,
            'billingAddress3': billing?.address3,
            'billingTowncity': billing?.city,
            'billingState': billing?.state,
            'billingPostcode': billing?.postcode,
            'billingCountryCode': billingDetailCtrl.selectedCountry?.countryCode,
            'billingContactNo': billing?.contact2,
            'billingContactCode': billing?.contact1,
            'billingEmail': billing?.email
          }
        };
        final res = await UserPackageService.postPurchaseIpay(o);
        ctrl.setIsLoading(false);
        Get.to(() => IpaySubmit(data: res));
      }

      else {
        final o = {
          'guestPackage': lp,
          'guestPackagePayment': {
            'billingFullname': billing?.fullName,
            'billingAddress1': billing?.address1,
            'billingAddress2': billing?.address2,
            'billingAddress3': billing?.address3,
            'billingTowncity': billing?.city,
            'billingState': billing?.state,
            'billingPostcode': billing?.postcode,
            'billingCountryCode': billingDetailCtrl.selectedCountry?.countryCode,
            'billingContactNo': billing?.contact2,
            'billingContactCode': billing?.contact1,
            'billingEmail': billing?.email
          }
        };
        final res = await GuestModeService.postPurchaseIpay(o);
        ctrl.setIsLoading(false);
        Get.to(() => IpaySubmit(data: res));
      }
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleSubmitError(error, error.toString(), onSubmit);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'dismiss'.tr);
    }
  }

  void onCheckout() async {
    try {
      if (billingDetailCtrl.selectedCountry?.countryCode != 'ID') {
        onCheckoutIpay();
        return;
      }

      ctrl.setIsLoading(true);
      final user = await DataManager.instance.getUserDetails();
      List<dynamic> lp = [];
      final billing = billingDetailCtrl.billing;
      for (int i = 0; i < myCartCtrl.cartList.length; i++) {
        final p = myCartCtrl.cartList[i];
        if (AuthManager.instance.isLogin) {
          lp.add({
            'patientPrn': user!.prn ?? '',
            'patientName': '${user.firstName} ${user.middleName ?? ''} ${user.lastName ?? ''}'.trim(),
            'package_id': p.package.packageId,
            'packageName': p.package.packageName,
            'packagePrice': p.package.packagePrice,
            'quantityPurchased': p.quantity
          });
        }

        else {
          lp.add({
            'package_id': p.package.packageId,
            'packageName': p.package.packageName,
            'packagePrice': p.package.packagePrice,
            'quantityPurchased': p.quantity
          });
        }
      }
      if (AuthManager.instance.isLogin) {
        final o = {
          'userPackage': lp,
          'userPackagePayment': {
            'billingFullname': billing?.fullName,
            'billingAddress1': billing?.address1,
            'billingAddress2': billing?.address2,
            'billingAddress3': billing?.address3,
            'billingTowncity': billing?.city,
            'billingState': billing?.state,
            'billingPostcode': billing?.postcode,
            'billingCountryCode': billingDetailCtrl.selectedCountry?.countryCode,
            'billingContactNo': billing?.contact2,
            'billingContactCode': billing?.contact1,
            'billingEmail': billing?.email
          }
        };
        final wallexRes = await UserPackageService.postPurchaseWallex(o);
        String? userMode = await AuthManager.instance.getUserMode();
        myCartCtrl.clear();
        await UserDataManager.instance.clearCart(userMode);
        ctrl.setIsLoading(false);
        if (wallexRes != null) {
          Get.offUntil(GetPageRoute(page: () => CheckoutOK(data: wallexRes)), (route) => (route as GetPageRoute).routeName == MainLayout.routeName);
        }
      }
      
      else {
        final o = {
          'guestPackage': lp,
          'guestPackagePayment': {
            'billingFullname': billing?.fullName,
            'billingAddress1': billing?.address1,
            'billingAddress2': billing?.address2,
            'billingAddress3': billing?.address3,
            'billingTowncity': billing?.city,
            'billingState': billing?.state,
            'billingPostcode': billing?.postcode,
            'billingCountryCode': billingDetailCtrl.selectedCountry?.countryCode,
            'billingContactNo': billing?.contact2,
            'billingContactCode': billing?.contact1,
            'billingEmail': billing?.email
          }
        };
        final wallexRes = await GuestModeService.postPurchaseWallex(o);
        String? userMode = await AuthManager.instance.getUserMode();
        myCartCtrl.clear();
        await UserDataManager.instance.clearCart(userMode);
        ctrl.setIsLoading(false);
        if (wallexRes != null) {
          Get.offUntil(GetPageRoute(page: () => CheckoutOK(data: wallexRes)), (route) => (route as GetPageRoute).routeName == Guest.routeName);
        }
      }
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleSubmitError(error, error.toString(), onSubmit);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'dismiss'.tr);
    }
  }

  void onSubmit() async {
    await validateCart();
  }

  List<Widget> buildItems() {
    List<Widget> lx = [];
    for (int i = 0; i < myCartCtrl.cartList.length; i++) {
      final o = myCartCtrl.cartList[i];
      final w = CartItem(key: ValueKey(o.id), data: o);
      lx.add(w);
      if (i < myCartCtrl.cartList.length - 1) {
        lx.add(const SizedBox(height: 16.0));
      }
    }

    return lx;
  }

  Widget buildContent() {
    return Obx(() => myCartCtrl.cartList.isEmpty ? Container() : 
    Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 123.0),
          child: Scrollbar(
            controller: scr,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                controller: scr,
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
                  ...buildItems(),
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
                        onTap: () => Get.back(),
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
                          color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
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
                                billingDetailCtrl.billing?.fullName ?? '',
                                style: kTextStyle1.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: kTextColor1,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                '${billingDetailCtrl.billing?.contact1}${billingDetailCtrl.billing?.contact2}',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: kTextColor1,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                '${billingDetailCtrl.billing?.address1 ?? ''} ${billingDetailCtrl.billing?.address2 ?? ''} ${billingDetailCtrl.billing?.address3 ?? ''}'.trim(),
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

                  if (billingDetailCtrl.selectedCountry?.countryCode == 'ID') ...[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Image.asset(
                        'images/imgs/wallex.jpg',
                        width: 100.0,
                        height: 50.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Supports international bank transfers. Recommended payment method for users based in Indonesia.',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Text(
                          'iPay88',
                          style: kTextStyle1.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: kTextColor1,
                          ),
                        ),
                        Image.asset(
                          'images/imgs/ipay88.png',
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    Text(
                      'Payment made easy with your Credit/Debit card. Recommended payment method for users based in Malaysia.',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      "Refunds are not permitted, except in cases of payment transaction errors or in exceptional circumstances, such as the patient's physical incapacity (e.g., due to death). Purchases may be converted into equivalent alternatives. To request for a refund, kindly submit proof of transaction accompanied by reason to pbo1@islandhospital.com. All refund requests are subject to the Metro Hospital discretion.",
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ],

                  /* Text(
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
                          color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
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
                          color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
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
                  ), */
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
                      'RM ${formatPrice(myCartCtrl.cartTotalPrice)}',
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
                  onPressed: onSubmit,
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Checkout',
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: buildContent(),
          ),
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {

  final MyCartItem data;

  const CartItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEBEBEB).withValues(alpha: 0.7),
            blurRadius: 7.0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: PackageImage(
              img: data.package.packageImage,
              width: 56.0,
              height: 56.0,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.package.packageName,
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
                      'RM ${formatPrice(data.package.packagePrice)}',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                    ),
                    Text(
                      'x${data.quantity}',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: kTextColor1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Subtotal: ',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor2,
                        ),
                      ),
                      TextSpan(
                        text: 'RM ${formatPrice(data.subtotal)}',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}