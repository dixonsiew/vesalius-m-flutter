import 'package:get/get.dart';

class FeedbackXCtrl extends GetxController {

  final _select = 'Please Select'.obs;

  void setSelect(String s) {
    _select.value = s;
  }

  String get select => _select.value;
}