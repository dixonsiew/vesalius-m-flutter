import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainLayoutCtrl extends GetxController {

  final _index = 0.obs;

  late final PageController pageController;

  void setIndex(int i) {
    _index.value = i;
  }

  int get index => _index.value;
}