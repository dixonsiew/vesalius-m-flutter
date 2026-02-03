import 'package:flutter/material.dart';

const kServer = 'https://202.73.42.183:43901/mobile_central_2_0_0';
// const SERVER1 = 'http://175.145.93.195:27051/mobile_central_cvskl-2.0.2';
// const SERVER = 'http://192.168.5.173:8000/mobile_central_2_0_0';
// const SERVER = 'http://175.145.93.195:27051/mobile_central_cvskl-2.0.1';

const kPageSize = 10;

const kOneSignalAppID2 = 'f1ac701a-4309-4e3c-9675-58fce2429aad'; // testing
const kOneSignalAppID0 = '7196c415-62a5-4d5b-a38c-376216439f5d'; // dev
const kOneSignalAppID1 = 'defb9cbc-dc19-4619-97ce-da34b1627f4b'; // cvs
const kOneSignalAppID = '18d1520f-a152-46fc-ba95-e010e2ff88e2'; // ihp

enum AlertType {
  info,
  success,
  error,
}

// const kAppVersion = '1.0.13';

const kAppToolbarHeight = 45.0;

const kAlertTextColor = Color(0xFF203B8C);
const kAlertBgColor = Color(0xFFE0FCFB);
const kAlertIconInfoColor = Color(0xFF063D8B);
const kAlertIconSuccessColor = Color(0xFF04C789);
const kAlertIconErrorColor = Color(0xFFE00202);
const kAlertBtnInfoColor = Color(0xFF0070C0);
const kAlertBtnSuccessColor = Color(0xFF00B04F);
const kAlertBtnErrorColor = Color(0xFFFF0000);

const kPrimaryColor = Color(0xFF00575E);
const kSecondaryColor = Color(0xFF32DB64);
const kDescriptionColor = Color(0xFFA1A1A1);
const kPrimaryBtnBgColor = Color(0xFF32A7CC);
const kPrimaryBgColor = Color(0xFFCE2525);
const kSecondaryBgColor = Color(0xFFEDB0B0);
const kAppointmentBgColor = Color(0xFFAF7AFF);
const kHealthDashboardBgColor = Color(0xFF3DB1C8);
const kSearchHospitalBgColor = Color(0xFFFFB451);
const kSearchDoctorBgColor = Color(0xFF35DFEC);
const kTicketBgColor = Color(0xFFFF7070);
const kProfileBgColor = Color(0xFFFF7B51);
const kAllergiesBgColor = Color(0xFF5E9FFF);
const kMedicalRecordBgColor = Color(0xFF50CC71);
const kChangePasswordBgColor = Color(0xFFD93B76);
const kMainColor = Color(0xFFA41D2B); // Color(0xFFA41D2B);
const kBgColor1 = Color(0xFFF8F8F8);
const kBgColor2 = Color(0xFFE5E5E5);

const kTextColor1 = Color(0xFF002E50);
const kTextColor2 = Color(0xFF757F8C);
const kTextColor3 = Color(0xFFFF5050);
const kTextColor4 = Color(0xFF4E4E4E);

const kProgressTextStyle = TextStyle(
  color: kPrimaryColor,
);

const kTitleFont = 'Lato';
const kBodyFont = 'Lato';
const kMainFont = 'Montserrat';

const kTextStyle1 = TextStyle(
  letterSpacing: 0.05,
);

const kBodyTextStyle = TextStyle(
  fontFamily: kBodyFont,
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
  color: kTextColor1,
  letterSpacing: 0.05,
);

const kTitleTextStyle = TextStyle(
  fontFamily: kTitleFont,
  fontSize: 18.0,
  fontWeight: FontWeight.w700,
  color: Color(0xFF002E50),
  letterSpacing: 0.05,
);

const kLabelTextStyle = TextStyle(
  fontFamily: kBodyFont,
  fontSize: 14.0,
  fontWeight: FontWeight.w600,
  color: Color(0xFF002E50),
  letterSpacing: 0.05,
);

const kMainTextStyle = TextStyle(
  fontFamily: kMainFont,
  fontSize: 14.0,
  fontWeight: FontWeight.w600,
  color: Color(0xFF4E4E4E),
  letterSpacing: 0.05,
);
