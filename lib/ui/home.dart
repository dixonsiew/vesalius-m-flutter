import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:vesalius_m_flutter/components/app-drawer.dart';
import 'package:vesalius_m_flutter/components/app-shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment-data.dart';
import 'package:vesalius_m_flutter/models/appointment-manager.dart';
import 'package:vesalius_m_flutter/models/appointment-model.dart';
import 'package:vesalius_m_flutter/models/auth-manager.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/models/patient-data.dart';
import 'package:vesalius_m_flutter/models/user-details.dart';
import 'package:vesalius_m_flutter/services/data-service.dart';

import 'allergies.dart';
import 'appointment.dart';
import 'doctor.dart';
import 'health-dashboard.dart';
import 'hospital.dart';
import 'medical-history.dart';
import 'profile.dart';
import 'sign-up.dart';
import 'user-list.dart';

class Home extends StatefulWidget {

  static const String routeName = 'Home';

  @override
  _HomeState createState() => _HomeState();
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
    await AuthManager.load();
    var x = await DataManager.getPatientDetails();
    AppointmentManager.start(context);
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
    await OneSignal.shared.setAppId(ONESIGNAL_APP_ID);

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
        Icon(
          Icons.check,
          color: kPrimaryColor,
          size: 24.0,
        ) :
        Container(width: 24.0, height: 24.0),
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
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 25.0),
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
          title: Text(
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
                margin: EdgeInsets.only(top: 20.0, bottom: 15.0),
                width: double.infinity,
                height: 1.0,
                color: Color(0xFFE0E0E0),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: buildBranchList(lx, setState),
              ),
            ],
          ),
          actions: [
            CupertinoButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18.0,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoButton(
              child: Text(
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
    return await showConfirmDialog('Confirm to exit', 'Are you sure you want to exit ?', 'Cancel', 'Sure', context);
  }

  List<Widget> buildDefaultList() {
    List<Widget> lx = [
      HomeCard(
        title: 'Doctor Information',
        desc: 'Search Doctors Information',
        image: 'search-doctor',
        onTap: () async {
          var branch = DataManager.branchDetails;
          if (branch == null) {
            final lx = await getPublicBranchList();
            if (lx.length > 1) {
              await selectBranch(lx);
            }

            else {
              await DataManager.setBranchDetails(lx[0]);
            }
          }
          await Navigator.pushNamed(context, Doctor.routeName);
        },
      ),
      HomeCard(
        title: 'Hospital Information',
        desc: 'View Hospital Information',
        image: 'search-hospital',
        onTap: () async {
          var branch = DataManager.branchDetails;
          if (branch == null) {
            var lx = await getPublicBranchList();
            if (lx.length > 1) {
              await selectBranch(lx);
            }

            else {
              await DataManager.setBranchDetails(lx[0]);
            }
          }
          await Navigator.pushNamed(context, Hospital.routeName);
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
        extraInfo: '${getAppointmentSchedule()}',
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

    if (this.isAuth) {
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
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: RawMaterialButton(
              elevation: 5.0,
              fillColor: kPrimaryBtnBgColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              constraints: BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
              child: Text(
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
            padding: EdgeInsets.only(top: 20.0, bottom: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Don\'t have an account? ',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16.0,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, SignUp.routeName);
                  },
                  child: Text(
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

    if (this.isAuth) {
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
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: RawMaterialButton(
              elevation: 5.0,
              fillColor: kHomeBgColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
              constraints: BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
              child: Text(
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
            padding: EdgeInsets.only(top: 20.0, bottom: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Don\'t have an account? ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontFamily: kBodyFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, SignUp.routeName);
                  },
                  child: Text(
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
      padding: EdgeInsets.all(20.0),
      child: Text(
        s,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: kTitleFont,
        ),
      ),
    );
  }

  Widget buildLayer2() {
    var padding = MediaQuery.of(context).padding;

    return Container(
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

  Widget buildLayer1() {
    return Container(
      width: double.infinity,
      height: 120.0,
      color: kMainColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: drawerKey,
        backgroundColor: Color(0xFFF5F5F5),
        appBar: AppBar(
          // brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kMainColor),
          toolbarHeight: kAppToolbarHeight,
          backgroundColor: kMainColor,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              drawerKey.currentState?.openDrawer();
            },
          ),
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(
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
          progressIndicator: AppActivityIndicator(),
          child: SafeArea(
            child: Stack(
              children: [
                buildLayer1(),
                buildLayer2(),
              ],
            ),
          ),
        ),
        drawer: AppDrawer(),
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

  HomeCard({
    required this.title,
    required this.desc,
    required this.image,
    required this.onTap,
    this.extraInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 11.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(133, 133, 133, 0.29),
                offset: Offset(3, 3),
                blurRadius: 10.0,
                spreadRadius: 1,
              ),
            ]
          ),
          child: InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$title',
                          style: TextStyle(
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
                          '$desc',
                          style: TextStyle(
                            color: kDescriptionColor,
                            fontSize: 11.0,
                            fontFamily: kBodyFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        extraInfo == null ? Container() : Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text(
                            extraInfo ?? '',
                            style: TextStyle(
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
                  padding: EdgeInsets.only(right: 15.0),
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
    );
  }
}