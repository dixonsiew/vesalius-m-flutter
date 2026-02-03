import 'package:date_format/date_format.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';

class TransportArrangementCtrl extends GetxController {

  final _isLoading = false.obs;
  final _xdate = Rx<DateTime?>(null);
  final _xappointmentSession = Rx<AppointmentSession?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }


  void setXDate(DateTime? dx) {
    _xdate.value = dx;
    _xappointmentSession.value = null;
  }

  String get time {
    String s = 'Select Time';
    if (xdate == null) {
      return s;
    }

    return formatDate(xdate!, [h, ':', nn, ' ', am]);
  }

  bool get isLoading => _isLoading.value;
  DateTime? get xdate => _xdate.value;
  AppointmentSession? get xappointmentSession => _xappointmentSession.value;
}