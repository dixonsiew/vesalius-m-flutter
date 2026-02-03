import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app-shared.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/models/storage-data-manager.dart';
import 'package:vesalius_m_flutter/models/user-details.dart';
import 'package:vesalius_m_flutter/ui/sign-in.dart';

import 'home.dart';

class UserList extends StatefulWidget {
  
  static const String routeName = 'User';

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  List<String> list = [];
  UserDetails? userDetails;
  bool isDelete = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      setState(() {
        isLoading = true;
      });
      var _userDetails = await DataManager.getUserDetails();
      var lx = await StorageDataManager.getData();
      setState(() {
        list = lx;
        userDetails = _userDetails;
        isLoading = false;
      });
      if (lx.isEmpty) {
        Navigator.pushNamedAndRemoveUntil(context, SignIn.routeName, (route) {
          if (route.settings.name == Home.routeName) {
            return true;
          }

          return false;
        });
      }
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void confirmDeleteUser(String email) async {
    await StorageDataManager.delUser(email);
    var lx = await StorageDataManager.getData();
    setState(() {
      list = lx;
    });
    if (lx.isEmpty) {
      Navigator.popUntil(context, ModalRoute.withName(Home.routeName));
    }
  }

  void onDeleteUser(String email) async {
    bool b = await showConfirmDialog('Confirm to Delete', 'Are you sure you want to delete this user from the list?', 'Cancel', 'Sure', context);
    if (b) {
      confirmDeleteUser(email);
    }
  }

  Widget getIcon(String email) {
    if (userDetails?.email == email) {
      if (!isDelete) {
        return Icon(
          Icons.check,
          color: kHomeBgColor,
        );
      }

      else {
        return InkWell(
          child: Icon(Icons.delete),
          onTap: () => onDeleteUser(email),
        );
      }
    }

    else {
      if (!isDelete) {
        return Container();
      }

      else {
        return InkWell(
          child: Icon(Icons.delete),
          onTap: () => onDeleteUser(email),
        );
      }
    }
  }

  Widget buildContent(String email) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              child: Text(
                email,
                style: TextStyle(
                  fontFamily: kBodyFont,
                ),
              ),
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => SignIn(email: email)
                  )
                );
              },
            ),
          ),
          getIcon(email),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2E2E2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.white),
        backgroundColor: Colors.white,
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: BackBtn(color: Colors.black),
        centerTitle: true,
        title: Text(
          'User',
          style: TextStyle(
            color: kHomeBgColor,
            fontSize: 18.0,
            fontFamily: kTitleFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDelete ? Icons.close : Icons.settings,
              color: isDelete ? Colors.black : kHomeBgColor,
            ),
            onPressed: () {
              setState(() {
                isDelete = !isDelete;
              });
            }
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: AppActivityIndicator(), // AppScalingText('Loading...'),
        child: SafeArea(
          child: Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, i) {
                return buildContent(list[i]);
              },
            ),
          ),
        ),
      ),
    );
  }
}