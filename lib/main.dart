import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_m_flutter/models/appointment_model.dart';
import 'package:vesalius_m_flutter/models/cart_model.dart';
import 'package:vesalius_m_flutter/models/doctor_model.dart';

import 'ui/allergies.dart';
import 'ui/app_start.dart';
import 'ui/appointment.dart';
import 'ui/appointment/appointment_detail.dart';
import 'ui/appointment/appointment_free_slot.dart';
import 'ui/appointment/confirm_appointment.dart';
import 'ui/doctor.dart';
import 'ui/doctor/doctor_bookmark.dart';
import 'ui/first_time_login.dart';
import 'ui/forgot_password.dart';
import 'ui/guest.dart';
import 'ui/health_dashboard.dart';
import 'ui/home.dart';
import 'ui/hospital.dart';
import 'ui/hospital/external_hospital.dart';
import 'ui/hospital/hospital_bookmark.dart';
import 'ui/hospital/our_story.dart';
import 'ui/package.dart';
import 'ui/package/billing_detail.dart';
import 'ui/package/checkout_ok.dart';
import 'ui/patient_survey.dart';
import 'ui/profile.dart';
import 'ui/profile/change_password.dart';
import 'ui/sign_in.dart';
import 'ui/sign_up.dart';
import 'ui/splash.dart';
import 'ui/user_list.dart';
import 'ui/visit_history.dart';
import 'ui/visit-history/vital_signs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppointmentModel()),
        ChangeNotifierProvider(create: (context) => DoctorModel()),
        ChangeNotifierProvider(create: (context) => CartModel()),
      ],
      child: GetMaterialApp(
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
        getPages: [
          GetPage(name: Splash.routeName, page: () => const Splash(), transition: Transition.fadeIn),
          GetPage(name: AppStart.routeName, page: () => const AppStart(), transition: Transition.downToUp),
          GetPage(name: Home.routeName, page: () => const Home()),
          GetPage(name: Guest.routeName, page: () => const Guest()),
          GetPage(name: SignIn.routeName, page: () => const SignIn()),
          GetPage(name: SignUp.routeName, page: () => const SignUp()),
          GetPage(name: ForgotPassword.routeName, page: () => const ForgotPassword()),
          GetPage(name: Doctor.routeName, page: () => const Doctor()),
          GetPage(name: DoctorBookmark.routeName, page: () => const DoctorBookmark()),
          GetPage(name: Hospital.routeName, page: () => const Hospital()),
          GetPage(name: ExternalHospital.routeName, page: () => const ExternalHospital()),
          GetPage(name: OurStory.routeName, page: () => const OurStory()),
          GetPage(name: HospitalBookmark.routeName, page: () => const HospitalBookmark()),
          GetPage(name: UserList.routeName, page: () => const UserList()),
          GetPage(name: VisitHistory.routeName, page: () => const VisitHistory()),
          GetPage(name: VitalSigns.routeName, page: () => const VitalSigns()),
          GetPage(name: Profile.routeName, page: () => const Profile()),
          GetPage(name: Allergies.routeName, page: () => const Allergies()),
          GetPage(name: HealthDashboard.routeName, page: () => const HealthDashboard()),
          GetPage(name: Appointment.routeName, page: () => const Appointment()),
          GetPage(name: AppointmentFreeSlot.routeName, page: () => const AppointmentFreeSlot()),
          GetPage(name: ConfirmAppointment.routeName, page: () => const ConfirmAppointment()),
          GetPage(name: AppointmentDetail.routeName, page: () => const AppointmentDetail()),
          GetPage(name: ChangePassword.routeName, page: () => const ChangePassword()),
          GetPage(name: FirstTimeLogin.routeName, page: () => const FirstTimeLogin()),
          GetPage(name: PatientSurvey.routeName, page: () => const PatientSurvey()),
          GetPage(name: Package.routeName, page: () => const Package()),
          GetPage(name: BillingDetail.routeName, page: () => const BillingDetail()),
          GetPage(name: CheckoutOK.routeName, page: () => const CheckoutOK()),
        ],
        builder: (context, child) {
          final mediaQueryData = MediaQuery.of(context);
          final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.0);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
            child: child!,
          );
        },
      ),
    );
  }
}
