
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_m_flutter/models/appointment-data.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/services/data-service.dart';

import 'appointment-model.dart';

class AppointmentManager {

  static FutureAppointment appointment;
  static bool hasAppointment = false;
  static Timer tx;
  static BuildContext context;
  
  // static Future<void> load() async {
  //   var appmt = await DataManager.getItem('appointment');
  //   if (appmt != null) {
  //     appointment = appmt;
  //     await _startAppointmentMonitor(appmt);
  //   }
  // }

  static Future<FutureAppointment> getValidAppointment(num branchId) async {
    appointment = null;
    var branchDetails = DataManager.branchDetails;
    if (branchDetails != null) {
      try {
        var lx = await getVesaliusFutureAppointments(branchId, branchDetails.prn);
        if (lx != null && lx.isNotEmpty) {
          appointment = lx.first;
          hasAppointment = true;
          Provider.of<AppointmentModel>(context, listen: false).setAppointment(appointment);
          await startAppointmentMonitor(appointment);
        }

        else {
          stopAppointmentMonitor();
        }
      }
      
      catch (error) {
        print('AppointmentManager.getValidAppointment');
        print(error);
      }
    }
    
    else {
      stopAppointmentMonitor();
    }

    return appointment;
  }

  static Future<void> startAppointmentMonitor(FutureAppointment appointment) async {
    if (tx != null) {
      tx.cancel();
    }

    await _startAppointmentMonitor(appointment);
  }

  static Future<void> _startAppointmentMonitor(FutureAppointment _appointment) async {
    appointment = _appointment;
    await getAndUpdateAppointment();
    tx = Timer.periodic(Duration(milliseconds: 2000000), (ti) async { // 2000000
      await getAndUpdateAppointment();
      print('AppointmentManager._startAppointmentMonitor');
      print(appointment);
    });
  }

  static Future<void> getAndUpdateAppointment() async {
    var branchDetails = DataManager.branchDetails;
    if (branchDetails != null) {
      try {
        var lx = await getVesaliusFutureAppointments(branchDetails.branch.branchId, branchDetails.prn);
        if (lx != null && lx.isNotEmpty) {
          appointment = lx.first;
          hasAppointment = true;
          Provider.of<AppointmentModel>(context, listen: false).setAppointment(appointment);
          await DataManager.setItem('appointment', appointment);
        }

        else {
          appointment = null;
          hasAppointment = false;
          Provider.of<AppointmentModel>(context, listen: false).setAppointment(null);
        }
      }

      catch (error) {
        print('AppointmentManager.getAndUpdateAppointment');
        print(error);
      }
    }
  }

  static void stopAppointmentMonitor() async {
    print('AppointmentManager.stopAppointmentMonitor');
    if (tx != null) {
      tx.cancel();
    }
    
    appointment = null;
    hasAppointment = false;
    await DataManager.removeItem('appointment');
    Provider.of<AppointmentModel>(context, listen: false).setAppointment(null);
  }

  static void start(BuildContext _context) {
    context = _context;
  }

  static void stop() {
    stopAppointmentMonitor();
  }
}