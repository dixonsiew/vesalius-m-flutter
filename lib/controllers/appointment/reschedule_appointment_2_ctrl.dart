import 'package:get/get.dart';

class RescheduleAppointment2Ctrl extends GetxController {

  final _isLoading = false.obs;
  final _time = 'Select A Time'.obs;
  final _date = Rx<DateTime?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setTime(String s) {
    _time.value = s;
  }

  void setDate(DateTime? dx) {
    _date.value = dx;
  }

  bool get isLoading => _isLoading.value;
  String get time => _time.value;
  DateTime? get date => _date.value;
}