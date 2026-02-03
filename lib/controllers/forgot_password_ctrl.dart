import 'package:get/get.dart';

class ForgotPasswordCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isValid = false.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsValid(bool b) {
    _isValid.value = b;
  }

  bool get isLoading => _isLoading.value;
  bool get isValid => _isValid.value;
}