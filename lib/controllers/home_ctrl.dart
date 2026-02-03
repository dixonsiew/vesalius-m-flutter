import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class HomeCtrl extends GetxController {

  final _isLoading = false.obs;
  final _patientDetails = Rx<PatientDetails?>(null);
  final _current = 0.obs;
  final _appointment = Rx<PatientAppointment?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setPatientDetails(PatientDetails? o) {
    _patientDetails.value = o;
  }

  void setCurrent(int i) {
    _current.value = i;
  }

  void setAppointment(PatientAppointment? o) {
    _appointment.value = o;
  }

  bool get isLoading => _isLoading.value;
  PatientDetails? get patientDetails => _patientDetails.value;
  int get current => _current.value;
  PatientAppointment? get appointment => _appointment.value;
}