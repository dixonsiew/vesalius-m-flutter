import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/billing_data.dart';
import 'package:vesalius_m_flutter/models/country_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';

class BillingDetailCtrl extends GetxController {

  final _isLoading = false.obs;
  final _user = Rx<UserDetails?>(null);
  final _isValid = false.obs;
  final _isSameAsProfile = false.obs;
  final _billing = Rx<Billing?>(null);
  final _countryList = <Country>[].obs;
  final _tcountryList = <Country>[].obs;
  final _telList = <CountryTel>[].obs;
  final _selectedCountry = Rx<Country?>(null);
  final _selectedTel = Rx<CountryTel?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setUserDetails(UserDetails? o) {
    _user.value = o;
  }

  void setIsValid(bool b) {
    _isValid.value = b;
  }

  void setIsSameAsProfile(bool b) {
    _isSameAsProfile.value = b;
  }

  void setBilling(Billing? o) {
    _billing.value = o;
  }

  void setCountryList(List<Country> lx) {
    _countryList.clear();
    _tcountryList.clear();
    _countryList.addAllIf(lx.isNotEmpty, lx);
    _tcountryList.addAllIf(lx.isNotEmpty, lx);
  }

  void setTempCountryList(List<Country> lx) {
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

  bool get isLoading => _isLoading.value;
  UserDetails? get user => _user.value;
  bool get isValid => _isValid.value;
  bool get isSameAsProfile => _isSameAsProfile.value;
  Billing? get billing => _billing.value;
  List<Country> get countryList => [..._countryList];
  List<Country> get tcountryList => [..._tcountryList];
  List<CountryTel> get telList => [..._telList];
  Country? get selectedCountry => _selectedCountry.value;
  CountryTel? get selectedTel => _selectedTel.value;
}