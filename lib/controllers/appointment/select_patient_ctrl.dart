import 'package:get/get.dart';

class SelectPatientCtrl extends GetxController {

  final _name = ''.obs;

  void setName(String s) {
    _name.value = s;
  }

  String get name => _name.value;
}