import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_m_flutter/models/appointment_model.dart';
import 'package:vesalius_m_flutter/models/doctor_model.dart';

import 'ui/allergies.dart';
import 'ui/appointment.dart';
import 'ui/change_password.dart';
import 'ui/doctor.dart';
import 'ui/doctor/doctor_bookmark.dart';
import 'ui/first_time_login.dart';
import 'ui/forgot_password.dart';
import 'ui/health_dashboard.dart';
import 'ui/home.dart';
import 'ui/hospital.dart';
import 'ui/medical_history.dart';
import 'ui/medical-history/vital_signs.dart';
import 'ui/profile.dart';
import 'ui/sign_in.dart';
import 'ui/sign_up.dart';
import 'ui/splash.dart';
import 'ui/user_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppointmentModel()),
        ChangeNotifierProvider(create: (context) => DoctorModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VESALIUS.m',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
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
          Splash.routeName: (context) => const Splash(),
          Home.routeName: (context) => const Home(),
          SignIn.routeName: (context) => const SignIn(),
          SignUp.routeName: (context) => const SignUp(),
          ForgotPassword.routeName: (context) => const ForgotPassword(),
          Doctor.routeName: (context) => const Doctor(),
          DoctorBookmark.routeName: (context) => const DoctorBookmark(),
          Hospital.routeName: (context) => const Hospital(),
          UserList.routeName: (context) => const UserList(),
          MedicalHistory.routeName: (context) => const MedicalHistory(),
          VitalSigns.routeName: (context) => const VitalSigns(),
          Profile.routeName: (context) => const Profile(),
          Allergies.routeName: (context) => const Allergies(),
          HealthDashboard.routeName: (context) => const HealthDashboard(),
          Appointment.routeName: (context) => const Appointment(),
          ChangePassword.routeName: (context) => const ChangePassword(),
          FirstTimeLogin.routeName: (context) => const FirstTimeLogin(),
        },
        builder: (context, child) {
          final mediaQueryData = MediaQuery.of(context);
          final scale = mediaQueryData.textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.0);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: scale),
            child: child!,
          );
        },
      ),
    );
  }
}
