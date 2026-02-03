import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class VitalSignsCtrl extends GetxController {

  final _isLoading = false.obs;
  final _list = <PatientVisit>[].obs;
  final _patientVisit = Rx<PatientVisit?>(null);

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

  void setPatientVisit(PatientVisit? o) {
    _patientVisit.value = o;
  }

  bool get isLoading => _isLoading.value;
  List<PatientVisit> get list => [..._list];
  PatientVisit? get patientVisit => _patientVisit.value;
}