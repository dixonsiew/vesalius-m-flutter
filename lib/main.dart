import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_m_flutter/models/appointment-model.dart';
import 'package:vesalius_m_flutter/ui/allergies.dart';
import 'package:vesalius_m_flutter/ui/appointment.dart';
import 'package:vesalius_m_flutter/ui/appointment/add-appointment.dart';
import 'package:vesalius_m_flutter/ui/appointment/appointment-free-slot.dart';
import 'package:vesalius_m_flutter/ui/appointment/confirm-appointment.dart';
import 'package:vesalius_m_flutter/ui/change-password.dart';
import 'package:vesalius_m_flutter/ui/doctor.dart';
import 'package:vesalius_m_flutter/ui/doctor/doctor-bookmark.dart';
import 'package:vesalius_m_flutter/ui/first-time-login.dart';
import 'package:vesalius_m_flutter/ui/forgot-password.dart';
import 'package:vesalius_m_flutter/ui/health-dashboard.dart';
import 'package:vesalius_m_flutter/ui/home.dart';
import 'package:vesalius_m_flutter/ui/hospital.dart';
import 'package:vesalius_m_flutter/ui/medical-history.dart';
import 'package:vesalius_m_flutter/ui/medical-history/vital-signs.dart';
import 'package:vesalius_m_flutter/ui/profile.dart';
import 'package:vesalius_m_flutter/ui/sign-in.dart';
import 'package:vesalius_m_flutter/ui/sign-up.dart';
import 'package:vesalius_m_flutter/ui/splash.dart';
import 'package:vesalius_m_flutter/ui/user-list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppointmentModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VESALIUS.m',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', 'US'),
          Locale('en', 'AU'),
        ],
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: Theme.of(context).appBarTheme.copyWith(shadowColor: Colors.black),
        ),
        initialRoute: Splash.routeName,
        routes: {
          Splash.routeName: (context) => Splash(),
          Home.routeName: (context) => Home(),
          SignIn.routeName: (context) => SignIn(),
          SignUp.routeName: (context) => SignUp(),
          ForgotPassword.routeName: (context) => ForgotPassword(),
          Doctor.routeName: (context) => Doctor(),
          DoctorBookmark.routeName: (context) => DoctorBookmark(),
          Hospital.routeName: (context) => Hospital(),
          UserList.routeName: (context) => UserList(),
          MedicalHistory.routeName: (context) => MedicalHistory(),
          VitalSigns.routeName: (context) => VitalSigns(),
          Profile.routeName: (context) => Profile(),
          Allergies.routeName: (context) => Allergies(),
          HealthDashboard.routeName: (context) => HealthDashboard(),
          Appointment.routeName: (context) => Appointment(),
          AddAppointment.routeName: (context) => AddAppointment(),
          AppointmentFreeSlot.routeName: (context) => AppointmentFreeSlot(),
          ConfirmAppointment.routeName: (context) => ConfirmAppointment(),
          ChangePassword.routeName: (context) => ChangePassword(),
          FirstTimeLogin.routeName: (context) => FirstTimeLogin(),
        },
      ),
    );
  }
}
