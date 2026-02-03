import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/goldenclub_data.dart';

class ClubActivitiesCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _page = 1.obs;
  final _list = <GoldenPearlActivity>[].obs;

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

  void setList(List<GoldenPearlActivity> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  int get page => _page.value;
  List<GoldenPearlActivity> get list => [..._list];
}