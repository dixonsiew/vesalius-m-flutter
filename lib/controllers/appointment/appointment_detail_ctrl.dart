import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

class AppointmentDetailCtrl extends GetxController {

  final _isLoading = false.obs;
  final _docInfo = Rx<DoctorInfo?>(null);
  final _patientName = ''.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setDocInfo(DoctorInfo? o) {
    _docInfo.value = o;
  }

  void setPatientName(String s) {
    _patientName.value = s;
  }

  bool get isLoading => _isLoading.value;
  DoctorInfo? get doctorInfo => _docInfo.value;
  String get patientName => _patientName.value;
}