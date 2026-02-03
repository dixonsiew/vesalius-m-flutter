import 'package:get/get.dart';

class BiometricCtrl extends GetxController {

  final _isLoading = false.obs;
  final _type = 'fingerprint'.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setType(String s) {
    _type.value = s;
  }

  bool get isLoading => _isLoading.value;
  String get label => _type.value == 'fingerprint' ? 'Fingerprint' : 'Face ID';
  String get name => _type.value == 'fingerprint' ? 'fingerprint' : 'Face ID';
}