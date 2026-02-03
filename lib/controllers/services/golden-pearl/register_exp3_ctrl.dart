import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/country_data.dart';

class RegisterExp3Ctrl extends GetxController {

  final _isLoading = false.obs;
  final _isValid = false.obs;
  final _countryList = <Country>[].obs;
  final _selectedCountry = Rx<Country?>(null);
  final _selectedRelationship = ''.obs;
  final _selectedLanguage = ''.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsValid(bool b) {
    _isValid.value = b;
  }

  void setCountryList(List<Country> lx) {
    _countryList.clear();
    _countryList.addAllIf(lx.isNotEmpty, lx);
  }

  void setSelectedCountry(Country? o) {
    _selectedCountry.value = o;
  }

  void setSelectedRelationship(String s) {
    _selectedRelationship.value = s;
  }

  void setSelectedLanguage(String s) {
    _selectedLanguage.value = s;
  }

  bool get isLoading => _isLoading.value;
  bool get isValid => _isValid.value;
  List<Country> get countryList => [..._countryList];
  Country? get selectedCountry => _selectedCountry.value;
  String get selectedRelationship => _selectedRelationship.value;
  String get selectedLanguage => _selectedLanguage.value;
}