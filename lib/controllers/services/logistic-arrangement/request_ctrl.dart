import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/doctype_data.dart';
import 'package:vesalius_m_flutter/models/family_data.dart';
import 'package:vesalius_m_flutter/models/logistic_arrangement_data.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';

class RequestCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isValid = false.obs;
  final _selectedDocType = Rx<DocType?>(null);
  final _nationalityList = <String>[].obs;
  final _user = Rx<UserDetails?>(null);
  final _patient = Rx<PatientDetails?>(null);
  final _isSelf = false.obs;
  final _selectedPatient = Rx<Family?>(null);
  final _selectedNationality = ''.obs;
  final _selectedDoctor = ''.obs;
  final _visitWithCompanion = 'No'.obs;
  final _reqForm = Rx<LogisticReqForm?>(null);
  final _reqForm2 = Rx<LogisticReqForm2?>(null);
  final _reqForm3 = Rx<LogisticReqForm3?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setUserDetails(UserDetails? o) {
    _user.value = o;
  }

  void setPatientDetails(PatientDetails? o) {
    _patient.value = o;
  }

  void setIsValid(bool b) {
    _isValid.value = b;
  }

  void setSelectedDocType(DocType? o) {
    _selectedDocType.value = o;
  }

  void setNationalityList(List<String> lx) {
    _nationalityList.clear();
    _nationalityList.addAllIf(lx.isNotEmpty, lx);
  }

  void setSelf(bool b) {
    _isSelf.value = b;
  }

  void setSelectedPatient(Family? o) {
    _selectedPatient.value = o;
  }

  void setSelectedNationality(String s) {
    _selectedNationality.value = s;
  }

  void setSelectedDoctor(String s) {
    _selectedDoctor.value = s;
  }

  void setVisitWithCompanion(String s) {
    _visitWithCompanion.value = s;
  }
  
  void setReqForm(LogisticReqForm? o) {
    _reqForm.value = o;
  }

  void setReqForm2(LogisticReqForm2? o) {
    _reqForm2.value = o;
  }

  void setReqForm3(LogisticReqForm3? o) {
    _reqForm3.value = o;
  }

  bool get isLoading => _isLoading.value;
  UserDetails? get user => _user.value;
  PatientDetails? get patient => _patient.value;
  bool get isValid => _isValid.value;
  DocType? get selectedDocType => _selectedDocType.value;
  List<String> get nationalityList => [..._nationalityList];
  bool get isSelf => _isSelf.value;
  Family? get selectedPatient => _selectedPatient.value;
  String get selectedNationality => _selectedNationality.value;
  String get selectedDoctor => _selectedDoctor.value;
  String get visitWithCompanion => _visitWithCompanion.value;
  LogisticReqForm? get reqForm => _reqForm.value;
  LogisticReqForm2? get reqForm2 => _reqForm2.value;
  LogisticReqForm3? get reqForm3 => _reqForm3.value;
}