import 'package:get/get.dart';

class NewAppointmentCtrl extends GetxController {

  final _isLoading = false.obs;
  final _case = ''.obs;
  final _xcase = ''.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setCaseType(String s) {
    _case.value = s;
  }

  void setXCaseType(String s) {
    _xcase.value = s;
  }

  bool get isLoading => _isLoading.value;
  String get caseType => _case.value;
  String get xcaseType => _xcase.value;

  String get caseTypeCode => caseType == 'Follow Up' ? 'FU' : 'NC';
}