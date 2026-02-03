import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/country_data.dart';
import 'package:vesalius_m_flutter/models/doctype_data.dart';

class RegisterExp2Ctrl extends GetxController {

  final _isLoading = false.obs;
  final _isValid = false.obs;
  final _nationalityList = <String>[].obs;
  final _telList = <CountryTel>[].obs;
  final _isRegisterSelf = false.obs;
  final _selectedDocType = Rx<DocType?>(null);
  final _selectedGender = ''.obs;
  final _selectedNationality = ''.obs;
  final _selectedTel = Rx<CountryTel?>(null);
  final _selectedHomeTel = Rx<CountryTel?>(null);

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

  void setTelList(List<CountryTel> lx) {
    _telList.clear();
    _telList.addAllIf(lx.isNotEmpty, lx);
  }

  void setRegisterSelf(bool b) {
    _isRegisterSelf.value = b;
  }

  void setSelectedDocType(DocType? o) {
    _selectedDocType.value = o;
  }

  void setSelectedGender(String s) {
    _selectedGender.value = s;
  }

  void setSelectedNationality(String s) {
    _selectedNationality.value = s;
  }

  void setSelectedTel(CountryTel? o) {
    _selectedTel.value = o;
  }

  void setSelectedHomeTel(CountryTel? o) {
    _selectedHomeTel.value = o;
  }

  bool get isLoading => _isLoading.value;
  bool get isValid => _isValid.value;
  List<String> get nationalityList => [..._nationalityList];
  List<CountryTel> get telList => [..._telList];
  bool get isRegisterSelf => _isRegisterSelf.value;
  DocType? get selectedDocType => _selectedDocType.value;
  String get selectedGender => _selectedGender.value;
  String get selectedNationality => _selectedNationality.value;
  CountryTel? get selectedTel => _selectedTel.value;
  CountryTel? get selectedHomeTel => _selectedHomeTel.value;
}