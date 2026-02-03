import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/package_data.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/service_data.dart';

import 'notifications_ctrl.dart';

class HomeCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isLoading1 = false.obs;
  final _isLoading2 = false.obs;
  final _isLoading3 = false.obs;
  final _patientDetails = Rx<PatientDetails?>(null);
  final _current = 0.obs;
  final _currentx = 0.obs;
  final _unseencount = 0.obs;
  final _list = <Package>[].obs;
  final _listService = <AppService>[].obs;
  final _purchase = false.obs;
  
  final NotificationsCtrl ctrl = Get.put(NotificationsCtrl());

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsLoading1(bool b) {
    _isLoading1.value = b;
  }

  void setIsLoading2(bool b) {
    _isLoading2.value = b;
  }

  void setIsLoading3(bool b) {
    _isLoading3.value = b;
  }

  void setPatientDetails(PatientDetails? o) {
    _patientDetails.value = o;
  }

  void setCurrent(int i) {
    _current.value = i;
  }

  void setCurrentX(int i) {
    _currentx.value = i;
  }

  Future<void> setUnseenCount(int n) async {
    _unseencount.value = n;
    int nx = ctrl.list.where((x) => x.isSeen == false).length;
    if (n != nx) {
      ctrl.setIsLoading(true);
      await ctrl.load();
      ctrl.setIsLoading(false);
    }
  }

  void setList(List<Package> lx) {
    _list.clear();
    _list.addAllIf(lx.isNotEmpty, lx);
  }

  void setListService(List<AppService> lx) {
    _listService.clear();
    _listService.addAllIf(lx.isNotEmpty, lx);
  }

  void setPurchase(bool b) {
    _purchase.value = b;
  }

  bool get isLoading => _isLoading.value;
  bool get isLoading1 => _isLoading1.value;
  bool get isLoading2 => _isLoading2.value;
  bool get isLoading3 => _isLoading3.value;
  PatientDetails? get patientDetails => _patientDetails.value;
  int get current => _current.value;
  int get currentx => _currentx.value;
  int get unseencount => _unseencount.value;
  List<Package> get list => [..._list];
  List<AppService> get listService => [..._listService];
  bool get purchase => _purchase.value;
}