import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:vesalius_m_flutter/controllers/guest_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/home_ctrl.dart';
// import 'package:vesalius_m_flutter/ui/appointment/appointment_detail.dart';
import 'package:vesalius_m_flutter/ui/main_layout.dart';
import 'package:vesalius_m_flutter/ui/patient_survey.dart';
// import 'package:vesalius_m_flutter/ui/sign_in.dart';
import 'dart:developer' as developer;

import 'auth_manager.dart';

class NotificationManager {

  bool hasNotification = false;
  String? type;

  NotificationManager._privateConstructor();

  static final NotificationManager instance = NotificationManager._privateConstructor();

  void reset() {
    hasNotification = false;
    type = null;
  }

  void foregroundWillDisplayListener(OSNotificationWillDisplayEvent event) {
    final notification = event.notification;
    final x = notification.additionalData;
    if (x != null && x.containsKey('count')) {
      int n = x['count'] as int;
      if (AuthManager.instance.isLogin) {
        HomeCtrl ctrl = Get.put(HomeCtrl());
        ctrl.setUnseenCount(n);
      }
      
      else {
        GuestCtrl ctrl = Get.put(GuestCtrl());
        ctrl.setUnseenCount(n);
      }
    }
    String d = "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
    developer.log(d);
  }

  // void notificationWillShowInForegroundHandler(OSNotificationReceivedEvent event) {
  //   event.complete(event.notification);
  //   final notification = event.notification;
  //   final x = notification.additionalData;
  //   if (x != null && x.containsKey('count')) {
  //     int n = x['count'] as int;
  //     if (AuthManager.instance.isLogin) {
  //       HomeCtrl ctrl = Get.put(HomeCtrl());
  //       ctrl.setUnseenCount(n);
  //     }
      
  //     else {
  //       GuestCtrl ctrl = Get.put(GuestCtrl());
  //       ctrl.setUnseenCount(n);
  //     }
  //   }
  //   String d = "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
  //   developer.log(d);
  // }

  void clickListener(OSNotificationClickEvent ev) {
    final notification = ev.notification;
    String d = "Opened notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
    developer.log(d);
    if (AuthManager.instance.isLogin) {
      if (notification.additionalData!['type'] == 'survey') {
        Get.off(() => const MainLayout());
        Get.to(() => const PatientSurvey());
      }

      else {
        // Get.off(() => const MainLayout());
        //Get.to(() => const AppointmentDetail());
      }
    }

    else {
      NotificationManager.instance.hasNotification = true;
      if (notification.additionalData!['type'] == 'survey') {
        NotificationManager.instance.type = 'survey';
      }

      else {
        NotificationManager.instance.type = 'appt';
      }
      
      // Get.off(() => const SignIn());
    }
  }

  // void notificationOpenedHandler(OSNotificationOpenedResult result, BuildContext context) {
  //   final notification = result.notification;
  //   String d = "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
  //   developer.log(d);
  //   if (AuthManager.instance.isLogin) {
  //     if (notification.additionalData!['type'] == 'survey') {
  //       Get.off(() => const MainLayout());
  //       Get.to(() => const PatientSurvey());
  //     }

  //     else {
  //       Get.off(() => const MainLayout());
  //       //Get.to(() => const AppointmentDetail());
  //     }
  //   }
    
  //   else {
  //     NotificationManager.instance.hasNotification = true;
  //     if (notification.additionalData!['type'] == 'survey') {
  //       NotificationManager.instance.type = 'survey';
  //     }

  //     else {
  //       NotificationManager.instance.type = 'appt';
  //     }
      
  //     Get.off(() => const SignIn());
  //   }
  // }

  static Future<void> clearOneSignal() async {
    await OneSignal.User.removeTags(['user', 'guest-ticket']);
  }
}