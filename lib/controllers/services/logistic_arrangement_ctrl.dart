import 'package:get/get.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/logistic_arrangement_data.dart';
import 'package:vesalius_m_flutter/services/logistic_service.dart';

class LogisticArrangementCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _page = 1.obs;
  final _list = <LogisticRequest>[].obs;

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

  void setList(List<LogisticRequest> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  Future<void> load() async {
    List<LogisticRequest> lx = await LogisticService.getAllLogisticRequests(page, kPageSize);
    setList(lx);
  }

  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  int get page => _page.value;
  List<LogisticRequest> get list => [..._list];
}