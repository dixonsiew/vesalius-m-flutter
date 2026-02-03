import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment-manager.dart';
import 'package:vesalius_m_flutter/models/auth-manager.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/models/patient-data.dart';
import 'package:vesalius_m_flutter/models/user-details.dart';
import 'package:vesalius_m_flutter/services/data-service.dart';
import 'package:vesalius_m_flutter/ui/branch-list.dart';
import 'package:vesalius_m_flutter/ui/change-password.dart';
import 'package:vesalius_m_flutter/ui/home.dart';
import 'package:vesalius_m_flutter/ui/user-list.dart';

class AppDrawer extends StatefulWidget {

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  bool isAuth = false;
  PatientDetails patientDetails;
  UserBranch branch;
  String version;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    await AuthManager.load();
    var x = await DataManager.getPatientDetails();
    var _branch = await guestModeAutoSelectBranch();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      isAuth = AuthManager.isLogin;
      patientDetails = x;
      branch = _branch;
      version = packageInfo.version;
    });
  }

  Future<UserBranch> guestModeAutoSelectBranch() async {
    UserBranch _branch;
    if (!AuthManager.isLogin) {
      var ls = await getPublicBranchList() ?? [];
      if (ls.isNotEmpty) {
        await DataManager.setBranchDetails(ls.first);
        _branch = DataManager.branchDetails;
      }
    }

    else {
      _branch = DataManager.branchDetails;
    }

    return _branch;
  }

  Future<bool> onSignOut() async {
    return await showConfirmDialog('Confirm to sign out', 'Are you sure you want to sign out?', 'Cancel', 'Sure', context);
  }

  Future<bool> onSignOutBak() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.only(top: 24.0, bottom: 0),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
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
                SizedBox(height: 8.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Are you sure you want to sign out?',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 15.0),
                Container(
                  height: 1.0,
                  color: Color(0xFFE0E0E0),
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
                          child: Text(
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
                      color: Color(0xFFE0E0E0),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text(
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
      var name = patientDetails.name;
      s = '${name.title} ${name.firstName} ${name.middleName} ${name.lastName}'.trim();
    }

    List<Widget> lx = [
      buildLogo(),
      Padding(
        padding: EdgeInsets.only(left: 15.0, top: 30.0, bottom: 25.0),
        child: Text(
          s,
          style: TextStyle(
            fontSize: 24.0,
            color: Color(0xFF555454),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
      InkWell(
        onTap: () async {
          Navigator.pop(context);
          await Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => BranchList()
            )
          );
        },
        child: Padding(
          padding: EdgeInsets.only(left: 15.0, top: 25.0, bottom: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Hospital',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color.fromRGBO(5, 5, 5, 0.479),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    branch == null ? '' : '${branch?.branch?.branchName}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF555454),
                    ),
                  ),
                  SizedBox(width: 10.0),
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
      Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
      InkWell(
        onTap: () async {
          Navigator.pop(context);
          await Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => UserList()
            )
          );
        },
        child: Padding(
          padding: EdgeInsets.only(left: 15.0, top: 25.0, bottom: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Switch User',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color.fromRGBO(5, 5, 5, 0.479),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
      Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 15.0, top: 50.0, bottom: 20.0),
        child: Text(
          'SETTINGS',
          style: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF555454),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, ChangePassword.routeName);
        },
        child: Padding(
          padding: EdgeInsets.only(left: 15.0, top: 25.0, bottom: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color.fromRGBO(5, 5, 5, 0.479),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
      Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
      InkWell(
        onTap: () async {
          bool b = await onSignOut();
          if (b) {
            await DataManager.clear();
            AppointmentManager.stop();
            await Navigator.pushNamedAndRemoveUntil(context, Home.routeName, (route) => false);
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 15.0, top: 25.0, bottom: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color.fromRGBO(5, 5, 5, 0.479),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
      Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Center(
          child: Text(
            'App Version: $version',
            style: TextStyle(
              fontSize: 16.0,
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
      var name = patientDetails.name;
      s = '${name.title} ${name.firstName} ${name.middleName} ${name.lastName}'.trim();
    }

    List<Widget> lx = [
      buildLogo(),
      Padding(
        padding: EdgeInsets.only(left: 15.0, top: 30.0, bottom: 25.0),
        child: Text(
          s,
          style: TextStyle(
            fontSize: 20.0,
            color: Color(0xFF555454),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
      InkWell(
        onTap: () async {
          Navigator.pop(context);
          final b = await Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => BranchList()
            )
          ) ?? false;
          if (b) {
            await DataManager.getBranchDetails();
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 15.0, top: 25.0, bottom: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Hospital',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color.fromRGBO(5, 5, 5, 0.479),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    branch == null ? 'Select' : '${branch?.branch?.branchName}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF555454),
                    ),
                  ),
                  SizedBox(width: 10.0),
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
      Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Center(
          child: Text(
            'App Version: $version',
            style: TextStyle(
              fontSize: 16.0,
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
        padding: EdgeInsets.only(top: 60.0, right: 10.0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: isAuth ? buildAuthList() : buildDefaultList(),
        ),
      ),
    );
  }
}