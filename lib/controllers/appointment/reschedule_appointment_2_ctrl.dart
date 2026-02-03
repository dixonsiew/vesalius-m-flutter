import 'package:date_format/date_format.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';

class RescheduleAppointment2Ctrl extends GetxController {

  final _isLoading = false.obs;
  final _date = Rx<DateTime?>(null);
  final _xdate = Rx<DateTime?>(null);
  final _appointmentSession = Rx<AppointmentSession?>(null);
  final _xappointmentSession = Rx<AppointmentSession?>(null);
  final _appointmentSessionList = <AppointmentSession>[].obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setDate(DateTime? dx) {
    _date.value = dx;
  }

  void setXDate(DateTime? dx) {
    _xdate.value = dx;
    _xappointmentSession.value = null;
  }

  void setAppointmentSession(AppointmentSession? o) {
    _appointmentSession.value = o;
    _date.value = null;
  }

  void setXAppointmentSession(AppointmentSession? o) {
    _xappointmentSession.value = o;
    _xdate.value = null;
  }

  void setAppointmentSessionList(List<AppointmentSession> lx) {
    _appointmentSessionList.clear();
    _appointmentSessionList.addAllIf(lx.isNotEmpty, lx);
  }

  String get time {
    String s = 'Select A Time';
    if (xdate == null) {
      return s;
    }

    return formatDate(xdate!, [h, ':', nn, ' ', am]);
  }

  bool get isLoading => _isLoading.value;
  DateTime? get date => _date.value;
  DateTime? get xdate => _xdate.value;
  AppointmentSession? get appointmentSession => _appointmentSession.value;
  AppointmentSession? get xappointmentSession => _xappointmentSession.value;
  List<AppointmentSession> get appointmentSessionList => [..._appointmentSessionList];
}