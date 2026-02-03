import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/storage_data_manager.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/ui/sign_in.dart';

import 'home.dart';

class UserList extends StatefulWidget {
  
  static const String routeName = '/User';

  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
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
      UserDetails? muserDetails = await DataManager.getUserDetails();
      List<String> lx = await StorageDataManager.getData();
      setState(() {
        list = lx;
        userDetails = muserDetails;
        isLoading = false;
      });
      if (lx.isEmpty) {
        Get.offAllNamed(SignIn.routeName, predicate: (route) {
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
    List<String> lx = await StorageDataManager.getData();
    setState(() {
      list = lx;
    });
    if (lx.isEmpty) {
      Get.until(ModalRoute.withName(Home.routeName));
    }
  }

  void onDeleteUser(String email) async {
    bool b = await showConfirmDialog00('Confirm to Delete', 'Are you sure you want to delete this user from the list?', 'Cancel', 'Sure');
    if (b) {
      confirmDeleteUser(email);
    }
  }

  Widget getIcon(String email) {
    if (userDetails?.email == email) {
      if (!isDelete) {
        return const Icon(Icons.check);
      }

      else {
        return InkWell(
          child: const Icon(Icons.delete),
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
          child: const Icon(Icons.delete),
          onTap: () => onDeleteUser(email),
        );
      }
    }
  }

  Widget buildContent(String email) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2E2E2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              child: Text(
                email,
                style: const TextStyle(
                  fontFamily: kBodyFont,
                ),
              ),
              onTap: () {
                Get.to(() => SignIn(email: email));
              },
            ),
          ),
          getIcon(email),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.white),
        backgroundColor: Colors.white,
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: const BackBtn(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'User',
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 18.0,
            fontFamily: kTitleFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDelete ? Icons.close : Icons.settings,
              color: isDelete ? Colors.black : kPrimaryColor,
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
        progressIndicator: const AppActivityIndicator(), // AppScalingText('Loading...'),
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