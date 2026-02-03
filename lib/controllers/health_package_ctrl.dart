import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/package_data.dart';

class HealthPackageCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _page = 1.obs;
  final _list = <Package>[].obs;

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

  void setList(List<Package> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  int get page => _page.value;
  List<Package> get list => [..._list];
}

class HealthPackageDetailCtrl extends GetxController {

  final _isLoading = false.obs;
  final _count = 1.obs;
  final _expired = 0.obs;
  final _soldout = 0.obs;
  final _availableToPurchase = 0.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setCount(int i) {
    _count.value = i;
  }

  void setExpired(int i) {
    _expired.value = i;
  }

  void setSoldout(int i) {
    _soldout.value = i;
  }

  void setAvailableToPurchase(int i) {
    _availableToPurchase.value = i;
  }

  bool get isLoading => _isLoading.value;
  int get count => _count.value;
  int get expired => _expired.value;
  int get soldout => _soldout.value;
  int get availableToPurchase => _availableToPurchase.value;
}