import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final kServerUrl = dotenv.env['SERVERURL'] ?? '';
// const SERVER1 = 'http://175.145.93.195:27051/mobile_central_cvskl-2.0.2';
// const SERVER = 'http://192.168.5.173:8000/mobile_central_2_0_0';
// const SERVER = 'http://175.145.93.195:27051/mobile_central_cvskl-2.0.1';

const kPageSize = 10;

final kOneSignalAppID = dotenv.env['ONESIGNALAPPID'] ?? ''; // testing
const kOneSignalAppID0 = '7196c415-62a5-4d5b-a38c-376216439f5d'; // dev
const kOneSignalAppID1 = 'defb9cbc-dc19-4619-97ce-da34b1627f4b'; // cvs
const kOneSignalAppID2 = '18d1520f-a152-46fc-ba95-e010e2ff88e2'; // ihp

enum AlertType {
  info,
  success,
  error,
}

// const kAppVersion = '1.0.13';

const kAppToolbarHeight = 45.0;

const kPrimaryColor = Color(0xFFA41D2B);
const kSecondaryColor = Color(0xFFFFE4E4);
const kSecondaryColor2 = Color(0xFFE1EDFF);
const kPrimaryBgColor = Color(0xFFCE2525);
const kSecondaryBgColor = Color(0xFFEDB0B0);

const kBgColor1 = Color(0xFFF8F8F8);
const kBgColor2 = Color(0xFFE5E5E5);

const kTextColor1 = Color(0xFF002E50);
const kTextColor2 = Color(0xFF757F8C);
const kTextColor3 = Color(0xFFFF5050);
const kTextColor4 = Color(0xFF4E4E4E);
const kTextColor5 = Color(0xFFBDC2CC);

const kCircleBgColor = Color(0xFFEEF5FF);
const kHealthDashboardBgColor = Color(0xFF127099);

const kProgressTextStyle = TextStyle(
  color: kPrimaryColor,
);

const kTitleFont = 'Lato';
const kBodyFont = 'Lato';
const kFont2 = 'Mulish';

const kTextStyle1 = TextStyle(
  letterSpacing: 0.05,
);