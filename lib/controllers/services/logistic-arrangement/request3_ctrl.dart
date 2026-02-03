import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/logistic_arrangement_data.dart';

class Request3Ctrl extends GetxController {

  final _isValid = false.obs;
  final _selectedSlot = Rx<LogisticSlot?>(null);

  void setIsValid(bool b) {
    _isValid.value = b;
  }

  void setSelectedSlot(LogisticSlot? o) {
    _selectedSlot.value = o;
  }

  bool get isValid => _isValid.value;
  LogisticSlot? get selectedSlot => _selectedSlot.value;
}