import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/family_data.dart';
import 'package:vesalius_m_flutter/models/user_package_purchase_data.dart';

class SelectPatientCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _page = 1.obs;
  final _list = <Family>[].obs;
  final _family = Rx<Family?>(null);
  final _xfamily = Rx<Family?>(null);
  final _selectPatient = false.obs;
  final _isFromPackage = false.obs;
  final _userPackagePurchase = Rx<UserPackagePurchase?>(null);

  void init() {
    setPage(1);
    _list.clear();
  }

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsLoadingMore(bool b) {
    _isLoadingMore.value = b;
  }

  void setPage(int i) {
    _page.value = i;
  }

  void setList(List<Family> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  void setFamily(Family? o) {
    _family.value = o;
  }

  void setXFamily(Family? o) {
    _xfamily.value = o;
  }

  void setSelectPatient(bool b) {
    _selectPatient.value = b;
  }

  void setIsFromPackage(bool b) {
    _isFromPackage.value = b;
  }

  void setUserPackagePurchase(UserPackagePurchase? o) {
    _userPackagePurchase.value = o;
  }

  Family? get family => _family.value;
  Family? get xfamily => _xfamily.value;
  bool get selectPatient => _selectPatient.value;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get isFromPackage => _isFromPackage.value;
  UserPackagePurchase? get userPackagePurchase => _userPackagePurchase.value;
  int get page => _page.value;
  List<Family> get list => [..._list];
}