import 'package:get/get.dart';

class BiometricCtrl extends GetxController {

  final _type = 'fingerprint'.obs;

  void setType(String s) {
    _type.value = s;
  }

  String get label => _type.value == 'fingerprint' ? 'Fingerprint' : 'Face ID';
  String get name => _type.value == 'fingerprint' ? 'fingerprint' : 'Face ID';
}