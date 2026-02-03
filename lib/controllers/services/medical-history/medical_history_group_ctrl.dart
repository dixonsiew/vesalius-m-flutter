import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class MedicalHistoryGroupCtrl extends GetxController {

  final _isLoading = false.obs;
  final _list = <PatientVisit>[].obs;

  void init() {
    _list.clear();
  }

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setList(List<PatientVisit> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  bool get isLoading => _isLoading.value;
  List<PatientVisit> get list => [..._list];
}