import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';

class RescheduleAppointment3Ctrl extends GetxController {

  final _isLoading = false.obs;
  final _slot = Rx<AvailableSlot?>(null);
  final _xslot = Rx<AvailableSlot?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setSlot(AvailableSlot? o) {
    _slot.value = o;
  }

  void setXSlot(AvailableSlot? o) {
    _xslot.value = o;
  }

  bool get isLoading => _isLoading.value;
  AvailableSlot? get slot => _slot.value;
  AvailableSlot? get xslot => _xslot.value;
}