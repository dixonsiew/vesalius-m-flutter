import 'package:get/get.dart';

class VerifyEmailCodeCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isValid = false.obs;
  final _digits = ''.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsValid(bool b) {
    _isValid.value = b;
  }

  void setDigits(String s) {
    _digits.value = s;
    if (s.length == 6) {
      setIsValid(true);
    }

    else {
      setIsValid(false);
    }
  }

  bool get isLoading => _isLoading.value;
  bool get isValid => _isValid.value;
  String get digits => _digits.value;
}