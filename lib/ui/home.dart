import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/bottom_bar.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/appointment_manager.dart';
import 'package:vesalius_m_flutter/models/appointment_model.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/notification_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';

import 'appointment/appointment_detail.dart';
import 'doctor.dart';
import 'hospital/our_story.dart';
import 'package.dart';
import 'patient_survey.dart';

class Home extends StatefulWidget {

  static const String routeName = '/Home';

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isLoading = false;
  bool isSearch = false;
  bool isAuth = false;
  PatientDetails? patientDetails;
  FutureAppointment? appointment;
  UserBranch? branch;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() {
      isLoading = true;
    });
    AppointmentManager.start(context);
    await AuthManager.load();
    await DataManager.getUserDetails();
    var x = await DataManager.getPatientDetails();
    var branchDetails = await DataManager.getBranchDetails();
    if (branchDetails != null && branchDetails.branch != null && AuthManager.isLogin) {
      await AppointmentManager.getValidAppointment(branchDetails.branch!.branchId!);
    }

    await initPlatformState();

    setState(() {
      isAuth = AuthManager.isLogin;
      patientDetails = x;
      isLoading = false;
    });
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.info, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(false);

    OneSignal.shared.setNotificationWillShowInForegroundHandler(NotificationManager.notificationWillShowInForegroundHandler);

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      final notification = result.notification;
      String d = "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      print(d);
      if (AuthManager.isLogin) {
        if (notification.additionalData!['type'] == 'survey') {
          Get.toNamed(PatientSurvey.routeName);
        }

        else {
          Get.toNamed(AppointmentDetail.routeName);
        }
      }
    });

    if (Platform.isIOS) {
      await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
    }

    if (AuthManager.isLogin) {
      OneSignal.shared.sendTag('user', DataManager.userDetails!.userId!);
      String playerId = '';
      OSDeviceState? deviceState = await OneSignal.shared.getDeviceState();
      if (deviceState != null) {
        String? userId = deviceState.userId;
        playerId = userId ?? '';
      }

      if (playerId.isNotEmpty) {
        await updatePlayerId(playerId);
      }
    }
  }

  String get name {
    var x = patientDetails!.name;
    String s = '${x?.title} ${x?.firstName} ${x?.middleName} ${x?.lastName}'.trim();
    return s;
  }

  String get greetings {
    var h = DateTime.now().hour;
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

  String getTime(String s) {
    var a = s.split(':');
    int hour = int.parse(a[0]);
    int min = int.parse(a[1]);
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, min);
    return formatDate(dt, [h, ':', nn, ' ', am]);
  }

  String getDate(String s) {
    return s.replaceAll('-', ' ');
  }

  String getAppointmentSchedule() {
    var appmt = Provider.of<AppointmentModel>(context).appointment;
    return '${getDate(appmt!.date!)}, ${getTime(appmt.startTime!)}';
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
    UserBranch? o = await showCupertinoDialog(
      context: context, 
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => CupertinoAlertDialog(
          title: const Text(
            'Select Hospital',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: kBodyFont,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20.0, bottom: 15.0),
                width: double.infinity,
                height: 1.0,
                color: const Color(0xFFE0E0E0),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: buildBranchList(lx, setState),
              ),
            ],
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
        ),
      ),
    );
    if (o != null) {
      await DataManager.setBranchDetails(o);
    }
  }

  Future<bool> onWillPop() async {
    return await showConfirmDialog('Are you sure you want to exit ?');
  }

  Widget buildSearch() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextField(
        controller: searchController,
        autofocus: false,
        cursorColor: kMainColor,
        style: const TextStyle(
          fontFamily: kBodyFont,
          fontSize: 16.0,
          color: Color(0xFF002E50),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Search By Speciality, Doctor Name",
          hintStyle: kBodyTextStyle.copyWith(
            color: const Color(0xFFB1B1B1),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 15.0),
            child: IconButton(
              icon: const Icon(
                Icons.search,
                color: kMainColor,
              ),
              onPressed: () {
                Get.to(() => Doctor(keyword: searchController.text));
              },
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 8.0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromRGBO(234, 234, 234, 0.21),
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromRGBO(234, 234, 234, 0.21),
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    if (isLoading) {
      return Container();
    }

    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 14.0),
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Text(
            '$greetings,\n$name',
            style: kMainTextStyle.copyWith(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: kMainColor,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        buildSearch(),
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Text(
            'Upcoming Appointment',
            style: kLabelTextStyle.copyWith(
              fontFamily: kMainFont,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: InkWell(
            onTap: () {
              Get.toNamed(AppointmentDetail.routeName);
            },
            child: Container(
              padding: const EdgeInsets.only(top: 15.0, bottom: 16.0),
              decoration: BoxDecoration(
                color: kMainColor,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(235, 235, 235, 0.7),
                    blurRadius: 7.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 16.0),
                      Image.asset(
                        'images/imgs/pic.png',
                        width: 48.0,
                        height: 48.0,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tan Sri Dato' Dr. Yahya Awang",
                              style: kBodyTextStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Consultant Cardiothoracic Surgeon',
                              style: kBodyTextStyle.copyWith(
                                fontSize: 12.0,
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
                  ),
                  const SizedBox(height: 8.85),
                  const Divider(
                    height: 1.0,
                    thickness: 1.0,
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 17.0),
                      Image.asset(
                        'images/icon/clock.png',
                        width: 14.0,
                        height: 14.0,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '01 Oct 2021, 9:00 AM',
                        style: kBodyTextStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 11.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 17.0),
                      Image.asset(
                        'images/icon/location.png',
                        width: 11.0,
                        height: 15.0,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'Room 212, Level 2',
                        style: kBodyTextStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, bottom: 15.0),
          child: Text(
            'Services',
            style: kLabelTextStyle.copyWith(
              fontFamily: kMainFont,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 31.0),
          child: SizedBox(
            height: 230.0,
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 20.0,
              children: [
                /* InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, HealthDashboard.routeName);
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'images/imgs/health-dashboard.png',
                        width: 56.0,
                        height: 56.0,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Health\nDashboard',
                        style: kTitleTextStyle.copyWith(
                          fontSize: 12.0,
                          color: Color(0xFF4E4E4E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Allergies.routeName);
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'images/imgs/allergies-alerts.png',
                        width: 56.0,
                        height: 56.0,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Allergies &\nAlerts',
                        style: kTitleTextStyle.copyWith(
                          fontSize: 12.0,
                          color: Color(0xFF4E4E4E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, VisitHistory.routeName);
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'images/imgs/visit-history.png',
                        width: 56.0,
                        height: 56.0,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Visit History',
                        style: kTitleTextStyle.copyWith(
                          fontSize: 12.0,
                          color: Color(0xFF4E4E4E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ), */
                InkWell(
                  onTap: () {
                    Get.toNamed(Doctor.routeName);
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'images/imgs/doctor-information.png',
                        width: 56.0,
                        height: 56.0,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5.0),
                      Flexible(
                        child: Text(
                          'Doctor\nInformation',
                          style: kTitleTextStyle.copyWith(
                            fontSize: 12.0,
                            color: const Color(0xFF4E4E4E),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(OurStory.routeName);
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'images/imgs/hospital-information.png',
                        width: 56.0,
                        height: 56.0,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5.0),
                      Flexible(
                        child: Text(
                          'Hospital\nInformation',
                          style: kTitleTextStyle.copyWith(
                            fontSize: 12.0,
                            color: const Color(0xFF4E4E4E),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(PatientSurvey.routeName);
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'images/imgs/feedback.gif',
                        width: 56.0,
                        height: 56.0,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5.0),
                      Flexible(
                        child: Text(
                          'Share\nFeedback',
                          style: kTitleTextStyle.copyWith(
                            fontSize: 12.0,
                            color: const Color(0xFF4E4E4E),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(Package.routeName);
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'images/imgs/packages.png',
                        width: 56.0,
                        height: 56.0,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5.0),
                      Flexible(
                        child: Text(
                          'Screen\nPackages',
                          style: kTitleTextStyle.copyWith(
                            fontSize: 12.0,
                            color: const Color(0xFF4E4E4E),
                          ),
                          textAlign: TextAlign.center,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
          toolbarHeight: 0.0,
          backgroundColor: const Color(0xFFF8F8F8),
          elevation: 0.0,
        ),
        backgroundColor: const Color(0xFFF8F8F8),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: const AppActivityIndicator(),
          child: SafeArea(
            child: Scrollbar(
              child: buildContent(),
            ),
          ),
        ),
        bottomNavigationBar: const BottomBar(index: 0),
      ),
    );
  }
}