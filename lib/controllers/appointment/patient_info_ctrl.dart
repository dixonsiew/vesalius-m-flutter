import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/country_data.dart';
import 'package:vesalius_m_flutter/models/patient_info_data.dart';

class PatientInfoCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isValid = false.obs;
  final _nationalityList = <String>[].obs;
  final _countryList = <Country>[].obs;
  final _patientType = 'New Patient'.obs;
  final _selectedGender = ''.obs;
  final _selectedMarital = ''.obs;
  final _selectedNationality = ''.obs;
  final _selectedCountry = Rx<Country?>(null);
  final _patient = Rx<PatientForm?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsValid(bool b) {
    _isValid.value = b;
  }

  void setNationalityList(List<String> lx) {
    _nationalityList.clear();
    _nationalityList.addAllIf(lx.isNotEmpty, lx);
  }

  void setCountryList(List<Country> lx) {
    _countryList.clear();
    _countryList.addAllIf(lx.isNotEmpty, lx);
  }

  void setPatientType(String s) {
    _patientType.value = s;
  }

  void setSelectedGender(String s) {
    _selectedGender.value = s;
  }

  void setSelectedMarital(String s) {
    _selectedMarital.value = s;
  }

  void setSelectedNationality(String s) {
    _selectedNationality.value = s;
  }

  void setSelectedCountry(Country? o) {
    _selectedCountry.value = o;
  }

  void setPatient(PatientForm? o) {
    _patient.value = o;
  }

  bool get isLoading => _isLoading.value;
  bool get isValid => _isValid.value;
  List<String> get nationalityList => [..._nationalityList];
  List<Country> get countryList => [..._countryList];
  String get patientType => _patientType.value;
  String get selectedGender => _selectedGender.value;
  String get selectedMarital => _selectedMarital.value;
  String get selectedNationality => _selectedNationality.value;
  Country? get selectedCountry => _selectedCountry.value;
  PatientForm? get patient => _patient.value;
}