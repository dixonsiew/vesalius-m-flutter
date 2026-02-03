import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_image.dart';
import 'package:vesalius_m_flutter/components/package_image.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/upcoming_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/home_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart' as dx;
import 'package:vesalius_m_flutter/models/package_data.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/service_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';
import 'package:vesalius_m_flutter/services/common_service.dart';
import 'package:vesalius_m_flutter/services/notification_service.dart';
import 'package:vesalius_m_flutter/services/package_service.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';
import 'package:vesalius_m_flutter/ui/health_package.dart';
import 'package:vesalius_m_flutter/ui/home/notifications.dart';
import 'package:vesalius_m_flutter/ui/services/outpatient_bill.dart';
// import 'package:vesalius_m_flutter/ui/services/inpatient_journey.dart';
// import 'package:vesalius_m_flutter/ui/services/patient_education.dart';
// import 'package:vesalius_m_flutter/ui/services/prescription_request.dart';

import 'appointment/appointment_detail.dart';
import 'health-package/health_package_detail.dart';
import 'services/doctor.dart';
import 'services/feedback_ih.dart';
import 'services/golden_pearl.dart';
import 'services/hospital.dart';
import 'services/little_explorer.dart';
import 'services/logistic_arrangement.dart';
import 'services/medical_history.dart';
import 'services/my_family.dart';
import 'services/queue_tracker.dart';
import 'services/upcoming_tests.dart';
import 'services/way_finding2.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home>, WidgetsBindingObserver {

  UserBranch? branch;
  ScrollController scr = ScrollController();
  late final TextEditingController txtsearch;

  final HomeCtrl ctrl = Get.put(HomeCtrl());
  final UpcomingAppointmentCtrl upcomingAppointmentCtrl = Get.put(UpcomingAppointmentCtrl());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    txtsearch = TextEditingController();
    load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scr.dispose();
    txtsearch.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      NotificationService.getUnseenCount().then((value) {
        ctrl.setUnseenCount(value);
      });
    }
  }

  void load() async {
    try {
      await AuthManager.instance.load();

      NotificationService.getUnseenCount().then((value) {
        ctrl.setUnseenCount(value);
      });
      ctrl.setIsLoading1(true);
      /* CommonService.getAuthModeServices().then((value) {
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

      final la = await CommonService.getAuthModeServices();
      final purchase = la.firstWhereOrNull((x) => x.name == 'PurchaseAndPayment');
      ctrl.setPurchase(purchase == null ? kPurchase : true);
      la.removeWhere((x) => x.isConfig);
      ctrl.setListService(la);
      ctrl.setIsLoading1(false);

      if (ctrl.purchase) {
        ctrl.setIsLoading2(true);
        PackageService.getAllPackages(1, 5, 1).then((value) {
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

      ctrl.setIsLoading3(true);
      PatientDetails? x = await DataManager.instance.getPatientDetails();
      UserBranch? branchDetails = await DataManager.instance.getBranchDetails();
      if (x == null) {
        UserDetails? o = await UserService.getUser();
        if (o != null) {
          await DataManager.instance.setUserDetails(o);
          if (o.userBranches.isNotEmpty) {
            await DataManager.instance.setBranchDetails(o.userBranches.first);
            branchDetails = o.userBranches.first;
            PatientDetails? patientData = await VesaliusService.getVesaliusPatientData(o.userBranches.first.branch!.branchId!, o.userBranches.first.prn!);
            if (patientData != null) {
              await DataManager.instance.setPatientDetails(patientData);
              x = patientData;
              DataManager.instance.setPrn(o.userBranches.first.prn!);
            }
          }
        }
      }

      ctrl.setPatientDetails(x);

      if (branchDetails != null && branchDetails.branch != null && AuthManager.instance.isLogin) {
        // await AppointmentManager.getValidAppointment(branchDetails.branch!.branchId!);
        upcomingAppointmentCtrl.loadSoonest().then((value) {
          ctrl.setIsLoading3(false);
        }).onError((error, stackTrace) {
          ctrl.setIsLoading3(false);
          if (error is DioException) {
            handleLoadError(error, load);
          }
        }).catchError((error) {
          ctrl.setIsLoading3(false);
        });
      }

      else {
        ctrl.setIsLoading3(false);
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
      ctrl.setIsLoading(true);
      await AuthManager.instance.load();
      PatientDetails? x = await DataManager.instance.getPatientDetails();
      UserBranch? branchDetails = await DataManager.instance.getBranchDetails();
      if (x == null) {
        UserDetails? o = await UserService.getUser();
        if (o != null) {
          await DataManager.instance.setUserDetails(o);
          if (o.userBranches.isNotEmpty) {
            await DataManager.instance.setBranchDetails(o.userBranches.first);
            branchDetails = o.userBranches.first;
            PatientDetails? patientData = await VesaliusService.getVesaliusPatientData(o.userBranches.first.branch!.branchId!, o.userBranches.first.prn!);
            if (patientData != null) {
              await DataManager.instance.setPatientDetails(patientData);
              x = patientData;
              DataManager.instance.setPrn(o.userBranches.first.prn!);
            }
          }
        }
      }

      ctrl.setPatientDetails(x);

      final lw = <Future<dynamic>>[
        NotificationService.getUnseenCount(),
        CommonService.getAuthModeServices(),
      ];
      if (ctrl.purchase) {
        lw.add(PackageService.getAllPackages(1, 5, 1));
      }

      if (branchDetails != null && branchDetails.branch != null && AuthManager.instance.isLogin) {
        // await AppointmentManager.getValidAppointment(branchDetails.branch!.branchId!);
        lw.add(upcomingAppointmentCtrl.loadSoonest());
      }

      final lr = await Future.wait<dynamic>(lw);
      int n = lr[0];
      List<AppService> la = lr[1];
      ctrl.setUnseenCount(n);
      ctrl.setListService(la);
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

  String get name {
    return ctrl.patientDetails?.displayName ?? '';
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

    return '$s $b ,';
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

  // String getTime(String s) {
  //   List<String> a = s.split(':');
  //   int hour = int.parse(a[0]);
  //   int min = int.parse(a[1]);
  //   final now = DateTime.now();
  //   final dt = DateTime(now.year, now.month, now.day, hour, min);
  //   return formatDate(dt, [h, ':', nn, ' ', am]);
  // }

  // String getDate(String s) {
  //   return s.replaceAll('-', ' ');
  // }

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

  // String get apptInfo {
  //   String s = '${getDate(ctrl.appointment!.apptDate)}, ${getTime(ctrl.appointment!.apptStartTime)}';
  //   if (ctrl.appointment!.apptSlotType == 'Session') {
  //     String a = getTime(ctrl.appointment!.sessionStartTime!);
  //     String b = getTime(ctrl.appointment!.sessionEndTime!);
  //     s = '${getDate(ctrl.appointment!.apptDate)}, ${ctrl.appointment!.apptSessionType} ($a-$b)';
  //   }

  //   if (ctrl.appointment!.doctorClinicLocation.isNotEmpty) {
  //     List<String> ls = [];
  //     for (int i = 0; i < ctrl.appointment!.doctorClinicLocation.length; i++) {
  //       final loc = ctrl.appointment!.doctorClinicLocation[i];
  //       if (loc.building == null) {
  //         ls.add(loc.location ?? '');
  //       }

  //       else {
  //         ls.add('${loc.location}, ${loc.building}');
  //       }
  //     }

  //     s = '$s\n\n${ls.join("\n")}';
  //   }

  //   return s;
  // }

  List<Widget> buildAppointment() {
    return upcomingAppointmentCtrl.listx.map((x) => AppointmentItem(key: ValueKey(x.apptNo), data: x)).toList();
  }

  List<Widget> buildAppointmentMarker() {
    List<Widget> lx = [];
    for (int i = 0; i < upcomingAppointmentCtrl.listx.length; i++) {
      if (ctrl.currentx == i) {
        final x = Container(
          width: 20.0,
          height: 6.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(50.0),
          ),
        );
        lx.add(x);
      }

      else {
        final x = Container(
          width: 6.0,
          height: 6.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: kColor3,
          ),
        );
        lx.add(x);
      }
    }

    return lx;
  }

  /* List<Widget> buildPackageList() {
    List<Widget> lx = [];
    for (int i = 0; i < ctrl.list.length; i++) {
      final o = ctrl.list[i];
      final x = Container(
        width: 148.0,
        height: 232.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getPackageImage(o.packageImageOri, 148.0, 148.0),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
              child: Text(
                o.packageName,
                style: kTextStyle1.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: kTextColor1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 10.0),
              child: Text(
                'RM ${o.packagePrice.toStringAsFixed(2)}',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      );
      lx.add(x);
      if (i < ctrl.list.length - 1) {
        lx.add(const SizedBox(width: 16.0));
      }
    }

    return lx;
  } */

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
        controller: txtsearch,
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

  int get totalServicePage {
    double v = ctrl.listService.length * 1.00 / 8;
    int total = v.ceil();
    return total;
  }

  List<Widget> buildServices(int page, int lower, int upper) {
    List<Widget> lx = [];
    for (int i = lower; i < upper; i++) {
      final o = ctrl.listService[i];
      double width = 24.0;
      double height = 24.0;
      if (o.image == 'feedback.png' || o.image == 'way-find.png' || o.image == 'investigation-reports.png') {
        width = 22.0;
        height = 22.0;
      }

      else if (o.image == 'outpatient-bill.png') {
        width = 20.0;
        height = 20.0;
      }

      else if (o.image == 'logistic-arrangements.png') {
        width = 26.0;
        height = 19.5;
      }

      lx.add(
        ServiceItem(
          image: o.image, 
          title: o.name.replaceAll('\\n', '\n'), 
          width: width,
          height: height,
          onTap: () {
            if (o.image == 'queue-tracker.png') {
              Get.to(() => const QueueTracker());
            }

            else if (o.image == 'family.png') {
              Get.to(() => const MyFamily());
            }

            else if (o.image == 'doctor-information.png') {
              Get.to(() => const Doctor());
            }

            else if (o.image == 'hospital-information.png') {
              Get.to(() => const Hospital());
            }

            else if (o.image == 'feedback.png') {
              Get.to(() => const FeedbackIH());
            }

            else if (o.image == 'little-explorer.png') {
              Get.to(() => const LittleExplorer());
            }

            else if (o.image == 'golden-pearl.png') {
              Get.to(() => const GoldenPearl());
            }

            else if (o.image == 'outpatient-bill.png') {
              Get.to(() => const OutpatientBill());
            }

            else if (o.image == 'upcoming-tests.png') {
              Get.to(() => const UpcomingTests());
            }

            else if (o.image == 'logistic-arrangements.png') {
              Get.to(() => const LogisticArrangement());
            }

            else if (o.image == 'way-find.png') {
              Get.to(() => const WayFinding2());
            }

            else if (o.image == 'investigation-reports.png') {
              Get.to(() => const MedicalHistory());
            }
          },
        )
      );
    }

    int n = 8 - (upper - lower);
    for (int i = 0; i < n; i++) {
      lx.add(
        ServiceItem(image: '', title: '', onTap: () {  }),
      );
    }

    return lx;
  }

  List<Widget> buildPagedServices() {
    if (ctrl.listService.isEmpty) return [];
    int totalPages = totalServicePage;
    List<Widget> lx = [];
    for (int i = 0; i < totalPages; i++) {
      int lower = i * 8;
      int upper = (i + 1) * 8;
      if (ctrl.listService.length < upper) {
        upper = ctrl.listService.length;
      }

      lx.add(
        Wrap(
          spacing: itemSpacing,
          alignment: WrapAlignment.spaceEvenly,
          runAlignment: WrapAlignment.start,
          children: buildServices(i, lower, upper),
        )
      );
    }

    return lx;
  }

  Widget buildContent() {
    return ctrl.isLoading ? Container() : 
    Scrollbar(
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
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greetings,
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor2,
                        ),
                      ),
                      Text(
                        name,
                        style: kTextStyle1.copyWith(
                          fontFamily: kFont2,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
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
          buildSearch(),
          const SizedBox(height: 32.0),
          if (upcomingAppointmentCtrl.countx > 0 && !ctrl.isLoading3) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Upcoming Appointment',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ExpandablePageView(
              physics: const BouncingScrollPhysics(),
              children: buildAppointment(),
              onPageChanged: (int i) {
                ctrl.setCurrentX(i);
              },
            ),
            if (upcomingAppointmentCtrl.countx > 1) ...[
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buildAppointmentMarker(),
              ),
            ],
            const SizedBox(height: 32.0),
          ] else if (ctrl.isLoading3) ...[
            const AppLoadMoreIndicator(),
          ],
          
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
                children: buildPagedServices(),
                
                /* [
                  Wrap(
                    spacing: itemSpacing,
                    alignment: WrapAlignment.spaceEvenly,
                    runAlignment: WrapAlignment.start,
                    children: [
                      ServiceItem(
                        image: 'queue-tracker.png',
                        title: 'Queue\nTracker',
                        onTap: () {
                          Get.to(() => const QueueTracker());
                        }
                      ),
                      ServiceItem(
                        image: 'family.png',
                        title: 'My\nFamily',
                        onTap: () {
                          Get.to(() => const MyFamily());
                        }
                      ),
                      ServiceItem(
                        image: 'doctor-information.png',
                        title: 'Doctor\nInformation',
                        onTap: () {
                          Get.to(() => const Doctor());
                        }
                      ),
                      ServiceItem(
                        image: 'hospital-information.png',
                        title: 'Hospital\nInformation',
                        onTap: () {
                          Get.to(() => const Hospital());
                        }
                      ),
                      ServiceItem(
                        image: 'feedback.png',
                        title: 'Feedback\n',
                        width: 22.0,
                        height: 22.0,
                        onTap: () {
                          Get.to(() => const FeedbackIH());
                        }
                      ),
                      ServiceItem(
                        image: 'little-explorer.png',
                        title: "Little Explorers'\nKids Club",
                        onTap: () {
                          Get.to(() => const LittleExplorer());
                        }
                      ),
                      ServiceItem(
                        image: 'golden-pearl.png',
                        title: 'Golden Pearl\nClub',
                        onTap: () {
                          Get.to(() => const GoldenPearl());
                        }
                      ),
                      ServiceItem(
                        image: 'outpatient-bill.png',
                        title: 'Outpatient\nBill Payment',
                        width: 20.0,
                        height: 20.0,
                        onTap: () {
                          //Get.to(() => const InpatientJourney());
                        }
                      ),
                    ],
                  ), */
                  // GridView.count(
                  //   shrinkWrap: true,
                  //   clipBehavior: Clip.antiAlias,
                  //   crossAxisCount: 4,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   children: [
                  //     ServiceItem(
                  //       image: 'queue-tracker.png',
                  //       title: 'Queue\nTracker',
                  //       onTap: () {
                  //         Get.to(() => const QueueTracker());
                  //       }
                  //     ),
                  //     ServiceItem(
                  //       image: 'family.png',
                  //       title: 'My\nFamily',
                  //       onTap: () {
                  //         Get.to(() => const MyFamily());
                  //       }
                  //     ),
                  //     ServiceItem(
                  //       image: 'doctor-information.png',
                  //       title: 'Doctor\nInformation',
                  //       onTap: () {
                  //         Get.to(() => const Doctor());
                  //       }
                  //     ),
                  //     ServiceItem(
                  //       image: 'hospital-information.png',
                  //       title: 'Hospital\nInformation',
                  //       onTap: () {
                  //         Get.to(() => const Hospital());
                  //       }
                  //     ),
                  //     ServiceItem(
                  //       image: 'feedback.png',
                  //       title: 'Feedback\n',
                  //       width: 22.0,
                  //       height: 22.0,
                  //       onTap: () {
                  //         Get.to(() => const FeedbackIH());
                  //       }
                  //     ),
                  //     ServiceItem(
                  //       image: 'little-explorer.png',
                  //       title: "Little Explorers'\nKids Club",
                  //       onTap: () {
                  //         Get.to(() => const LittleExplorer());
                  //       }
                  //     ),
                  //     ServiceItem(
                  //       image: 'golden-pearl.png',
                  //       title: 'Golden Pearl\nClub',
                  //       onTap: () {
                  //         Get.to(() => const GoldenPearl());
                  //       }
                  //     ),
                  //     ServiceItem(
                  //       image: 'outpatient-bill.png',
                  //       title: 'Outpatient\nBill Payment',
                  //       width: 20.0,
                  //       height: 20.0,
                  //       onTap: () {
                  //         //Get.to(() => const InpatientJourney());
                  //       }
                  //     ),
      
                  //     /* ServiceItem(
                  //       image: 'inpatient-journey.png',
                  //       title: 'Inpatient\nJourney',
                  //       onTap: () {
                  //         Get.to(() => const InpatientJourney());
                  //       }
                  //     ),
                  //     ServiceItem(
                  //       image: 'medical-history.png',
                  //       title: 'Medical\nHistory',
                  //       onTap: () {
                  //         Get.to(() => const MedicalHistory());
                  //       }
                  //     ),
                      
                  //     ServiceItem(
                  //       image: 'prescription-request.png',
                  //       title: 'Prescription\nRequest',
                  //       height: 23.93,
                  //       onTap: () {
                  //         Get.to(() => const PrescriptionRequest());
                  //       }
                  //     ), */
                      
                  //   ],
                  // ),

                  /* Wrap(
                    spacing: itemSpacing,
                    alignment: WrapAlignment.spaceEvenly,
                    runAlignment: WrapAlignment.start,
                    children: [
                      ServiceItem(
                        image: 'way-find.png',
                        title: 'Way\nFinding',
                        width: 22.0,
                        height: 22.0,
                        onTap: () {
                          //Get.to(() => const PatientEducation());
                        }
                      ),
                      ServiceItem(
                        image: 'investigation-reports.png',
                        title: 'Investigation\nReports',
                        width: 22.0,
                        height: 22.0,
                        onTap: () {
                          Get.to(() => const InpatientJourney());
                        }
                      ),
                      ServiceItem(
                        image: 'upcoming-tests.png',
                        title: 'Upcoming\nTests',
                        onTap: () {
                          Get.to(() => const UpcomingTests());
                        }
                      ),
                      ServiceItem(
                        image: 'logistic-arrangements.png',
                        title: 'Logistics\nArrangements',
                        width: 26.0,
                        height: 19.5,
                        onTap: () {
                          Get.to(() => const LogisticArrangement());
                        }
                      ),
                    ],
                  ), */
      
                  // GridView.count(
                  //   shrinkWrap: true,
                  //   clipBehavior: Clip.antiAlias,
                  //   crossAxisCount: isMobile ? 4 : 8,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   children: [
                  //     ServiceItem(
                  //       image: 'way-find.png',
                  //       title: 'Way\nFinding',
                  //       width: 22.0,
                  //       height: 22.0,
                  //       onTap: () {
                  //         //Get.to(() => const PatientEducation());
                  //       }
                  //     ),
                  //     ServiceItem(
                  //       image: 'investigation-reports.png',
                  //       title: 'Investigation\nReports',
                  //       width: 22.0,
                  //       height: 22.0,
                  //       onTap: () {
                  //         Get.to(() => const InpatientJourney());
                  //       }
                  //     ),
                  //     ServiceItem(
                  //       image: 'upcoming-tests.png',
                  //       title: 'Upcoming\nTests',
                  //       onTap: () {
                  //         Get.to(() => const UpcomingTests());
                  //       }
                  //     ),
                  //     ServiceItem(
                  //       image: 'logistic-arrangements.png',
                  //       title: 'Logistics\nArrangements',
                  //       width: 26.0,
                  //       height: 19.5,
                  //       onTap: () {
                  //         // Get.to(() => const LogisticArrangement());
                  //       }
                  //     ),
      
                  //     /* ServiceItem(
                  //       image: 'patient-education.png',
                  //       title: 'Patient\nEducation',
                  //       onTap: () {
                  //         Get.to(() => const PatientEducation());
                  //       }
                  //     ), */
                  //   ],
                  // ),
                //],
                onPageChanged: (int i) {
                  ctrl.setCurrent(i);
                },
              ),
            ),
          )),
          if (totalServicePage > 1) ...[
            Obx(() =>
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<int>.generate(totalServicePage, (i) => i).map((i) {
                  if (ctrl.current == i) {
                    return Container(
                      width: 20.0,
                      height: 6.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    );
                  }
            
                  return Container(
                    width: 6.0,
                    height: 6.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kColor3,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() =>
      ModalProgressHUD(
        inAsyncCall: ctrl.isLoading,
        blur: kBlur,
        progressIndicator: const AppActivityIndicator(),
        child: buildContent(),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class ServiceItem extends StatelessWidget {

  final String image;
  final String title;
  final double width;
  final double height;
  final void Function() onTap;

  const ServiceItem({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
    this.width = 24.0,
    this.height = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    if (image == '') {
      return const SizedBox(
        width: 75.0,
        height: 100.0,
      );
    }
    
    return SizedBox(
      width: 75.0,
      height: 100.0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 48.0,
                height: 48.0,
                decoration: const BoxDecoration(
                  color: kColor7,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'images/imgs/$image',
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
              Flexible(
                child: Text(
                  title,
                  style: kTextStyle1.copyWith(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppointmentItem extends StatelessWidget {

  final PatientAppointment data;

  const AppointmentItem({
    super.key,
    required this.data,
  });

  String getTime(String s) {
    final ts = '2023-01-01T$s:00';
    return formatDate(DateTime.parse(ts), [h, ':', nn, ' ', am]).toUpperCase();
  }

  String getDate(String s) {
    return s.replaceAll('-', ' ');
  }

  String get apptDate {
    String s = '${getDate(data.apptDate)}, ${getTime(data.apptStartTime)}';
    if (data.apptSlotType == 'Session') {
      String a = getTime(data.sessionStartTime!);
      String b = getTime(data.sessionEndTime!);
      s = '${getDate(data.apptDate)}, ${data.apptSessionType} ($a-$b)';
    }

    return s;
  }

  List<Widget> buildDoctorContent() {
    List<dx.DoctorSpecialities>? specialtyList = data.doctorSpecialities;

    List<Widget> ls = [
      Text(
        data.name?.trim() ?? '',
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 8.0),
    ];

    for (int i = 0; i < specialtyList.length; i++) {
      Widget w = Text(
        specialtyList[i].toString(),
        style: kTextStyle1.copyWith(
          fontSize: 10.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
      ls.addAll([w, const SizedBox(height: 8.0)]);
    }

    ls.removeLast();
    return ls;
  }

  Widget buildPackageItem() {
    return Row(
      children: [
        const SizedBox(width: 16.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: PackageImage(
            img: data.apptPackageImage,
            width: 48.0,
            height: 48.0,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.apptPackagePurchaseNo ?? '-',
                style: kTextStyle1.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                data.apptPackageName ?? '-',
                style: kTextStyle1.copyWith(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Image.asset(
          'images/icon/right.png',
          width: 16.0,
          height: 16.0,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 16.0),
      ],
    );
  }

  Widget buildDoctorItem() {
    return Row(
      children: [
        const SizedBox(width: 16.0),
        ClipOval(
          child: SizedBox.fromSize(
            size: const Size.fromRadius(24.0),
            child: DoctorImage(img: data.image),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildDoctorContent(),
          ),
        ),
        Image.asset(
          'images/icon/right.png',
          width: 16.0,
          height: 16.0,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 16.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: kColor24.withValues(alpha: 0.7),
            blurRadius: 7.0,
          ),
        ],
      ),
      child: Material(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: () {
            Get.to(() => AppointmentDetail(patientAppointment: data));
          },
          borderRadius: BorderRadius.circular(5.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.apptPackagePurchaseNo != null) ...[
                  buildPackageItem(),
                ] else ...[
                  buildDoctorItem(),
                ],
                if (data.apptPatientName != 'Self') ...[
                  const SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: kColor26.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      data.apptPatientName ?? '',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                ] else ...[
                  const SizedBox(height: 16.0),
                ],

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: kColor26.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'images/icon/clock.png',
                        width: 14.0,
                        height: 14.0,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        apptDate,
                        //'03 Dec 2022, 8:30 AM',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                if (data.doctorClinicLocation.isNotEmpty) ...[
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: kColor26.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/icon/location6.png',
                          width: 10.5,
                          height: 14.0,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          data.doctorClinicLocation.first.toString(),
                          //'03 Dec 2022, 8:30 AM',
                          style: kTextStyle1.copyWith(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
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