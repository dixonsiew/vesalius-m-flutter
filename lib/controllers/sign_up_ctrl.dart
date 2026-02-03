import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/country_data.dart';

enum SignUpOpt { mobile, email }

class SignUpCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isPwd = true.obs;
  final _isCfmPwd = true.obs;
  final _signUpOpt = Rx<SignUpOpt?>(SignUpOpt.email);
  final _countryList = <Country>[].obs;
  final _telList = <CountryTel>[].obs;
  final _selectedCountry = Rx<Country?>(null);
  final _selectedTel = Rx<CountryTel?>(null);
  final _isValid = false.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsPwd(bool b) {
    _isPwd.value = b;
  }

  void setIsCfmPwd(bool b) {
    _isCfmPwd.value = b;
  }

  void setSignUpOpt(SignUpOpt? o) {
    _signUpOpt.value = o;
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

  bool get isLoading => _isLoading.value;
  bool get isPwd => _isPwd.value;
  bool get isCfmPwd => _isCfmPwd.value;
  SignUpOpt? get signUpOpt => _signUpOpt.value;
  List<Country> get countryList => [..._countryList];
  List<CountryTel> get telList => [..._telList];
  Country? get selectedCountry => _selectedCountry.value;
  CountryTel? get selectedTel => _selectedTel.value;
  bool get isValid => _isValid.value;
}