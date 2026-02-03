import 'package:get/get.dart';

class RescheduleAppointmentCtrl extends GetxController {

  final _isLoading = false.obs;
  final _date = Rx<DateTime?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setDate(DateTime? dx) {
    _date.value = dx;
  }

  bool get isLoading => _isLoading.value;
  DateTime? get date => _date.value;
}