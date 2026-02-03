import 'package:get/get.dart';

class ResetPasswordCtrl extends GetxController {

  final _isLoading = false.obs;
  final _inputIndex = RxInt(-1);
  final _isValid = false.obs;
  final _isValidArr = <bool>[false, false, false, false, false].obs;
  final _isPwd = true.obs;
  final _isCfmPwd = true.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setInputIndex(int i) {
    _inputIndex.value = i;
  }

  void setIsValid(bool b) {
    _isValid.value = b;
  }

  void setIsPwd(bool b) {
    _isPwd.value = b;
  }

  void setIsCfmPwd(bool b) {
    _isCfmPwd.value = b;
  }

  void setValid(int i, bool b) {
    _isValidArr[i] = b;
  }

  bool get isLoading => _isLoading.value;
  int get inputIndex => _inputIndex.value;
  bool get isValid => _isValid.value;
  List<bool> get isValidArr => [..._isValidArr];
  bool get isPwd => _isPwd.value;
  bool get isCfmPwd => _isCfmPwd.value;
}