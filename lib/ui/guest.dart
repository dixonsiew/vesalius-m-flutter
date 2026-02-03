import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/package_image.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/guest_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/health-package/my_cart_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/package_data.dart';
import 'package:vesalius_m_flutter/models/user_data_manager.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';
import 'package:vesalius_m_flutter/services/common_service.dart';
import 'package:vesalius_m_flutter/services/guest_service.dart';
import 'package:vesalius_m_flutter/services/public_service.dart';

import 'health-package/health_package_detail.dart';
import 'health_package.dart';
import 'home/notifications.dart';
import 'home.dart';
import 'services/doctor.dart';
import 'services/golden_pearl.dart';
import 'services/hospital.dart';
import 'services/little_explorer.dart';
import 'services/way_finding2.dart';
import 'sign_in.dart';
import 'sign_up.dart';

class Guest extends StatefulWidget {
  
  static const String routeName = '/Guest';

  const Guest({super.key});

  @override
  State<Guest> createState() => _GuestState();
}

class _GuestState extends State<Guest> with WidgetsBindingObserver {

  String deviceId = '';
  UserBranch? branch;
  ScrollController scr = ScrollController();
  late final TextEditingController searchController;
  static const AndroidId androidIdPlugin = AndroidId();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  final GuestCtrl ctrl = Get.put(GuestCtrl());
  final MyCartCtrl myCartCtrl = Get.put(MyCartCtrl());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    searchController = TextEditingController();
    load();
    loadCart();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scr.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final String s = AuthManager.instance.getPlayerId();
      GuestModeService.getUnseenCount(s).then((value) {
        ctrl.setUnseenCount(value);
      });
    }
  }

  void load() async {
    try {
      if (Platform.isAndroid) {
        deviceId = await androidIdPlugin.getId() ?? '';
      }

      else {
        final IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
        deviceId = data.identifierForVendor ?? '';
      }
    } on PlatformException catch (_) {}

    try {
      await AuthManager.instance.waitPlayerId();
      UserService.postPlayerID({
        'playerId': AuthManager.instance.playerId,
        'machineId': deviceId
      }).then((value) {
        GuestModeService.getUnseenCount(AuthManager.instance.playerId).then((value) {
          ctrl.setUnseenCount(value);
        });
      });
      
      ctrl.setIsLoading1(true);
      /* CommonService.getGuestModeServices().then((value) {
        ctrl.setListService(value);
        final purchase = value.firstWhereOrNull((x) => x.name == 'PurchaseAndPayment');
        ctrl.setPurchase(purchase == null ? kPurchase : true);
        ctrl.setIsLoading1(false);
      }).onError((error, stackTrace) {
        ctrl.setIsLoading1(false);
        if (error is DioException) {
          handleLoadError(error, load);
        }
      }).catchError((error) {
        ctrl.setIsLoading1(false);
        showCustomDialog('Error', error.toString(), 'Dismiss');
      }); */

      final la = await CommonService.getGuestModeServices();
      final purchase = la.firstWhereOrNull((x) => x.name == 'PurchaseAndPayment');
      ctrl.setPurchase(purchase == null ? kPurchase : true);
      la.removeWhere((x) => x.isConfig);
      ctrl.setListService(la);
      ctrl.setIsLoading1(false);

      if (ctrl.purchase) {
        ctrl.setIsLoading2(true);
        GuestModeService.getAllPackages(1, 5, 1).then((value) {
          ctrl.setList(value);
          ctrl.setIsLoading2(false);
        }).onError((error, stackTrace) {
          ctrl.setIsLoading2(false);
          if (error is DioException) {
            handleLoadError(error, load);
          }
        }).catchError((error) {
          ctrl.setIsLoading2(false);
          showCustomDialog('Error', error.toString(), 'Dismiss');
        });
      }

      else {
        ctrl.setList([]);
      }
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

  void load000() async {
    try {
      if (Platform.isAndroid) {
        deviceId = await androidIdPlugin.getId() ?? '';
      }

      else {
        final IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
        deviceId = data.identifierForVendor ?? '';
      }
    } on PlatformException catch (_) {}

    try {
      ctrl.setIsLoading(true);
      await AuthManager.instance.waitPlayerId();
      UserService.postPlayerID({
        'playerId': AuthManager.instance.playerId,
        'machineId': deviceId
      });
      final lw = <Future<dynamic>>[
        GuestModeService.getUnseenCount(AuthManager.instance.playerId),
        CommonService.getGuestModeServices(),
      ];
      if (ctrl.purchase) {
        lw.add(GuestModeService.getAllPackages(1, 5, 1));
      }

      final lr = await Future.wait<dynamic>(lw);
      int n = lr[0];
      final lx = lr[1];
      ctrl.setUnseenCount(n);
      ctrl.setListService(lx);
      if (ctrl.purchase) {
        List<Package> lx = lr[2];
        ctrl.setList(lx);
      }

      else {
        ctrl.setList([]);
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

  Future<void> loadCart() async {
    String? userMode = await AuthManager.instance.getUserMode();
    final res = await UserDataManager.instance.getMyCartList(userMode);
    myCartCtrl.setCartList(res);
  }

  String get greetings {
    int h = DateTime.now().hour;
    String s = 'Good';
    String b = 'Night';
    if (h < 12) {
      b = 'Morning';
    }

    else if (h >= 12 && h < 17) {
      b = 'Afternoon';
    }

    else if (h >= 17 && h <= 19) {
      b = 'Evening';
    }

    return '$s $b';
  }

  String get ncount {
    String s = '';
    int v = ctrl.unseencount;
    if (v > 0) {
      if (v < 100) {
        s = '$v';
      }

      else {
        s = '99+';
      }
    }

    return s;
  }

  bool get isMobile {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    bool useMobileLayout = shortestSide < 600;
    return useMobileLayout;
  }

  double get itemSpacing {
    if (isMobile) {
      double w = MediaQuery.of(context).size.width - 32;
      double v = 300;
      double k = (w - v) / 4;
      return k / 2;
    }

    double w = MediaQuery.of(context).size.width - 32;
    double v = 300;
    double k = (w - v) / 4;
    return k;
  }

  Widget buildBranchItem(UserBranch o) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            o.branchName ?? '',
            style: TextStyle(
              color: branch?.branchName == o.branchName ? kPrimaryColor : Colors.black,
              fontSize: 16.0,
              fontFamily: kBodyFont,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        branch?.branchName == o.branchName ?
        const Icon(
          Icons.check,
          color: kPrimaryColor,
          size: 24.0,
        ) :
        const SizedBox(width: 24.0, height: 24.0),
      ],
    );
  }

  List<Widget> buildBranchList(List<UserBranch> lx, void Function(void Function()) setState) {
    List<Widget> ls = [];
    for (int i = 0; i < lx.length; i++) {
      Widget w;
      UserBranch o = lx[i];

      if (i == 0) {
        w = Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                branch = o;
              });
            },
            child: buildBranchItem(o),
          ),
        );
      }

      else {
        w = Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 25.0),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                branch = o;
              });
            },
            child: buildBranchItem(o),
          ),
        );
      }

      ls.add(w);
    }

    return ls;
  }

  Future<void> selectBranch(List<UserBranch> lx) async {
    UserBranch? o = await Get.dialog(StatefulBuilder(
      builder: (context, setState) => CupertinoAlertDialog(
        title: const Text(
          'Select Hospital',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: kBodyFont,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20.0, bottom: 15.0),
                width: double.infinity,
                height: 1.0,
                color: kColor5,
              ),
        
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: buildBranchList(lx, setState),
              ),
            ],
          ),
        ),
        actions: [
          CupertinoButton(
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 18.0,
                fontFamily: kBodyFont,
              ),
            ),
            onPressed: () => Get.back(),
          ),
          CupertinoButton(
            child: const Text(
              'OK',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 18.0,
                fontFamily: kBodyFont,
                fontWeight: FontWeight.bold,
              ),
            ), 
            onPressed: () => Get.back(result: branch),
          ),
        ],
      )),
    );
    if (o != null) {
      await DataManager.instance.setBranchDetails(o);
    }
  }

  void onPopInvokedWithResult(bool didPop, result) async{
    if (didPop) return;
    bool b = await showConfirmDialog('Are you sure you want to exit ?');
    if (b) {
      SystemNavigator.pop();
    }
  }

  Widget buildSearch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: kColor6.withValues(alpha: 0.21),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        autofocus: false,
        cursorColor: kPrimaryColor,
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          fontFamily: kBodyFont,
          fontSize: 16.0,
          color: kTextColor1,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search By Speciality, Doctor Name',
          hintStyle: kTextStyle1.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: kTextColor5,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 15.0),
            child: Icon(
              Icons.search,
              color: kPrimaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(color: kColor6.withValues(alpha: 0.21)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(color: kColor6.withValues(alpha: 0.21)),
          ),
        ),
        onSubmitted: (value) => Get.to(() => Doctor(keyword: value)),
      ),
    );
  }

  List<Widget> buildServices() {
    if (ctrl.listService.isEmpty) return [];
    int n = 8 - ctrl.listService.length;
    List<Widget> lx = ctrl.listService.map((x) => ServiceItem(
      image: x.image, 
      title: x.name.replaceAll('\\n', '\n'), 
      width: x.image == 'way-find.png' ? 22.0 : 24.0,
      height: x.image == 'way-find.png' ? 22.0 : 24.0,
      onTap: () async {
        if (x.image == 'doctor-information.png') {
          UserBranch? branch = DataManager.instance.branchDetails;
          if (branch == null) {
            final lx = await PublicVesaliusService.getPublicBranchList();
            if (lx.length > 1) {
              await selectBranch(lx);
            }

            else {
              await DataManager.instance.setBranchDetails(lx[0]);
            }
          }
          Get.to(() => const Doctor());
        }

        else if (x.image == 'hospital-information.png') {
          Get.to(() => const Hospital());
        }

        else if (x.image == 'little-explorer.png') {
          Get.to(() => const LittleExplorer());
        }

        else if (x.image == 'golden-pearl.png') {
          Get.to(() => const GoldenPearl());
        }

        else if (x.image == 'way-find.png') {
          Get.to(() => const WayFinding2());
        }
      },
    )).toList();
    for (int i = 0; i < n; i++) {
      lx.add(
        ServiceItem(image: '', title: '', onTap: () {  }),
      );
    }

    return lx;
  }

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 110.0),
          child: Scrollbar(
            controller: scr,
            child: ListView(
              controller: scr,
              shrinkWrap: true,
              children: [
                const SizedBox(height: 14.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        greetings,
                        style: kTextStyle1.copyWith(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor,
                        ),
                      ),
                      IconButton(
                        onPressed:() {
                          Get.to(() => const Notifications());
                        },
                        icon: Obx(() =>
                          ctrl.unseencount > 0 ? Stack(
                            children: [
                              Image.asset(
                                'images/imgs/bell0.png',
                                width: 28.0,
                                height: 28.0,
                                fit: BoxFit.contain,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: kTextColor3,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    ncount,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ) :
                          Image.asset(
                            'images/imgs/bell0.png',
                            width: 28.0,
                            height: 28.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                        padding: const EdgeInsets.all(2.0), 
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 16.5),
                              Text(
                                'Sign Up Now!',
                                style: kTextStyle1.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Sign up an account to enjoy more features.',
                                style: kTextStyle1.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: kPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 16.5),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Image.asset(
                            'images/imgs/guest.png',
                            width: 118.0,
                            height: 73.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                buildSearch(),
                const SizedBox(height: 32.0),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                  child: Text(
                    'Services',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: kTextColor1,
                    ),
                  ),
                ),
                Obx(() => ctrl.isLoading1 ? const AppLoadMoreIndicator() :
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: 210.0,
                    child: PageView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Wrap(
                          spacing: itemSpacing,
                          alignment: WrapAlignment.spaceEvenly,
                          runAlignment: WrapAlignment.start,
                          children: buildServices(),
                          
                          // [
                          //   ServiceItem(
                          //     image: 'doctor-information.png',
                          //     title: 'Doctor\nInformation',
                          //     onTap: () async {
                          //       UserBranch? branch = DataManager.instance.branchDetails;
                          //       if (branch == null) {
                          //         final lx = await PublicVesaliusService.getPublicBranchList();
                          //         if (lx.length > 1) {
                          //           await selectBranch(lx);
                          //         }
            
                          //         else {
                          //           await DataManager.instance.setBranchDetails(lx[0]);
                          //         }
                          //       }
                          //       Get.to(() => const Doctor());
                          //     }
                          //   ),
                          //   ServiceItem(
                          //     image: 'hospital-information.png',
                          //     title: 'Hospital\nInformation',
                          //     onTap: () {
                          //       Get.to(() => const Hospital());
                          //     }
                          //   ),
                          // ],
                        ),
                      ],
                    ),
                  ),
                )),
                if (ctrl.list.isNotEmpty && !ctrl.isLoading2) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Our Packages',
                          style: kTextStyle1.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: kTextColor1,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const HealthPackage());
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: kPrimaryColor,
                          ),
                          child: Text(
                            'See More',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: 214.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: ctrl.list.length,
                        itemBuilder: (context, i) {
                          return PackageItem(
                            data: ctrl.list[i],
                            isLast: i == ctrl.list.length - 1,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ] else if (ctrl.isLoading2) ...[
                  const AppLoadMoreIndicator(),
                ],
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: kBgColor1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AppElevatedButton(
                    text: 'Sign Up',
                    onPressed: () {
                      Get.to(() => const SignUp());
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already an existing user? ',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor2,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.off(() => const SignIn());
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: kPrimaryColor,
                      ),
                      child: Text(
                        'Sign In',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
          toolbarHeight: 0.0,
          backgroundColor: kBgColor1,
          elevation: 0.0,
        ),
        backgroundColor: kBgColor1,
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
      ),
    );
  }
}

class PackageItem extends StatelessWidget {

  final Package data;
  final bool isLast;

  const PackageItem({
    super.key,
    required this.data,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148.0,
      height: 210.0,
      margin: isLast ? EdgeInsets.zero : const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: () {
            Get.to(() => HealthPackageDetail(data: data));
          },
          borderRadius: BorderRadius.circular(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
                child: PackageImage(
                  img: data.packageImage,
                  width: 148.0,
                  height: 148.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                child: Text(
                  data.packageName,
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: kTextColor1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 10.0),
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