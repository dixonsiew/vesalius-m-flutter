import 'package:get/get.dart';

class SignUpCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isPwd = true.obs;
  final _isValid = true.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsPwd(bool b) {
    _isPwd.value = b;
  }

  void setIsValid(bool b) {
    _isValid.value = b;
  }

  bool get isLoading => _isLoading.value;
  bool get isPwd => _isPwd.value;
  bool get isValid => _isValid.value;
}