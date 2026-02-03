import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
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

  // static Future<FutureAppointment?> getValidAppointment(num branchId) async {
  //   appointment = null;
  //   UserBranch? branchDetails = DataManager.branchDetails;
  //   if (branchDetails != null) {
  //     try {
  //       final ctx = context.read<AppointmentModel>();
  //       List<FutureAppointment> lx = await VesaliusService.getVesaliusFutureAppointments(branchId, branchDetails.prn!);
  //       if (lx.isNotEmpty) {
  //         appointment = lx.first;
  //         hasAppointment = true;
  //         ctx.setAppointment(appointment);
  //         await startAppointmentMonitor(appointment!);
  //       }

  //       else {
  //         stopAppointmentMonitor();
  //       }
  //     }
      
  //     catch (error) {
  //       print('AppointmentManager.getValidAppointment');
  //       print(error);
  //     }
  //   }
    
  //   else {
  //     stopAppointmentMonitor();
  //   }

  //   return appointment;
  // }

  // static Future<void> startAppointmentMonitor(FutureAppointment appointment) async {
  //   if (tx != null) {
  //     tx!.cancel();
  //   }

  //   await _startAppointmentMonitor(appointment);
  // }

  // static Future<void> _startAppointmentMonitor(FutureAppointment mappointment) async {
  //   appointment = mappointment;
  //   await getAndUpdateAppointment();
  //   tx = Timer.periodic(const Duration(milliseconds: 2000000), (ti) async { // 2000000
  //     await getAndUpdateAppointment();
  //     print('AppointmentManager._startAppointmentMonitor');
  //     print(appointment);
  //   });
  // }

  // static Future<void> getAndUpdateAppointment() async {
  //   UserBranch? branchDetails = DataManager.branchDetails;
  //   if (branchDetails != null) {
  //     try {
  //       final ctx = context.read<AppointmentModel>();
  //       List<FutureAppointment> lx = await VesaliusService.getVesaliusFutureAppointments(branchDetails.branch!.branchId!, branchDetails.prn!);
  //       if (lx.isNotEmpty) {
  //         appointment = lx.first;
  //         hasAppointment = true;
  //         ctx.setAppointment(appointment);
  //         await DataManager.setItem('appointment', appointment);
  //       }

  //       else {
  //         appointment = null;
  //         hasAppointment = false;
  //         ctx.setAppointment(null);
  //       }
  //     }

  //     catch (error) {
  //       print('AppointmentManager.getAndUpdateAppointment');
  //       print(error);
  //     }
  //   }
  // }

  // static void stopAppointmentMonitor() async {
  //   print('AppointmentManager.stopAppointmentMonitor');
  //   if (tx != null) {
  //     tx!.cancel();
  //   }
    
  //   appointment = null;
  //   hasAppointment = false;
  //   final ctx = context.read<AppointmentModel>();
  //   await DataManager.removeItem('appointment');
  //   ctx.setAppointment(null);
  // }

  static void start(BuildContext mcontext) {
    context = mcontext;
  }

  // static void stop() {
  //   stopAppointmentMonitor();
  // }
}