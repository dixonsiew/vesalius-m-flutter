import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/medical-history/no_record.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/medical-history/allergies_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/allergy_data.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';
import 'package:vesalius_m_flutter/ui/services/medical-history/allergies/allergies_group.dart';

class Allergies extends StatefulWidget {

  const Allergies({super.key});

  @override
  State<Allergies> createState() => _AllergiesState();
}

class _AllergiesState extends State<Allergies> {

  //List otherAllergies = [];
  ScrollController scr = ScrollController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final AllergiesCtrl ctrl = Get.put(AllergiesCtrl());

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      await AuthManager.instance.load();
      UserBranch? branchDetails = DataManager.instance.branchDetails;
      List<Allergy> lx = await VesaliusService.getPatientAllergies(branchDetails!.branch!.branchId!, branchDetails.prn!);
      List<AllergyGroup> lg = [];
      for (Allergy o in lx) {
        AllergyGroup? k = lg.firstWhereOrNull((x) => x.alertType == o.alertType);
        if (k == null) {
          k = AllergyGroup(
            alertType: o.alertType,
            list: []
          );
          lg.add(k);
        }

        List<Allergy> la = k.list;
        la.add(o);
        k.list = la;
      }
      await sortList(lg);
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, load);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  Future<void> sortList(List<AllergyGroup> lg) async {
    AllergyGroup? medicalAlertGroup;
    AllergyGroup? allergiesAndReactionsGroup;
    AllergyGroup? healthAlertsGroup;
    AllergyGroup? infectiousDiseaseGroup;
    for (AllergyGroup o in lg) {
      String s = o.alertType!;
      if (s == 'CLINICAL ALERT') {
        medicalAlertGroup = o;
      }

      else if (s == 'CLINICAL ALLERGY' || s == 'GENERAL ALLERGY') {
        if (allergiesAndReactionsGroup == null) {
          allergiesAndReactionsGroup = o;
        }

        else {
          List<Allergy> la = allergiesAndReactionsGroup.list;
          List<Allergy> lb = o.list;
          la.addAll(lb);
        }
      }

      else if (s == 'GENERAL ALERT') {
        healthAlertsGroup = o;
      }

      else if (s == 'INFECTIOUS DISEASE') {
        infectiousDiseaseGroup = o;
      }
    }

    ctrl.init();
    ctrl.setGroupList(lg);
    ctrl.setMedicalAlertGroup(medicalAlertGroup);
    ctrl.setAllergiesAndReactionsGroup(allergiesAndReactionsGroup);
    ctrl.setHealthAlertsGroup(healthAlertsGroup);
    ctrl.setInfectiousDiseaseGroup(infectiousDiseaseGroup);
    ctrl.setIsLoading(false);
    await DataManager.instance.setItem('allergies', lg);
  }

  Widget buildList() {
    return ListView(
      controller: scr,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      children: _buildList(),
    );
  }

  List<Widget> _buildList() {
    List<Widget> lx = [
      const SizedBox(height: 18.0),
    ];
    if (ctrl.medicalAlertGroup != null) {
      lx.add(
        AllergiesItem(
          name: 'Medical Alerts',
          onTap: () {
            Get.to(() => AllergiesGroup(title: 'Medical Alert', list: ctrl.medicalAlertGroup!.list));
          },
        )
      );
    }

    if (ctrl.allergiesAndReactionsGroup != null) {
      lx.add(
        AllergiesItem(
          name: 'Allergies & Reactions',
          onTap: () {
            Get.to(() => AllergiesGroup(title: 'Allergies & Reactions', list: ctrl.allergiesAndReactionsGroup!.list));
          },
        ),
      );
    }

    if (ctrl.healthAlertsGroup != null) {
      lx.add(
        AllergiesItem(
          name: 'Health Alerts',
          onTap: () {
            Get.to(() => AllergiesGroup(title: 'Health Alerts', list: ctrl.healthAlertsGroup!.list));
          },
        ),
      );
    }

    if (ctrl.infectiousDiseaseGroup != null) {
      lx.add(
        AllergiesItem(
          name: 'Infectious Disease',
          onTap: () {
            Get.to(() => AllergiesGroup(title: 'Infectious Disease', list: ctrl.infectiousDiseaseGroup!.list));
          },
        ),
      );
    }

    return lx;
  }

  Widget _buildContent() {
    return Scrollbar(
      controller: scr,
      child: buildList(),
    );
  }

  Widget buildContent() {
    if (ctrl.isLoading) {
      return Container();
    }

    if (ctrl.groupList.isEmpty) {
      return const NoRecord(msg: 'You do not have any drug allergies and medical alert captured at the moment.');
    }

    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: onRefresh,
      color: kPrimaryColor,
      child: _buildContent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Allergies',
      body: SafeArea(
        child: Obx(() => 
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: buildContent(),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            blurRadius: 7.0,
            color: kBgColor2.withValues(alpha: 0.7),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(5.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
            child: Text(
              name,
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: kTextColor1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}