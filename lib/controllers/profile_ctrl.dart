import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/hospital_data.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class ProfileCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isBiometricEnabled = false.obs;
  final _patientDetails = Rx<PatientDetails?>(null);
  final _hospitalData = Rx<HospitalInfo?>(null);
  final _purchase = false.obs;
  final _delAccount = false.obs;
  final _version = ''.obs;
  final _build = '1'.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsBiometricEnabled(bool b) {
    _isBiometricEnabled.value = b;
  }

  void setPatientDetails(PatientDetails? o) {
    _patientDetails.value = o;
  }

  void setHospitalData(HospitalInfo? o) {
    _hospitalData.value = o;
  }

  void setPurchase(bool b) {
    _purchase.value = b;
  }

  void setDelAccount(bool b) {
    _delAccount.value = b;
  }

  void setVersion(String s) {
    _version.value = s;
  }

  void setBuild(String s) {
    _build.value = s;
  }

  bool get isLoading => _isLoading.value;
  bool get isBiometricEnabled => _isBiometricEnabled.value;
  PatientDetails? get patientDetails => _patientDetails.value;
  HospitalInfo? get hospitalData => _hospitalData.value;
  bool get purchase => _purchase.value;
  bool get delAccount => _delAccount.value;
  String get version => _version.value;
  String get build => _build.value;
}