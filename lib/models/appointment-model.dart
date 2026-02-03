import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/models/appointment-data.dart';

class AppointmentModel extends ChangeNotifier {

  FutureAppointment _appointment;
  bool _hasAppointment = false;

  void setAppointment(FutureAppointment appmt) {
    _appointment = appmt;
    _hasAppointment = appmt == null ? false : true;
    notifyListeners();
  }

  FutureAppointment get appointment => _appointment;

  bool get hasAppointment => _hasAppointment;
}