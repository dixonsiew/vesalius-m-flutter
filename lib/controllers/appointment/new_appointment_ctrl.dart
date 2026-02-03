import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class NewAppointmentCtrl extends GetxController {

  final _isLoading = false.obs;
  final _case = ''.obs;
  final _xcase = ''.obs;
  final _patient = Rx<RetPatient?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setCaseType(String s) {
    _case.value = s;
  }

  void setXCaseType(String s) {
    _xcase.value = s;
  }

  void setRetPatient(RetPatient? o) {
    _patient.value = o;
  }

  bool get isLoading => _isLoading.value;
  String get caseType => _case.value;
  String get xcaseType => _xcase.value;
  RetPatient? get patient => _patient.value;

  String get caseTypeCode => caseType == 'Follow Up' ? 'FU' : 'NC';
}