import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

class DoctorCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _page = 1.obs;
  final _keyword = ''.obs;
  final _list = <DoctorInfo>[].obs;
  final _bookmarkedInfoId = <String>[].obs;

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

  void setKeyword(String s) {
    _keyword.value = s;
  }

  void setList(List<DoctorInfo> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  void setBookmarkedInfoId(List<String> lx) {
    _bookmarkedInfoId.clear();
    _bookmarkedInfoId.addAllIf(lx.isNotEmpty, lx);
  }

  bool hasBookmarkedInfoId(String mcr) {
    return _bookmarkedInfoId.any((o) => o == mcr);
  }

  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  int get page => _page.value;
  String get keyword => _keyword.value;
  List<DoctorInfo> get list => [..._list];
  List<String> get bookmarkedInfoId => [..._bookmarkedInfoId];
}