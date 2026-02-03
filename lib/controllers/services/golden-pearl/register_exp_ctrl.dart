import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/doctype_data.dart';
import 'package:vesalius_m_flutter/models/goldenpearlmembership_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';

class RegisterExpCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isValid = false.obs;
  final _nationalityList = <String>[].obs;
  final _user = Rx<UserDetails?>(null);
  final _isRegisterSelf = false.obs;
  final _goldenPearlMembershipForm = Rx<GoldenPearlMembershipForm?>(null);
  final _nokForm = Rx<NokForm?>(null);
  final _selectedDocType = Rx<DocType?>(null);
  final _selectedGender = ''.obs;
  final _selectedNationality = ''.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setUserDetails(UserDetails? o) {
    _user.value = o;
  }

  void setIsValid(bool b) {
    _isValid.value = b;
  }

  void setNationalityList(List<String> lx) {
    _nationalityList.clear();
    _nationalityList.addAllIf(lx.isNotEmpty, lx);
  }

  void setRegisterSelf(bool b) {
    _isRegisterSelf.value = b;
  }

  void setMembershipForm(GoldenPearlMembershipForm? o) {
    _goldenPearlMembershipForm.value = o;
  }

  void setNokForm(NokForm? o) {
    _nokForm.value = o;
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

  bool get isLoading => _isLoading.value;
  UserDetails? get user => _user.value;
  bool get isValid => _isValid.value;
  List<String> get nationalityList => [..._nationalityList];
  bool get isRegisterSelf => _isRegisterSelf.value;
  GoldenPearlMembershipForm? get goldenPearlMembershipForm => _goldenPearlMembershipForm.value;
  NokForm? get nokForm => _nokForm.value;
  DocType? get selectedDocType => _selectedDocType.value;
  String get selectedGender => _selectedGender.value;
  String get selectedNationality => _selectedNationality.value;
}