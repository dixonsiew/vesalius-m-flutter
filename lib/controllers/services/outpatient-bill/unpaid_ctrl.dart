import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/bill_data.dart';

class UnpaidCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _page = 1.obs;
  final _data = Rx<OutstandingBill?>(null);

  void setInit() {
    //_list.clear();
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

  void setData(OutstandingBill? o) {
    _data.value = o;
  }

  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  int get page => _page.value;
  OutstandingBill? get data => _data.value;
}