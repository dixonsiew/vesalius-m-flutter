import 'package:get/get.dart';

class ChangePasswordCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isCurrentPwd = true.obs;
  final _isNewPwd = true.obs;
  final _isConfirmPwd = true.obs;
  final _isValid = false.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsCurrentPwd(bool b) {
    _isCurrentPwd.value = b;
  }

  void setIsNewPwd(bool b) {
    _isNewPwd.value = b;
  }

  void setIsConfirmPwd(bool b) {
    _isConfirmPwd.value = b;
  }

  void setIsValid(bool b) {
    _isValid.value = b;
  }

  bool get isLoading => _isLoading.value;
  bool get isCurrentPwd => _isCurrentPwd.value;
  bool get isNewPwd => _isNewPwd.value;
  bool get isConfirmPwd => _isConfirmPwd.value;
  bool get isValid => _isValid.value;
}