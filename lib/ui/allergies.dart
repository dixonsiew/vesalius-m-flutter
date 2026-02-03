import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/allergy.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/ui/allergies/allergies_group.dart';

class Allergies extends StatefulWidget {

  static const String routeName = 'Allergies';

  const Allergies({super.key});

  @override
  State<Allergies> createState() => _AllergiesState();
}

class _AllergiesState extends State<Allergies> {

  List<AllergyGroup> groupList = [];
  AllergyGroup? medicalAlertGroup;
  AllergyGroup? allergiesAndReactionsGroup;
  AllergyGroup? healthAlertsGroup;
  AllergyGroup? infectiousDiseaseGroup;
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
      var lx = await getPatientAllergies(branchDetails!.branch!.branchId!, branchDetails.prn!);
      List<AllergyGroup> lg = [];
      for (var o in lx) {
        var k = lg.firstWhereOrNull((x) => x.alertType == o.alertType);
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
      }
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
    AllergyGroup? mmedicalAlertGroup;
    AllergyGroup? mallergiesAndReactionsGroup;
    AllergyGroup? mhealthAlertsGroup;
    AllergyGroup? minfectiousDiseaseGroup;
    for (var o in lg) {
      String s = o.alertType ?? '';
      if (s == 'CLINICAL ALERT') {
        mmedicalAlertGroup = o;
      }

      else if (s == 'CLINICAL ALLERGY' || s == 'GENERAL ALLERGY') {
        if (mallergiesAndReactionsGroup == null) {
          mallergiesAndReactionsGroup = o;
        }

        else {
          var la = mallergiesAndReactionsGroup.list;
          var lb = o.list;
          la.addAll(lb);
        }
      }

      else if (s == 'GENERAL ALERT') {
        mhealthAlertsGroup = o;
      }

      else if (s == 'INFECTIOUS DISEASE') {
        minfectiousDiseaseGroup = o;
      }
    }

    setState(() {
      groupList = lg;
      medicalAlertGroup = mmedicalAlertGroup;
      allergiesAndReactionsGroup = mallergiesAndReactionsGroup;
      healthAlertsGroup = mhealthAlertsGroup;
      infectiousDiseaseGroup = minfectiousDiseaseGroup;
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AllergiesGroup(
                  title: 'Medical Alert',
                  list: medicalAlertGroup!.list,
                ),
              )
            );
          },
        )
      );
    }

    if (allergiesAndReactionsGroup != null) {
      lx.addAll([
        const Divider(
          color: Color(0xFFE2E2E2),
          height: 1.0,
          thickness: 1.0,
        ),
        AllergiesItem(
          name: 'Allergies & Reactions',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AllergiesGroup(
                  title: 'Allergies & Reactions',
                  list: allergiesAndReactionsGroup!.list,
                ),
              )
            );
          },
        ),
      ]);
    }

    if (healthAlertsGroup != null) {
      lx.addAll([
        const Divider(
          color: Color(0xFFE2E2E2),
          height: 1.0,
          thickness: 1.0,
        ),
        AllergiesItem(
          name: 'Health Alerts',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AllergiesGroup(
                  title: 'Health Alerts',
                  list: healthAlertsGroup!.list,
                ),
              )
            );
          },
        ),
      ]);
    }

    if (infectiousDiseaseGroup != null) {
      lx.addAll([
        const Divider(
          color: Color(0xFFE2E2E2),
          height: 1.0,
          thickness: 1.0,
        ),
        AllergiesItem(
          name: 'Infectious Disease',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AllergiesGroup(
                  title: 'Infectious Disease',
                  list: infectiousDiseaseGroup!.list,
                ),
              )
            );
          },
        ),
      ]);
    }

    return lx;
  }

  Widget _buildContent() {
    if (groupList.isEmpty) {
      return ListView(
        shrinkWrap: true,
        children: const [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'You do not have any drug allergies and medical alerts at the moment.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF727272),
                fontSize: 16.0,
                fontFamily: kBodyFont,
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
      margin: const EdgeInsets.only(top: 40.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.white,
        boxShadow: [
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
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'images/icon/page-header-icon/allergies.png',
            width: 65.0,
            height: 50.0,
            fit: BoxFit.contain,
          ),
          const Flexible(
            child: Text(
              'View Drug Allergies and Medical Alerts',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: kTitleFont,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLayer2() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          height: 160.0,
          color: kAllergiesBgColor,
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
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kAllergiesBgColor),
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kAllergiesBgColor,
        leadingWidth: 100.0,
        leading: const BackBtn(color: Colors.white),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(), // AppScalingText('Loading...'),
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

  const AllergiesItem({
    super.key, 
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 25.0, bottom: 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: kBodyFont,
                color: Color(0xFF727272),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              color: kAllergiesBgColor,
            ),
          ],
        ),
      ),
    );
  }
}