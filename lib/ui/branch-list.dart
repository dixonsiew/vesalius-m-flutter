import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vesalius_m_flutter/components/app-shared.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth-manager.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/models/user-details.dart';
import 'package:vesalius_m_flutter/services/data-service.dart';

import '../constants.dart';
import 'home.dart';

class BranchList extends StatefulWidget {
  
  static final String routeName = 'Branch';

  @override
  _BranchListState createState() => _BranchListState();
}

class _BranchListState extends State<BranchList> {

  List<UserBranch> list = [];
  UserBranch userBranch;
  bool isLoading = false;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

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
      var branchDetails = DataManager.branchDetails;
      if (branchDetails != null) {
        userBranch = branchDetails;
      }

      if (AuthManager.isLogin) {
        var lx = await getUserBranches();
        setState(() {
          list = lx;
          isLoading = false;
        });
      }

      else {
        var lx = await getPublicBranchList();
        setState(() {
          list = lx;
          isLoading = false;
        });
      }
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  Future<void> confirmChangeHospital(UserBranch o) async {
    try {
      setState(() {
        isLoading = true;
      });
      var patientDetails = await getVesaliusPatientData(o.branch.branchId, o.prn);
      DataManager.setPrn(o.prn);
      await DataManager.setPatientDetails(patientDetails);
      await DataManager.setBranchDetails(o);
      setState(() {
        isLoading = false;
      });
      await Navigator.pushNamedAndRemoveUntil(context, Home.routeName, (route) => false);
    }
    
    catch (error) {
      setState(() {
        isLoading = false;
      });
      showCustomDialog('Failed', 'Unable to get patient details. Please try again later.', 'Dismiss', context);
    }
  }

  Widget buildContent(UserBranch userBranch) {
    final o = userBranch.branch;
    return InkWell(
      onTap: () async {
        if (AuthManager.isLogin) {
          bool b = await showConfirmDialog('Change Hospital', 'Are you sure want to change the hospital to:\n${o.branchName}', 'Cancel', 'Sure', context) ?? false;
          if (b) {
            confirmChangeHospital(userBranch);
          }
        }

        else {
          await DataManager.setBranchDetails(userBranch);
          Navigator.pop(context, true);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(
          children: [
            Expanded(
              child: Text(o.branchName),
            ),
            userBranch?.branch?.branchId == o.branchId ? Icon(
              Icons.check
            ) : Container(),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
        backgroundColor: Colors.white,
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: BackBtn(color: Colors.black),
        centerTitle: true,
        title: Text(
          'Hospital',
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: AppActivityIndicator(), // AppScalingText('Loading...'),
        child: RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: onRefresh,
          color: kPrimaryColor,
          child: SafeArea(
            child: Scrollbar(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: list?.length ?? 0,
                itemBuilder: (context, i) {
                  return buildContent(list[i]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}