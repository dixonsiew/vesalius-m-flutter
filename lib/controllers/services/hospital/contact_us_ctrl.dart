import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/hospital_data.dart';

class ContactUsCtrl extends GetxController {

  final _isLoading = false.obs;
  final _data = Rx<HospitalInfo?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setData(HospitalInfo? o) {
    _data.value = o;
  }

  bool get isLoading => _isLoading.value;
  HospitalInfo? get data => _data.value;
}