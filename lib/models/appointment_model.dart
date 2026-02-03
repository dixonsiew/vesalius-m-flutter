import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';

class AppointmentModel extends ChangeNotifier {

  FutureAppointment? _appointment;
  bool _hasAppointment = false;
  int _appointmentCount = 0;

  void setAppointment(FutureAppointment? appmt) {
    _appointment = appmt;
    _hasAppointment = appmt == null ? false : true;
    notifyListeners();
  }

  void setAppointmentCount(int n) {
    _appointmentCount = n;
    notifyListeners();
  }

  FutureAppointment? get appointment => _appointment;

  bool get hasAppointment => _hasAppointment;

  int get appointmentCount => _appointmentCount;
}