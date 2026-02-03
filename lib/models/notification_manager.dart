import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:vesalius_m_flutter/ui/appointment/appointment_detail.dart';
import 'package:vesalius_m_flutter/ui/home.dart';
import 'package:vesalius_m_flutter/ui/patient_survey.dart';
import 'package:vesalius_m_flutter/ui/sign_in.dart';

import 'auth_manager.dart';

class NotificationManager {

  static bool hasNotification = false;
  static String? type;

  static void reset() {
    hasNotification = false;
    type = null;
  }

  static void notificationWillShowInForegroundHandler(OSNotificationReceivedEvent event) {
    event.complete(event.notification);
    final notification = event.notification;
    final x = notification.additionalData;
    print(x);
    String d = "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
    print(d);
  }

  static void notificationOpenedHandler(OSNotificationOpenedResult result, BuildContext context) {
    final notification = result.notification;
    String d = "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
    print(d);
    if (AuthManager.isLogin) {
      if (notification.additionalData!['type'] == 'survey') {
        Get.offNamed(Home.routeName);
        Get.toNamed(PatientSurvey.routeName);
      }

      else {
        Get.offNamed(Home.routeName);
        Get.toNamed(AppointmentDetail.routeName);
      }
    }
    
    else {
      NotificationManager.hasNotification = true;
      if (notification.additionalData!['type'] == 'survey') {
        NotificationManager.type = 'survey';
      }

      else {
        NotificationManager.type = 'appt';
      }
      
      Get.offNamed(SignIn.routeName);
    }
  }

  static Future<void> clearOneSignal() async {
    await OneSignal.shared.deleteTag('user');
    await OneSignal.shared.deleteTag('guest-ticket');
  }
}