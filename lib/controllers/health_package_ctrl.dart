import 'package:get/get.dart';

class HealthPackageCtrl extends GetxController {

  final _count = 0.obs;

  void setCount(int i) {
    _count.value += i;
  }

  int get count => _count.value;
}

class HealthPackageDetailCtrl extends GetxController {

  final _count = 0.obs;

  void setCount(int i) {
    _count.value = i;
  }

  int get count => _count.value;
}