import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/allergy.dart';

class AllergiesCtrl extends GetxController {

  final _isLoading = false.obs;
  final _groupList = <AllergyGroup>[].obs;
  final _medicalAlertGroup = Rx<AllergyGroup?>(null);
  final _allergiesAndReactionsGroup = Rx<AllergyGroup?>(null);
  final _healthAlertsGroup = Rx<AllergyGroup?>(null);
  final _infectiousDiseaseGroup = Rx<AllergyGroup?>(null);

  void init() {
    _groupList.clear();
  }

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setGroupList(List<AllergyGroup> lx) {
    _groupList.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _groupList.clear();
    }
  }

  void setMedicalAlertGroup(AllergyGroup? o) {
    _medicalAlertGroup.value = o;
  }

  void setAllergiesAndReactionsGroup(AllergyGroup? o) {
    _allergiesAndReactionsGroup.value = o;
  }

  void setHealthAlertsGroup(AllergyGroup? o) {
    _healthAlertsGroup.value = o;
  }

  void setInfectiousDiseaseGroup(AllergyGroup? o) {
    _infectiousDiseaseGroup.value = o;
  }

  bool get isLoading => _isLoading.value;
  List<AllergyGroup> get groupList => [..._groupList];
  AllergyGroup? get medicalAlertGroup => _medicalAlertGroup.value;
  AllergyGroup? get allergiesAndReactionsGroup => _allergiesAndReactionsGroup.value;
  AllergyGroup? get healthAlertsGroup => _healthAlertsGroup.value;
  AllergyGroup? get infectiousDiseaseGroup => _infectiousDiseaseGroup.value;
}