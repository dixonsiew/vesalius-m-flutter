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
import 'package:vesalius_m_flutter/services/guest_service.dart';
import 'package:vesalius_m_flutter/services/package_service.dart';
// import 'package:vesalius_m_flutter/ui/health_package_web.dart';

import 'health-package/health_package_detail.dart';
import 'health-package/my_cart.dart';

class HealthPackage extends StatefulWidget {

  const HealthPackage({super.key});

  @override
  State<HealthPackage> createState() => _HealthPackageState();
}

class _HealthPackageState extends State<HealthPackage> {

  late ScrollController scr;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final HealthPackageCtrl ctrl = Get.put(HealthPackageCtrl());
  final MyCartCtrl myCartCtrl = Get.put(MyCartCtrl());

  @override
  void initState() {
    super.initState();
    scr = ScrollController();
    scr.addListener(scrollListener);
    load();
  }

  @override
  void dispose() {
    scr.removeListener(scrollListener);
    scr.dispose();
    super.dispose();
  }

  void scrollListener() {
    final nextPageTrigger = 0.8 * scr.position.maxScrollExtent;
    if (scr.position.pixels > nextPageTrigger) {
      loadMore();
    }
  }

  void load() async {
    try {
      ctrl.init();
      ctrl.setIsLoading(true);
      if (AuthManager.instance.isLogin) {
        List<Package> lx = await PackageService.getAllPackages(ctrl.page, kPageSize);
        ctrl.setList(lx);
      }

      else {
        List<Package> lx = await GuestModeService.getAllPackages(ctrl.page, kPageSize);
        ctrl.setList(lx);
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

  void loadMore() async {
    int p = ctrl.page + 1;
    try {
      if (ctrl.isLoadingMore) return;
      ctrl.setIsLoadingMore(true);
      if (AuthManager.instance.isLogin) {
        List<Package> lx = await PackageService.getAllPackages(p, kPageSize);
        if (lx.isEmpty) {
          ctrl.setIsLoadingMore(false);
          return;
        }

        ctrl.setPage(p);
        ctrl.setList(lx);
      }

      else {
        List<Package> lx = await GuestModeService.getAllPackages(p, kPageSize);
        if (lx.isEmpty) {
          ctrl.setIsLoadingMore(false);
          return;
        }

        ctrl.setPage(p);
        ctrl.setList(lx);
      }
      
      ctrl.setIsLoadingMore(false);
    }
    
    on DioException catch (error) {
      ctrl.setIsLoadingMore(false);
      handleLoadError(error, loadMore);
    }

    catch (error) {
      ctrl.setIsLoadingMore(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  Widget buildContent() {
    if (!ctrl.isLoading && ctrl.list.isEmpty) {
      return Container();
    }

    return Scrollbar(
      controller: scr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: GridView.builder(
          controller: scr,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: ctrl.list.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 32.0,
            mainAxisSpacing: 24.0,
            mainAxisExtent: 220.0,
          ),
          itemBuilder: (context, i) {
            if (i == ctrl.list.length) {
              return Obx(() => ctrl.isLoadingMore ? const AppLoadMoreIndicator() : Container());
            }
            
            final o = ctrl.list[i];
            return PackageItem(key: ValueKey(o.packageId), data: o);
          },
        /* GridView(
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
          ], */
        ),
      ),
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
            child: RefreshIndicator(
              key: refreshIndicatorKey,
              onRefresh: onRefresh,
              color: kPrimaryColor,
              child: buildContent(),
            ),
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

class PackageItem extends StatelessWidget {

  final Package data;

  const PackageItem({
    super.key, 
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148.0,
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
            Get.to(() => HealthPackageDetail(data: data));
            // Get.to(() => const HealthPackageWeb());
          },
          borderRadius: BorderRadius.circular(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
                child: PackageImage(
                  img: data.packageImage,
                  width: 148.0,
                  height: 148.0,
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  data.packageName,
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: kTextColor4,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 14.0),
                child: Text(
                  'RM ${formatPrice(data.packagePrice)}',
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