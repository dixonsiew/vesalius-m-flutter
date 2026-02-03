
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

import 'appointment_model.dart';

class AppointmentManager {

  static FutureAppointment? appointment;
  static bool hasAppointment = false;
  static Timer? tx;
  static late BuildContext context;
  
  // static Future<void> load() async {
  //   var appmt = await DataManager.getItem('appointment');
  //   if (appmt != null) {
  //     appointment = appmt;
  //     await _startAppointmentMonitor(appmt);
  //   }
  // }

  static Future<FutureAppointment?> getValidAppointment(num branchId) async {
    appointment = null;
    var branchDetails = DataManager.branchDetails;
    if (branchDetails != null) {
      try {
        AppointmentModel m = Provider.of<AppointmentModel>(context, listen: false);
        var lx = await getVesaliusFutureAppointments(branchId, branchDetails.prn!);
        if (lx.isNotEmpty) {
          appointment = lx.first;
          hasAppointment = true;
          m.setAppointment(appointment);
          await startAppointmentMonitor(appointment!);
        }

        else {
          stopAppointmentMonitor();
        }
      }
      
      catch (_) {}
    }
    
    else {
      stopAppointmentMonitor();
    }

    return appointment;
  }

  static Future<void> startAppointmentMonitor(FutureAppointment appointment) async {
    if (tx != null) {
      tx!.cancel();
    }

    await _startAppointmentMonitor(appointment);
  }

  static Future<void> _startAppointmentMonitor(FutureAppointment mappointment) async {
    appointment = mappointment;
    await getAndUpdateAppointment();
    tx = Timer.periodic(const Duration(milliseconds: 2000000), (ti) async { // 2000000
      await getAndUpdateAppointment();
    });
  }

  static Future<void> getAndUpdateAppointment() async {
    var branchDetails = DataManager.branchDetails;
    if (branchDetails != null) {
      try {
        AppointmentModel m = Provider.of<AppointmentModel>(context, listen: false);
        var lx = await getVesaliusFutureAppointments(branchDetails.branch!.branchId!, branchDetails.prn!);
        if (lx.isNotEmpty) {
          appointment = lx.first;
          hasAppointment = true;
          m.setAppointment(appointment);
          await DataManager.setItem('appointment', appointment);
        }

        else {
          appointment = null;
          hasAppointment = false;
          m.setAppointment(null);
        }
      }

      catch (_) {}
    }
  }

  static void stopAppointmentMonitor() async {
    if (tx != null) {
      tx!.cancel();
    }
    
    appointment = null;
    hasAppointment = false;
    AppointmentModel m = Provider.of<AppointmentModel>(context, listen: false);
    await DataManager.removeItem('appointment');
    m.setAppointment(null);
  }

  static void start(BuildContext mcontext) {
    context = mcontext;
  }

  static void stop() {
    stopAppointmentMonitor();
  }
}