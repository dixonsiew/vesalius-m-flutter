import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/doctype_data.dart';
import 'package:vesalius_m_flutter/models/kidsmembership_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';

class RegisterExpCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isValid = false.obs;
  final _nationalityList = <String>[].obs;
  final _user = Rx<UserDetails?>(null);
  final _isRegisterSelf = false.obs;
  final _kidsMembershipForm = Rx<KidsMembershipForm?>(null);
  final _kidsGuardianForm = Rx<KidsGuardianForm?>(null);
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

  void setMembershipForm(KidsMembershipForm? o) {
    _kidsMembershipForm.value = o;
  }

  void setGuardianForm(KidsGuardianForm? o) {
    _kidsGuardianForm.value = o;
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
  KidsMembershipForm? get kidsMembershipForm => _kidsMembershipForm.value;
  KidsGuardianForm? get kidsGuardianForm => _kidsGuardianForm.value;
  DocType? get selectedDocType => _selectedDocType.value;
  String get selectedGender => _selectedGender.value;
  String get selectedNationality => _selectedNationality.value;
}