import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

class DoctorDetailCtrl extends GetxController {

  final _isLoading = false.obs;
  final _doctorInfo = Rx<DoctorInfo?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setDoctorInfo(DoctorInfo? o) {
    _doctorInfo.value = o;
  }

  bool get isLoading => _isLoading.value;
  DoctorInfo? get doctorInfo => _doctorInfo.value;
}