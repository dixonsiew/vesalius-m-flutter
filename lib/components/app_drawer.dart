import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment_manager.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/ui/branch_list.dart';
import 'package:vesalius_m_flutter/ui/change_password.dart';
import 'package:vesalius_m_flutter/ui/home.dart';
import 'package:vesalius_m_flutter/ui/user_list.dart';

class AppDrawer extends StatefulWidget {

  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  bool isAuth = false;
  PatientDetails? patientDetails;
  UserBranch? branch;
  String version = '';

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    version = '';
    await AuthManager.load();
    var x = await DataManager.getPatientDetails();
    var mbranch = await guestModeAutoSelectBranch();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      isAuth = AuthManager.isLogin;
      patientDetails = x;
      branch = mbranch;
      version = packageInfo.version;
    });
  }

  Future<UserBranch?> guestModeAutoSelectBranch() async {
    UserBranch? mbranch;
    if (!AuthManager.isLogin) {
      var ls = await getPublicBranchList();
      if (ls.isNotEmpty) {
        await DataManager.setBranchDetails(ls.first);
        mbranch = DataManager.branchDetails;
      }
    }

    else {
      mbranch = DataManager.branchDetails;
    }

    return mbranch;
  }

  Future<bool> onSignOut() async {
    return await CustomDialog.of(context).showConfirmDialog('Confirm to sign out', 'Are you sure you want to sign out?', 'Cancel', 'Sure');
  }

  Future<bool> onSignOutBak() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.only(top: 24.0, bottom: 0),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Confirm to sign out',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Are you sure you want to sign out?',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15.0),
                Container(
                  height: 1.0,
                  color: const Color(0xFFE0E0E0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 19.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1.0,
                      height: 50.0,
                      color: const Color(0xFFE0E0E0),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text(
                            'Sure',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    ) ?? false;
  }

  Widget buildLogo() {
    return Image.asset('images/icon/header-logo.png');
  }

  List<Widget> buildAuthList() {
    String s = 'Guest';
    if (isAuth && patientDetails != null) {
      var name = patientDetails?.name;
      s = '${name?.title} ${name?.firstName} ${name?.middleName} ${name?.lastName}'.trim();
    }

    List<Widget> lx = [
      buildLogo(),
      Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 30.0, bottom: 25.0),
        child: Text(
          s,
          style: const TextStyle(
            fontSize: 20.0,
            fontFamily: kBodyFont,
            color: Color(0xFF555454),
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
      InkWell(
        onTap: () async {
          Navigator.of(context).pop();
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BranchList()));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 25.0, bottom: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Hospital',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: kBodyFont,
                    color: Color.fromRGBO(5, 5, 5, 0.479),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    branch == null ? '' : '${branch?.branch?.branchName}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontFamily: kBodyFont,
                      color: Color(0xFF555454),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: kPrimaryColor,
                  ),
                  const SizedBox(width: 10.0),
                ],
              ),
            ],
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
      InkWell(
        onTap: () async {
          Navigator.of(context).pop();
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserList()));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 25.0, bottom: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Switch User',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: kBodyFont,
                    color: Color.fromRGBO(5, 5, 5, 0.479),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: kPrimaryColor,
                  ),
                  SizedBox(width: 10.0),
                ],
              ),
            ],
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 15.0, top: 50.0, bottom: 20.0),
        child: Text(
          'SETTINGS',
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: kBodyFont,
            color: Color(0xFF555454),
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(ChangePassword.routeName);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 25.0, bottom: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: kBodyFont,
                    color: Color.fromRGBO(5, 5, 5, 0.479),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: kPrimaryColor,
                  ),
                  SizedBox(width: 10.0),
                ],
              ),
            ],
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
      InkWell(
        onTap: () async {
          final nav = Navigator.of(context);
          bool b = await onSignOut();
          if (b) {
            await DataManager.clear();
            AppointmentManager.stop();
            nav.pushNamedAndRemoveUntil(Home.routeName, (route) => false);
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 25.0, bottom: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: kBodyFont,
                    color: Color.fromRGBO(5, 5, 5, 0.479),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: kPrimaryColor,
                  ),
                  SizedBox(width: 10.0),
                ],
              ),
            ],
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Center(
          child: Text(
            'App Version: $version',
            style: const TextStyle(
              fontSize: 16.0,
              fontFamily: kBodyFont,
              color: Color(0xFFB4B4B4),
            ),
          ),
        ),
      ),
    ];

    return lx;
  }

  List<Widget> buildDefaultList() {
    String s = 'Guest';
    if (isAuth && patientDetails != null) {
      var name = patientDetails?.name;
      s = '${name?.title} ${name?.firstName} ${name?.middleName} ${name?.lastName}'.trim();
    }

    List<Widget> lx = [
      buildLogo(),
      Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 30.0, bottom: 25.0),
        child: Text(
          s,
          style: const TextStyle(
            fontSize: 20.0,
            fontFamily: kBodyFont,
            color: Color(0xFF555454),
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
      InkWell(
        onTap: () async {
          Navigator.of(context).pop();
          final b = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BranchList())) ?? false;
          if (b) {
            await DataManager.getBranchDetails();
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 25.0, bottom: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Hospital',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: kBodyFont,
                    color: Color.fromRGBO(5, 5, 5, 0.479),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    branch == null ? 'Select' : '${branch?.branch?.branchName}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontFamily: kBodyFont,
                      color: Color(0xFF555454),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: kPrimaryColor,
                  ),
                  const SizedBox(width: 10.0),
                ],
              ),
            ],
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Center(
          child: Text(
            'App Version: $version',
            style: const TextStyle(
              fontSize: 16.0,
              fontFamily: kBodyFont,
              color: Color(0xFFB4B4B4),
            ),
          ),
        ),
      ),
    ];

    return lx;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.only(top: 60.0, right: 10.0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: isAuth ? buildAuthList() : buildDefaultList(),
        ),
      ),
    );
  }
}