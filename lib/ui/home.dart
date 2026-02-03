import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:vesalius_m_flutter/components/app_drawer.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/appointment_manager.dart';
import 'package:vesalius_m_flutter/models/appointment_model.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

import 'allergies.dart';
import 'appointment.dart';
import 'doctor.dart';
import 'health_dashboard.dart';
import 'hospital.dart';
import 'medical_history.dart';
import 'profile.dart';
import 'sign_up.dart';
import 'user_list.dart';

class Home extends StatefulWidget {

  static const String routeName = 'Home';

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isLoading = false;
  bool isAuth = false;
  PatientDetails? patientDetails;
  FutureAppointment? appointment;
  UserBranch? branch;
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    setState(() {
      isLoading = true;
    });
    AppointmentManager.start(context);
    await AuthManager.load();
    var x = await DataManager.getPatientDetails();
    var branchDetails = await DataManager.getBranchDetails();
    if (branchDetails != null && branchDetails.branch != null && AuthManager.isLogin) {
      await AppointmentManager.getValidAppointment(branchDetails.branch!.branchId!);
    }

    setState(() {
      isAuth = AuthManager.isLogin;
      patientDetails = x;
      isLoading = false;
    });

    await initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(false);

    // var settings = {
    //   OSiOSSettings.autoPrompt: false,
    //   OSiOSSettings.promptBeforeOpeningPushUrl: true
    // };

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      final notification = event.notification;
      final x = notification.additionalData;
      print(x);
      String d = "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      print(d);
    });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      String d = "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      print(d);
    });

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared.setAppId(kOneSignalAppID);

    // OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

    await clearOneSignal();

    if (AuthManager.isLogin) {
      OneSignal.shared.sendTag('user', DataManager.userDetails!.userId!);
    }

    // bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();
  }

  Future<void> clearOneSignal() async {
    await OneSignal.shared.deleteTag('user');
    await OneSignal.shared.deleteTag('guest-ticket');
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
    var appmt = context.watch<AppointmentModel>().appointment;
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
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ), 
              onPressed: () => Navigator.pop(context, branch),
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
    return await CustomDialog.of(context).showConfirmDialog('Confirm to exit', 'Are you sure you want to exit ?', 'Cancel', 'Sure');
  }

  void onPopInvoked(bool didPop) async{
    if (didPop) return;
    bool b = await CustomDialog.of(context).showConfirmDialog('Confirm to exit', 'Are you sure you want to exit ?', 'Cancel', 'Sure');
    if (b) {
      SystemNavigator.pop();
    }
  }

  List<Widget> buildDefaultList() {
    List<Widget> lx = [
      HomeCard(
        title: 'Doctor Information',
        desc: 'Search Doctors Information',
        image: 'search-doctor',
        onTap: () async {
          var branch = DataManager.branchDetails;
          NavigatorState nav = Navigator.of(context);
          if (branch == null) {
            final lx = await getPublicBranchList();
            if (lx.length > 1) {
              await selectBranch(lx);
            }

            else {
              await DataManager.setBranchDetails(lx[0]);
            }
          }
          await nav.pushNamed(Doctor.routeName);
        },
      ),
      HomeCard(
        title: 'Hospital Information',
        desc: 'View Hospital Information',
        image: 'search-hospital',
        onTap: () async {
          var branch = DataManager.branchDetails;
          NavigatorState nav = Navigator.of(context);
          if (branch == null) {
            var lx = await getPublicBranchList();
            if (lx.length > 1) {
              await selectBranch(lx);
            }

            else {
              await DataManager.setBranchDetails(lx[0]);
            }
          }
          await nav.pushNamed(Hospital.routeName);
        },
      ),
      // HomeCard(
      //   title: 'Queue Number',
      //   desc: 'Queue Number and Notifications',
      //   image: 'ticket',
      //   onTap: () {
          
      //   },
      // ),
    ];

    return lx;
  }

  List<Widget> buildAuthList() {
    List<Widget> lx = [
      // HomeCard(
      //   title: 'Queue Number',
      //   desc: 'Queue Number and Notifications',
      //   image: 'ticket',
      //   onTap: () {
          
      //   },
      // ),
      context.watch<AppointmentModel>().hasAppointment == false ?
      HomeCard(
        title: 'Appointment',
        desc: 'You currently have no Upcoming Appointments',
        image: 'appointment',
        onTap: () {
          Navigator.pushNamed(context, Appointment.routeName);
        },
      ) :
      HomeCard(
        title: 'Appointment',
        desc: 'Upcoming Appointment',
        image: 'appointment',
        extraInfo: getAppointmentSchedule(),
        onTap: () {
          Navigator.pushNamed(context, Appointment.routeName);
        },
      ),
      HomeCard(
        title: 'Health Dashboard',
        desc: 'View your health trending',
        image: 'dashboard-icon',
        onTap: () {
          Navigator.pushNamed(context, HealthDashboard.routeName);
        },
      ),
      HomeCard(
        title: 'Allergies and Alerts',
        desc: 'View Drug Allergies and Medical Alerts',
        image: 'allergies',
        onTap: () {
          Navigator.pushNamed(context, Allergies.routeName);
        },
      ),
      HomeCard(
        title: 'Visit History',
        desc: 'View Your Medical History',
        image: 'medical-record',
        onTap: () {
          Navigator.pushNamed(context, MedicalHistory.routeName);
        },
      ),
      HomeCard(
        title: 'Doctor Information',
        desc: 'Search Doctors Information',
        image: 'search-doctor',
        onTap: () async {
          await Navigator.pushNamed(context, Doctor.routeName);
        },
      ),
      HomeCard(
        title: 'Hospital Information',
        desc: 'View Hospital Information',
        image: 'search-hospital',
        onTap: () {
          Navigator.pushNamed(context, Hospital.routeName);
        },
      ),
      HomeCard(
        title: 'Profile Details',
        desc: 'View Your Personal Info',
        image: 'profile-details',
        onTap: () {
          Navigator.pushNamed(context, Profile.routeName);
        },
      ),
    ];

    return lx;
  }

  Widget buildContent0() {
    if (isLoading) {
      return Container();
    }

    if (isAuth) {
      return Scrollbar(
        child: ListView(
          shrinkWrap: true,
          children: buildAuthList(),
        ),
      );
    }

    else {
      return Column(
        children: [
          Expanded(
            child: Column(
              children: buildDefaultList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: RawMaterialButton(
              elevation: 5.0,
              fillColor: kPrimaryBtnBgColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              constraints: const BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, UserList.routeName);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Don\'t have an account? ',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16.0,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignUp.routeName);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: kPrimaryColor,
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 16.0,
                      decoration: TextDecoration.underline,
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

  Widget buildContent() {
    if (isLoading) {
      return Container();
    }

    if (isAuth) {
      return Scrollbar(
        child: ListView(
          shrinkWrap: true,
          children: buildAuthList(),
        ),
      );
    }

    else {
      return Column(
        children: [
          Expanded(
            child: Column(
              children: buildDefaultList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: RawMaterialButton(
              elevation: 5.0,
              fillColor: kHomeBgColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
              constraints: const BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, UserList.routeName);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account? ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontFamily: kBodyFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignUp.routeName);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: kMainColor,
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: kMainColor,
                      fontSize: 16.0,
                      fontFamily: kBodyFont,
                      fontWeight: FontWeight.bold,
                      // decoration: TextDecoration.underline,
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

  Widget buildHeader() {
    String s = '';

    if (isAuth && patientDetails != null) {
      var name = patientDetails!.name!;
      s = '${name.title} ${name.firstName} ${name.middleName} ${name.lastName}';
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        s,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: kTitleFont,
        ),
      ),
    );
  }

  Widget buildLayer2xx() {
    var padding = MediaQuery.of(context).padding;

    return SizedBox(
      height: MediaQuery.of(context).size.height - padding.top - kAppToolbarHeight - padding.bottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(),
          Flexible(
            child: buildContent(),
          ),
        ],
      ),
    );
  }

  Widget buildLayer2yy() {
    var padding = MediaQuery.of(context).padding;

    return Container(
      height: MediaQuery.of(context).size.height - padding.top - kAppToolbarHeight - padding.bottom,
      margin: const EdgeInsets.only(top: 120.0),
      color: const Color(0xFFF5F5F5),
    );
  }

  Widget buildLayer2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader(),
        Flexible(
          child: buildContent(),
        ),
      ],
    );
  }

  Widget buildLayer1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          height: 120.0,
          color: kMainColor,
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            color: const Color(0xFFF5F5F5),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: onPopInvoked,
      child: Scaffold(
        key: drawerKey,
        backgroundColor: kMainColor,
        appBar: AppBar(
          // brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kMainColor),
          toolbarHeight: kAppToolbarHeight,
          backgroundColor: kMainColor,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              drawerKey.currentState?.openDrawer();
            },
          ),
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text(
            'Home',
            style: TextStyle(
              color: Colors.white,
              fontFamily: kTitleFont,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0.0,
        ),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: const AppActivityIndicator(),
          child: SafeArea(
            child: Stack(
              children: [
                buildLayer1(),
                buildLayer2(),
              ],
            ),
          ),
        ),
        drawer: const AppDrawer(),
      ),
    );
  }
}

