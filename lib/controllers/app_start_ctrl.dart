import 'package:get/get.dart';

class AppStartCtrl extends GetxController {

  final _current = 0.obs;

  void setCurrent(int i) {
    _current.value = i;
  }

  int get current => _current.value;
}