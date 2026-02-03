import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class ProfileCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isBiometricEnabled = false.obs;
  final _patientDetails = Rx<PatientDetails?>(null);
  final _version = ''.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsBiometricEnabled(bool b) {
    _isBiometricEnabled.value = b;
  }

  void setPatientDetails(PatientDetails? o) {
    _patientDetails.value = o;
  }

  void setVersion(String s) {
    _version.value = s;
  }

  bool get isLoading => _isLoading.value;
  bool get isBiometricEnabled => _isBiometricEnabled.value;
  PatientDetails? get patientDetails => _patientDetails.value;
  String get version => _version.value;
}