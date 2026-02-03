import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final kServerUrl = dotenv.env['SERVERURL'] ?? '';
final kServerNavUrl = dotenv.env['SERVERNAVURL'] ?? '';
// const SERVER1 = 'http://175.145.93.195:27051/mobile_central_cvskl-2.0.2';
// const SERVER = 'http://192.168.5.173:8000/mobile_central_2_0_0';
// const SERVER = 'http://175.145.93.195:27051/mobile_central_cvskl-2.0.1';
final kXApiKey = dotenv.env['XAPIKEY'] ?? '';
final kAccessKey = dotenv.env['ACCESSKEY'] ?? '';
final kSecretKey = dotenv.env['SECRETKEY'] ?? '';

const kPageSize = 10;

final kOneSignalAppID = dotenv.env['ONESIGNALAPPID'] ?? ''; // testing
const kOneSignalAppID0 = '7196c415-62a5-4d5b-a38c-376216439f5d'; // dev
const kOneSignalAppID1 = 'defb9cbc-dc19-4619-97ce-da34b1627f4b'; // cvs
const kOneSignalAppID2 = '18d1520f-a152-46fc-ba95-e010e2ff88e2'; // ihp

final kAppUrl = dotenv.env['APPND'] ?? '';
final kIOSAppUrl = dotenv.env['APPIOS'] ?? '';

const kAppToolbarHeight = 45.0;
const kMaxFileSize = 5242880; //41943040;
const kMaxFileSizeStr = '5 MB';

const kPrimaryColor = kColor14;
final kSecondaryColor = kColor13.withValues(alpha: 0.5);
final kSecondaryColor2 = kColor27.withValues(alpha: 0.2);
const kPrimaryBgColor = Color(0xFFCE2525);
const kSecondaryBgColor = Color(0xFFEDB0B0);

const kBgColor1 = kColor15;
const kBgColor2 = kColor4;

const kTextColor1 = Color(0xFF303030);
const kTextColor2 = Color(0xFF757F8C);
const kTextColor3 = Color(0xFFFF4848);
const kTextColor4 = Color(0xFF4E4E4E);
const kTextColor5 = Color(0xFF808080);
const kTextColor6 = Color(0xFF999999);

const kColor1 = Color(0xFFDBDBDB);
const kColor2 = Color(0xFFB1B1B1);
const kColor3 = Color(0xFFDADADA);
const kColor4 = Color(0xFFE5E5E5);
const kColor5 = Color(0xFFE0E0E0);
const kColor6 = Color(0xFFEAEAEA);
const kColor7 = Color(0xFF5394A6);
const kColor8 = Color(0xFFADADAD);
const kColor9 = Color(0xFF44A1E4);
const kColor10 = Color(0xFFC7CCD6);
const kColor11 = Color(0xFFC2E7EA);
const kColor12 = Color(0xFFf4f4f4);
const kColor13 = Color(0xFFD4E8E8);
const kColor14 = Color(0xFF00585F);
const kColor15 = Color(0xFFF8F8F8);
const kColor16 = Color(0xFF007AFF);
const kColor17 = Color(0xFFF1FFF9);
const kColor18 = Color(0xFF08AB92);
const kColor19 = Color(0xFFFF5050);
const kColor20 = Color(0xFF002E50);
const kColor21 = Color(0xFF4D4D4D);
const kColor22 = Color(0xFF0000FF);
const kColor23 = Color(0xFFE4FFED);
const kColor24 = Color(0xFFEBEBEB);
const kColor25 = Color(0xFF232326);
const kColor26 = Color(0xFFFFFFFF);
const kColor27 = Color(0xFFD6BE7F);
const kColor28 = Color(0xFFF2F2F2);
const kColor29 = Color(0xFF9A99A2);

const kCircleBgColor = Color(0xFFEEF5FF);
const kHealthDashboardBgColor = Color(0xFF127099);

const kPeelWingColor = Color(0xFFF9AD2B);
const kOthersColor = Color(0xFF44B9D4);

const kProgressTextStyle = TextStyle(
  color: kPrimaryColor,
);

const kTitleFont = 'MyriadPro';
const kBodyFont = 'MyriadPro';
const kFont2 = 'Montserrat';

const kTextStyle1 = TextStyle(
  letterSpacing: 0.05,
);

const kTextStyle2 = TextStyle(
  letterSpacing: 0.2,
);

final kEnabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(5.0),
  borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
);

final kFocusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(5.0),
  borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
);

final kErrorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(5.0),
  borderSide: const BorderSide(color: kTextColor3),
);

final kFocusedErrorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(5.0),
  borderSide: const BorderSide(color: kTextColor3),
);

const kMaxAppointmentDay = 90;
const kBlur = 2.0;
final kPurchase = dotenv.env['APPPURCHASE'] == '1' ? true : false;
final kTransportArrangement = dotenv.env['APPENTRANSPORTARRANGEMENT'] == '1' ? true : false;
final kDelAcc = dotenv.env['APPDELACC'] == '1' ? true : false;
const kHiveBoxName = 'ihpuatBox';
const kHiveBoxUserName = 'ihpuatUserBox';

final kRegExpPassword = RegExp(r'^(?=.*\d)(?=.*[a-zA-Z]).*$');
final kRegExpEmail = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
const kError = 'An unexpected error occurred while processing your request. Please verify your internet connection or contact support for assistance.';
const kAPIError = 'Seems like there is an issue to handle your request. Please contact customer service for assistance. (BAD GATEWAY)';