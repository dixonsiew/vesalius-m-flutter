import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/package_image.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/health-package/my_cart_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/health_package_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/package_data.dart';
import 'package:vesalius_m_flutter/models/user_data_manager.dart';
import 'package:vesalius_m_flutter/services/guest_service.dart';
import 'package:vesalius_m_flutter/services/package_service.dart';
import 'package:vesalius_m_flutter/ui/health-package/health_package_ext.dart';

import 'my_cart.dart';

class HealthPackageDetail extends StatefulWidget {

  final Package data;

  const HealthPackageDetail({
    super.key,
    required this.data,
  });

  @override
  State<HealthPackageDetail> createState() => _HealthPackageDetailState();
}

class _HealthPackageDetailState extends State<HealthPackageDetail> {

  final HealthPackageDetailCtrl ctrl = Get.put(HealthPackageDetailCtrl());
  final MyCartCtrl myCartCtrl = Get.put(MyCartCtrl());

  @override
  initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      if (AuthManager.instance.isLogin) {
        final o = await PackageService.getPackageStatus(widget.data.packageId);
        if (o != null) {
          ctrl.setExpired(o.expired);
          ctrl.setSoldout(o.soldout);
          ctrl.setAvailableToPurchase(o.availableToPurchase);
          widget.data.availableToPurchase = o.availableToPurchase;
        }
      }
      
      else {
        final o = await GuestModeService.getPackageStatus(widget.data.packageId);
        if (o != null) {
          ctrl.setExpired(o.expired);
          ctrl.setSoldout(o.soldout);
          ctrl.setAvailableToPurchase(o.availableToPurchase);
          widget.data.availableToPurchase = o.availableToPurchase;
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

  void showSuccess() {
    Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/icon/tick.png',
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Added to cart',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Done',
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    ));
  }

  String get btnText {
    String s = 'Add To Cart';
    if (ctrl.expired == 1) {
      s = 'Expired';
    }

    if (ctrl.soldout == 1) {
      s = 'Sold Out';
    }

    return s;
  }

  bool get isDisableBtnRemove {
    return ctrl.count < 1 || ctrl.expired == 1 || ctrl.soldout == 1;
  }

  bool get isDisableBtnAdd {
    return ctrl.expired == 1 || ctrl.soldout == 1 || (ctrl.count >= ctrl.availableToPurchase && ctrl.availableToPurchase > 0);
  }

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PackageImage(
                    img: widget.data.packageImage,
                    width: double.infinity,
                    height: 375.0,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      widget.data.packageName,
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
                      'RM ${formatPrice(widget.data.packagePrice)}',
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
                      widget.data.packageDesc.replaceAll('*', '• '),
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor4,
                      ),
                    ),
                  ),
                  if (widget.data.packageTnc != null) ...[
                    const SizedBox(height: 24.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'TERMS & CONDITIONS',
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
                        widget.data.packageTnc!.replaceAll('*', '• '),
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    if (widget.data.packageExtLink != null && (widget.data.packageExtLink?.isNotEmpty ?? false)) ...[
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: AppElevatedButton(
                          text: 'View Website',
                          onPressed: () {
                            Get.to(() => HealthPackageExt(link: widget.data.packageExtLink!));
                          },
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 16.0, bottom: 16.0),
            child: Row(
              children: [
                Obx(() =>
                  IconButton(
                    onPressed: isDisableBtnRemove ? null : () {
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
                          color: isDisableBtnRemove ? kColor1.withValues(alpha: 0.3) : kSecondaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.remove,
                            size: 16.0,
                            color: isDisableBtnRemove ? kColor2 : kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Obx(() =>
                  Text(
                    ctrl.expired == 1 || ctrl.soldout == 1 ? '0' : '${ctrl.count}',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor4,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Obx(() =>
                  IconButton(
                    onPressed: isDisableBtnAdd ? null : () {
                      int c = ctrl.count;
                      ctrl.setCount(++c);
                    },
                    splashRadius: 28.0,
                    icon: Container(
                      width: 32.0,
                      height: 32.0,
                      decoration: BoxDecoration(
                        color: isDisableBtnAdd? kColor1.withValues(alpha: 0.3) : kSecondaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          size: 16.0,
                          color: isDisableBtnAdd ? kColor2 : kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width:34.0),
                Expanded(
                  child: Obx(() =>
                    ctrl.isLoading ? Container() :
                    AppElevatedButton(
                      text: btnText,
                      onPressed: ctrl.expired == 1 || ctrl.soldout == 1 ? null : () async {
                        if (ctrl.count > 0) {
                          final x = myCartCtrl.add(widget.data, ctrl.count);
                          if (x != null) {
                            String userMode = await AuthManager.instance.getUserMode();
                            await UserDataManager.instance.updateCart(userMode, widget.data.packageId, x);
                            ctrl.setCount(1);
                            showSuccess();
                          }
                        }
                      },
                    ),
                  ),
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
      title: 'Health Packages',
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
                        '${myCartCtrl.cartQuantity}',
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