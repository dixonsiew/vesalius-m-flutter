import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vesalius_m_flutter/components/app-shared.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/allergy.dart';
import 'package:vesalius_m_flutter/models/auth-manager.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/services/data-service.dart';
import 'package:vesalius_m_flutter/ui/allergies/allergies-group.dart';

import '../constants.dart';

class Allergies extends StatefulWidget {

  static final String routeName = 'Allergies';

  @override
  _AllergiesState createState() => _AllergiesState();
}

class _AllergiesState extends State<Allergies> {

  List<AllergyGroup> groupList = [];
  AllergyGroup medicalAlertGroup;
  AllergyGroup allergiesAndReactionsGroup;
  AllergyGroup healthAlertsGroup;
  List otherAllergies = [];
  bool isLoading = false;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    await AuthManager.load();
    try {
      setState(() {
        isLoading = true;
      });
      var branchDetails = DataManager.branchDetails;
      var lx = await getPatientAllergies(branchDetails.branch.branchId, branchDetails.prn);
      List<AllergyGroup> lg = [];
      lx.forEach((o) {
        var k = lg.firstWhere((x) => x.alertType == o.alertType, orElse: () => null);
        if (k == null) {
          k = AllergyGroup(
            alertType: o.alertType,
            list: []
          );
          lg.add(k);
        }

        var la = k.list;
        la.add(o);
        k.list = la;
      });
      await sortList(lg);
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

  Future<void> sortList(List<AllergyGroup> lg) async {
    AllergyGroup _medicalAlertGroup;
    AllergyGroup _allergiesAndReactionsGroup;
    AllergyGroup _healthAlertsGroup;
    lg.forEach((o) {
      String s = o.alertType;
      if (s == 'CLINICAL ALLERGY') {
        _medicalAlertGroup = o;
      }

      else if (s == 'CLINICAL ALERT' || s == 'GENERAL ALLERGY') {
        if (_allergiesAndReactionsGroup == null) {
          _allergiesAndReactionsGroup = o;
        }

        else {
          var la = _allergiesAndReactionsGroup.list;
          var lb = o.list;
          la.addAll(lb);
        }
      }

      else if (s == 'GENERAL ALERT') {
        _healthAlertsGroup = o;
      }
    });

    setState(() {
      groupList = lg;
      medicalAlertGroup = _medicalAlertGroup;
      allergiesAndReactionsGroup = _allergiesAndReactionsGroup;
      healthAlertsGroup = _healthAlertsGroup;
      isLoading = false;
    });
    await DataManager.setItem('allergies', groupList);
  }

  Widget buildList() {
    return ListView(
      shrinkWrap: true,
      children: _buildList(),
    );
  }

  List<Widget> _buildList() {
    List<Widget> lx = [];
    if (medicalAlertGroup != null) {
      lx.add(
        AllergiesItem(
          name: 'Medical Alerts',
          onTap: () {
            Navigator.push(context, 
              MaterialPageRoute(
                builder: (context) => AllergiesGroup(title: 'Medical Alert', list: medicalAlertGroup.list),
              )
            );
          },
        )
      );
    }

    if (allergiesAndReactionsGroup != null) {
      lx.add(
        AllergiesItem(
          name: 'Allergies & Reactions',
          onTap: () {
            Navigator.push(context, 
              MaterialPageRoute(
                builder: (context) => AllergiesGroup(title: 'Allergies & Reactions', list: allergiesAndReactionsGroup.list),
              )
            );
          },
        )
      );
    }

    if (healthAlertsGroup != null) {
      lx.add(
        AllergiesItem(
          name: 'Health Alerts',
          onTap: () {
            Navigator.push(context, 
              MaterialPageRoute(
                builder: (context) => AllergiesGroup(title: 'Health Alerts', list: healthAlertsGroup.list),
              )
            );
          },
        )
      );
    }

    return lx;
  }

  Widget _buildContent() {
    if (groupList.isEmpty) {
      return ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'You do not have any drug allergies and medical alerts at the moment.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF727272),
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      );
    }

    return Scrollbar(
      child: buildList(),
    );
  }

  Widget buildContent() {
    if (isLoading) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.only(top: 40.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color.fromRGBO(133, 133, 133, 0.29),
            offset: Offset(5, 4),
            blurRadius: 10.0,
            spreadRadius: 1,
          ),
        ],
      ),
      child: RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: onRefresh,
        color: kPrimaryColor,
        child: _buildContent(),
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.0, top: 20.0),
          child: Container(
            width: 80.0,
            height: 60.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                image: AssetImage('images/icon/page-header-icon/allergies.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 20.0, top: 20.0),
            child: Text(
              'View Drug Allergies and Medical Alerts',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLayer2() {
    var padding = MediaQuery.of(context).padding;

    return Container(
      height: MediaQuery.of(context).size.height - padding.top - kAppToolbarHeight - padding.bottom,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            buildHeader(),
            Flexible(
              child: buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLayer1() {
    return Container(
      width: double.infinity,
      height: 160.0,
      color: kAllergiesBgColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kAllergiesBgColor,
        leadingWidth: 100.0,
        leading: BackBtn(color: Colors.white),
        elevation: 0.0,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: AppActivityIndicator(), // AppScalingText('Loading...'),
        child: SafeArea(
          child: Stack(
            children: [
              buildLayer1(),
              buildLayer2(),
            ],
          ),
        ),
      ),
    );
  }
}

class AllergiesItem extends StatelessWidget {

  final String name;
  final void Function() onTap;

  AllergiesItem({
    @required this.name,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 10.0, top: 25.0, bottom: 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$name',
              style: TextStyle(
                fontSize: 18.0,
                color: Color(0xFF727272),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: kAllergiesBgColor,
            ),
          ],
        ),
      ),
    );
  }
}