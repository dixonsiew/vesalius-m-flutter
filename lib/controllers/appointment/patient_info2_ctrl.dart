import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/country_data.dart';

class PatientInfo2Ctrl extends GetxController {

  final _isLoading = false.obs;
  final _isValid = false.obs;
  final _telList = <CountryTel>[].obs;
  final _selectedTel = Rx<CountryTel?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsValid(bool b) {
    _isValid.value = b;
  }

  void setTelList(List<CountryTel> lx) {
    _telList.clear();
    _telList.addAllIf(lx.isNotEmpty, lx);
  }

  void setSelectedTel(CountryTel? o) {
    _selectedTel.value = o;
  }

  bool get isLoading => _isLoading.value;
  bool get isValid => _isValid.value;
  List<CountryTel> get telList => [..._telList];
  CountryTel? get selectedTel => _selectedTel.value;
}