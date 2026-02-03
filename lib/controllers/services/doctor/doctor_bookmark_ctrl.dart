import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

class DoctorBookmarkCtrl extends GetxController {

  final _isLoading = false.obs;
  final _list = <DoctorInfo>[].obs;
  final _mlist = <DoctorInfo>[].obs;

  void init() {
    _list.clear();
    _mlist.clear();
  }

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setList(List<DoctorInfo> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    _mlist.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
      _mlist.clear();
    }
  }

  void resetList() {
    _list.clear();
    _list.addAll(_mlist);
  }

  void setFilteredList(List<DoctorInfo> lx) {
    _list.clear();
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  bool get isLoading => _isLoading.value;
  List<DoctorInfo> get list => [..._list];
  List<DoctorInfo> get mlist => [..._mlist];
}