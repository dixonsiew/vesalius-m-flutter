import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/package_image.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/health-package/my_cart_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/cart_data.dart';
import 'package:vesalius_m_flutter/models/user_data_manager.dart';
import 'package:vesalius_m_flutter/services/guest_service.dart';
import 'package:vesalius_m_flutter/services/user_package_service.dart';

import 'billing_detail.dart';

class MyCart extends StatefulWidget {

  static const String routeName = '/MyCart';

  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {

  ScrollController scr = ScrollController();
  final MyCartCtrl ctrl = Get.put(MyCartCtrl());

  @override
  void initState() {
    super.initState();
    ctrl.setTotal();
    load();
  }

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  Future<void> load() async {
    try {
      ctrl.setIsLoading(true);
      final o = {
        'package': ctrl.cartList.map((x) => {
          'package_id': x.id,
          'quantityPurchased': x.quantity
        }).toList()
      };
      if (AuthManager.instance.isLogin) {
        final m = await UserPackageService.checkCartValidity(o);
        if (m != null) {
          ctrl.setCartIsValid(m.cartIsValid);
          if (m.cartIsValid == false) {
            ctrl.setInvalidPackages(m.invalidPackages);
          }

          else {
            ctrl.setInvalidPackages([]);
          }
        }

        else {
          ctrl.setCartIsValid(false);
          ctrl.setInvalidPackages([]);
        }
      }

      else {
        final m = await GuestModeService.checkCartValidity(o);
        if (m != null) {
          ctrl.setCartIsValid(m.cartIsValid);
          if (m.cartIsValid == false) {
            ctrl.setInvalidPackages(m.invalidPackages);
          }

          else {
            ctrl.setInvalidPackages([]);
          }
        }

        else {
          ctrl.setCartIsValid(false);
          ctrl.setInvalidPackages([]);
        }
      }

      ctrl.setIsLoading(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, load);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  Widget buildContent() {
    return Obx(() => ctrl.cartList.isEmpty ? const NoCart() : 
    Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 123.0),
          child: Scrollbar(
            controller: scr,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(() =>
                ListView.builder(
                  controller: scr,
                  shrinkWrap: true,
                  itemCount: ctrl.cartList.length + 1,
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return const SizedBox(height: 24.0);
                    }
              
                    final o = ctrl.cartList[i - 1];
                    return CartItem(
                      key: ValueKey(o.id),
                      data: o,
                      load: load,
                    );
                  },
                ),
              ),
              
              /* ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 24.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
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
                                            decoration: BoxDecoration(
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
                                            decoration: BoxDecoration(
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
              ), */
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
                    Obx(() =>
                      Text(
                        'RM ${formatPrice(ctrl.cartTotalPrice)}',
                        style: kTextStyle1.copyWith(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 23.0),
                AppElevatedButton(
                  text: 'Checkout',
                  onPressed: ctrl.cartIsValid == false ? null : () async {
                    await load();
                    if (ctrl.cartIsValid) {
                      Get.to(() => const BillingDetail());
                    }
                  },
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
      title: 'My Cart',
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
  final void Function() load;
  final MyCartCtrl ctrl = Get.put(MyCartCtrl());

  CartItem({
    super.key,
    required this.data,
    required this.load,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: ctrl.invalidPackages.containsKey(data.id) ? Border.all(color: kTextColor3) : Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: PackageImage(
                      img: data.package.packageImage,
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
                            data.package.packageName,
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
                            'RM ${formatPrice(data.package.packagePrice)}',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        CartInput(
                          key: ValueKey(data.id),
                          data: data,
                          onAdd: (o) async {
                            final x = ctrl.add(o.package, 1);
                            if (x != null) {
                              String userMode = await AuthManager.instance.getUserMode();
                              UserDataManager.instance.updateCart(userMode, o.package.packageId, x);
                            }
                          },
                          onMinus: (o) async {
                            final x = ctrl.remove(o.package);
                            if (x != null) {
                              String userMode = await AuthManager.instance.getUserMode();
                              if (x.quantity == 0) {
                                UserDataManager.instance.removeFromCart(userMode, o.package.packageId);
                              }
              
                              else {
                                UserDataManager.instance.updateCart(userMode, o.package.packageId, x);
                              }

                              if (x.quantity == ctrl.invalidPackages[data.id]?.recommendedQuantity) {
                                load.call();
                              }
                            }
                          },
                          onDelete: (o) async {
                            ctrl.delete(o);
                            String userMode = await AuthManager.instance.getUserMode();
                            UserDataManager.instance.removeFromCart(userMode, o.package.packageId);
                            load.call();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (ctrl.invalidPackages.containsKey(data.id) && ctrl.invalidPackages[data.id]?.soldout == 1) ...[
                ElevatedButton(
                  onPressed: () async {
                    ctrl.delete(data);
                    String userMode = await AuthManager.instance.getUserMode();
                    UserDataManager.instance.removeFromCart(userMode, data.package.packageId);
                    load.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kTextColor3,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 32.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  ),
                  child: Text(
                    'SOLD OUT (Tap to remove from cart)',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Container(
                //   width: double.infinity,
                //   margin: const EdgeInsets.only(top: 8.0),
                //   padding: const EdgeInsets.all(8.0),
                //   color: kTextColor3,
                //   child: Text(
                //     'SOLD OUT',
                //     style: kTextStyle1.copyWith(
                //       fontSize: 12.0,
                //       fontWeight: FontWeight.w600,
                //       color: Colors.white,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
              ] else if (ctrl.invalidPackages.containsKey(data.id) && ctrl.invalidPackages[data.id]?.soldout == 0 && ctrl.invalidPackages[data.id]?.exceedPurchase == 1) ...[
                ElevatedButton(
                  onPressed: () async {
                    final x = ctrl.set(data.package, ctrl.invalidPackages[data.id]?.recommendedQuantity ?? 0);
                    if (x != null) {
                      String userMode = await AuthManager.instance.getUserMode();
                      UserDataManager.instance.updateCart(userMode, data.package.packageId, x);
                      load.call();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kTextColor3,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 32.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  ),
                  child: Text(
                    '${ctrl.invalidPackages[data.id]?.recommendedQuantity} left (Tap to set to ${ctrl.invalidPackages[data.id]?.recommendedQuantity})',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Container(
                //   width: double.infinity,
                //   margin: const EdgeInsets.only(top: 8.0),
                //   padding: const EdgeInsets.all(8.0),
                //   color: kTextColor3,
                //   child: Text(
                //     'EXCEEDED PURCHASE (SUGGESTED ${ctrl.invalidPackages[data.id]?.recommendedQuantity})',
                //     style: kTextStyle1.copyWith(
                //       fontSize: 12.0,
                //       fontWeight: FontWeight.w600,
                //       color: Colors.white,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
              ] else if (ctrl.invalidPackages.containsKey(data.id) && ctrl.invalidPackages[data.id]?.expired == 1) ...[
                ElevatedButton(
                  onPressed: () async {
                    ctrl.delete(data);
                    String userMode = await AuthManager.instance.getUserMode();
                    UserDataManager.instance.removeFromCart(userMode, data.package.packageId);
                    load.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kTextColor3,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 32.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  ),
                  child: Text(
                    'EXPIRED (Tap to remove from cart)',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class CartInput extends StatefulWidget {

  final MyCartItem data;
  final void Function(MyCartItem) onAdd;
  final void Function(MyCartItem) onMinus;
  final void Function(MyCartItem) onDelete;

  const CartInput({
    super.key,
    required this.data,
    required this.onAdd,
    required this.onMinus,
    required this.onDelete,
  });

  @override
  State<CartInput> createState() => _CartInputState();
}

class _CartInputState extends State<CartInput> {

  int quantity = 0;
  double subtotal = 0;

  @override
  void initState() {
    super.initState();
    quantity = widget.data.quantity;
    subtotal = widget.data.subtotal;
  }

  void onDelete() {
    widget.onDelete.call(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Row(
            children: [
              IconButton(
                onPressed: quantity < 1 ? null : () {
                  setState(() {
                    quantity--;
                    subtotal = widget.data.package.packagePrice * quantity;
                  });
                  widget.onMinus.call(widget.data);
                },
                splashRadius: 24.0,
                icon: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
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
              Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: kTextColor4,
                ),
              ),
              const SizedBox(width: 8.0),
              IconButton(
                onPressed: quantity >= widget.data.package.availableToPurchase ? null : () {
                  setState(() {
                    quantity++;
                    subtotal = widget.data.package.packagePrice * quantity;
                  });
                  widget.onAdd.call(widget.data);
                },
                splashRadius: 24.0,
                icon: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: quantity >= widget.data.package.availableToPurchase ? const Color(0xFFDBDBDB).withValues(alpha: 0.3) : kSecondaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 16.0,
                      color: quantity >= widget.data.package.availableToPurchase ? const Color(0xFFB1B1B1) : kPrimaryColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: onDelete,
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
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'RM ${formatPrice(subtotal)}',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
              color: kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class NoCart extends StatelessWidget {

  const NoCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/imgs/empty-cart.png',
            width: 96.0,
            height: 96.0,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Your cart is currently empty.',
            style: kTextStyle1.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(0, 0, 0, 0.2),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}