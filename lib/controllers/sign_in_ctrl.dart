import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/country_data.dart';

enum SignInOpt { mobile, email }

class SignInCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isPwd = true.obs;
  final _signInOpt = Rx<SignInOpt?>(null);
  final _countryList = <Country>[].obs;
  final _telList = <CountryTel>[].obs;
  final _selectedCountry = Rx<Country?>(null);
  final _selectedTel = Rx<CountryTel?>(null);
  final _isValid = true.obs;
  final _isBiometricEnabled = false.obs;
  final _version = ''.obs;
  final _build = '1'.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsPwd(bool b) {
    _isPwd.value = b;
  }

  void setSignInOpt(SignInOpt? o) {
    _signInOpt.value = o;
  }

  void setCountryList(List<Country> lx) {
    _countryList.clear();
    _countryList.addAllIf(lx.isNotEmpty, lx);
  }

  void setTelList(List<CountryTel> lx) {
    _telList.clear();
    _telList.addAllIf(lx.isNotEmpty, lx);
  }

  void setSelectedCountry(Country? o) {
    _selectedCountry.value = o;
  }

  void setSelectedTel(CountryTel? o) {
    _selectedTel.value = o;
  }

  void setIsValid(bool b) {
    _isValid.value = b;
  }

  void setIsBiometricEnabled(bool b) {
    _isBiometricEnabled.value = b;
  }

  void setVersion(String s) {
    _version.value = s;
  }

  void setBuild(String s) {
    _build.value = s;
  }

  bool get isLoading => _isLoading.value;
  bool get isPwd => _isPwd.value;
  SignInOpt? get signInOpt => _signInOpt.value;
  List<Country> get countryList => [..._countryList];
  List<CountryTel> get telList => [..._telList];
  Country? get selectedCountry => _selectedCountry.value;
  CountryTel? get selectedTel => _selectedTel.value;
  bool get isValid => _isValid.value;
  bool get isBiometricEnabled => _isBiometricEnabled.value;
  String get version => _version.value;
  String get build => _build.value;
}