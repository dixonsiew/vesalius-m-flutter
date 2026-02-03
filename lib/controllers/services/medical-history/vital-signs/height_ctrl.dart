import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class HeightCtrl extends GetxController {

  final _isLoading = false.obs;
  final _list = <VitalSignsData>[].obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setList(List<VitalSignsData> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  bool get isLoading => _isLoading.value;
  List<VitalSignsData> get list => [..._list];
}