class HomeCard extends StatelessWidget {

  final String title;
  final String desc;
  final String image;
  final String? extraInfo;
  final void Function() onTap;

  const HomeCard({
    Key? key,
    required this.title,
    required this.desc,
    required this.image,
    required this.onTap,
    this.extraInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 11.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(133, 133, 133, 0.29),
              offset: Offset(3, 3),
              blurRadius: 10.0,
              spreadRadius: 1,
            ),
          ]
        ),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(8.0),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Color(0xFF424242),
                              fontSize: 18.0,
                              fontFamily: kBodyFont,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // SizedBox(height: 3.0),
                          // Divider(
                          //   color: Color(0xFFDEDEDE),
                          //   height: 1.0,
                          //   thickness: 1.0,
                          // ),
                          // SizedBox(height: 2.0),
                          Text(
                            desc,
                            style: const TextStyle(
                              color: kDescriptionColor,
                              fontSize: 11.0,
                              fontFamily: kBodyFont,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          extraInfo == null ? Container() : Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              extraInfo ?? '',
                              style: const TextStyle(
                                color: Color(0xFF5F5E5E),
                                fontSize: 16.0,
                                fontFamily: kBodyFont,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Container(
                      width: 52.0,
                      height: 52.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('images/icon/home-page-icon/$image.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}