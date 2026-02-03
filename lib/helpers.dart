import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:vesalius_m_flutter/components/no_network.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'components/app_shared.dart';
import 'constants.dart';
import 'models/auth_manager.dart';
import 'ui/sign_in.dart';

extension StringExtension on String? {
  String? titleCase() {
    if (this == null) {
      return null;
    }

    List<String>? a = this?.split(' ');
    List<String> ls = [];
    for (int i = 0; i < a!.length; i++) {
      ls.add(a[i].capitalize!);
    }

    return ls.join(' ');
  }

  String? replaceWhitespacesUsingRegex(String replace) {
    if (this == null) {
      return null;
    }

    // This pattern means "at least one space, or more"
    // \\s : space
    // +   : one or more
    final pattern = RegExp('\\s+');
    return this!.replaceAll(pattern, replace);
  }

  String trimFirstZero() {
    String r = this!;
    final ls = r.split('');
    int j = 0;
    for (int i = 0; i < ls.length; i++) {
      if (ls[i] != '0') {
        j = i;
        break;
      }
    }

    r = this!.substring(j);
    return r;
  }
}

extension PasswordValidators on String {
  bool containsLowercase() {
    RegExp regExp = RegExp(r'[a-z]');
    return contains(regExp);
  }

  bool containsUppercase() {
    RegExp regExp = RegExp(r'[A-Z]');
    return contains(regExp);
  }

  bool hasDigit() {
    RegExp regExp = RegExp(r'[0-9]');
    return contains(regExp);
  }

  bool hasSpecialCharacter() {
    RegExp regExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    return contains(regExp);
  }

  bool hasValidLength() {
    return length >= 8 && length <= 20;
  }
}

void handleError(DioException error, void Function()? onYes) async {
  String msg = error.message ?? kError;
  if (error.type == DioExceptionType.connectionTimeout) {
    msg = 'Connection Timeout';
  } else if (error.type == DioExceptionType.receiveTimeout) {
    msg = 'Receive Timeout';
  } else if (error.type == DioExceptionType.badResponse) {
    msg = 'Error occurred - ${error.response?.statusCode}';
    if (error.response?.statusCode == 401) {
      try {
        // await AuthService.logout();
        await AuthManager.instance.signOut();
        Get.offAll(() => const SignIn());
      }

      catch (_) {
        showCustomDialog('Error', 'Unable to logout at the moment. Please check your internet connection or try again later.', 'Dismiss');
      }
      
      return;
    }

    else if (error.response?.statusCode == 503 || error.response?.statusCode == 502 || error.response?.statusCode == 500) {
      final mx = error.response?.data as Map?;
      if (mx?.containsKey('message') ?? false) {
        showCustomDialog('Error', mx?['message'], 'Dismiss');
      }

      else {
        showCustomDialog('Error', msg, 'Dismiss');
      }

      return;
    }
  }
  
  else if (error.type == DioExceptionType.connectionError) {
    Get.to(() => NoNetwork(
      onPressed: () {
        if (onYes != null) {
          onYes.call();
        }
      },
    ));
    return;
  }

  if (msg == kError) {
    showCustomDialog('Error', kError, 'Dismiss');
    return;
  }

  if (onYes != null) {
    bool b = await showConfirmDialog('$msg. Do you want to retry ?');
    if (b) {
      onYes.call();
    }
  }
}

void handleLoadError(DioException error, void Function()? onYes) async {
  if (error.type == DioExceptionType.badResponse) {
    final mx = error.response?.data as Map?;
    if (mx?.containsKey('message') ?? false) {
      await showCustomDialog(error.response?.statusCode == 401 ? 'Unauthorized' : 'Error', mx?['message'], 'Dismiss');
    }

    if (error.response?.statusCode == 401) {
      handleError(error, onYes);
    }
  }

  else {
    handleError(error, onYes);
  }
}

void handleSubmitError(DioException error, String msg, void Function()? onYes) async {
  bool shown = false;
  if (error.type == DioExceptionType.badResponse) {
    final mx = error.response?.data as Map?;
    if (mx?.containsKey('message') ?? false) {
      shown = true;
      await showCustomDialog(error.response?.statusCode == 401 ? 'Unauthorized' : 'Error', mx?['message'], 'Dismiss');
    }

    if (error.response?.statusCode == 401) {
      handleError(error, onYes);
    }

    else {
      if (!shown) {
        showCustomDialog('Error', msg, 'Dismiss');
      }
    }
  }

  else {
    handleError(error, onYes);
  }
}

String formatDateTime(String ds) {
  String s = ds;
  DateTime? dt = DateTime.tryParse(ds);
  if (dt != null) {
    s = formatDate(dt, [dd, ' ', M, ' ', yyyy]);
  }

  return s;
}

String formatPrice(double x) {
  final f = NumberFormat("#,##0.00", "en_US");
  return f.format(x);
}

Future<void> showCustomDialog(String title, String subTitle, String btnText) async {
  await Get.dialog(AlertDialog(
    scrollable: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    backgroundColor: Colors.white,
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: kTextStyle1.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            subTitle,
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: kTextColor2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          AppElevatedButton(
            text: btnText,
            onPressed: () => Get.back(),
          ),
        ],
      ),
    ),
  ));
}

Future<bool> showConfirmDialog(String text) async {
  return await Get.dialog(AlertDialog(
    scrollable: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    backgroundColor: Colors.white,
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
              color: kTextColor2,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.back(result: false);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kTextColor2,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    side: const BorderSide(
                      color: Color(0xFFDBDBDB),
                    ),
                  ),
                  child: Text(
                    'No',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18.0),
              Expanded(
                child: AppElevatedButton(
                  text: 'Yes',
                  onPressed: () => Get.back(result: true),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  )) ?? false;
}

Future<bool> showConfirmSubmitAppointment() async {
  return await Get.dialog(AlertDialog(
    scrollable: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    backgroundColor: Colors.white,
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Caution: You have already booked an appointment on the same date/session.\nPlease confirm if you would like to proceed',
            style: kTextStyle1.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: kPrimaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.back(result: false);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kTextColor2,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    side: const BorderSide(
                      color: Color(0xFFDBDBDB),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18.0),
              Expanded(
                child: AppElevatedButton(
                  text: 'Confirm',
                  onPressed: () => Get.back(result: true),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  )) ?? false;
}

void makePhoneCall(DoctorContact o) async {
  String s = 'tel';
  String? v = o.contactValue?.replaceWhitespacesUsingRegex('');

  // String url = '$s:$v';
  // Uri uri = Uri.parse(url);
  Uri url = Uri(scheme: s, path: v);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }

  else {
    showCustomDialog('Error', 'Unable to make phone call to: ${o.contactValue}', 'Dismiss');
  }
}

void makePhoneCallNum(String num) async {
  String s = 'tel';
  String? v = num.replaceWhitespacesUsingRegex('');
  Uri url = Uri(scheme: s, path: v);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }

  else {
    showCustomDialog('Error', 'Unable to make phone call to: $num', 'Dismiss');
  }
}

void sendMail(String e) async {
  String s = 'mailto';
  Uri url = Uri(scheme: s, path: e);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }

  else {
    showCustomDialog('Error', 'Unable to launch email: $e', 'Dismiss');
  }
}

void launchAction(DoctorContact o) async {
  String s = o.contactType == 'Contact No' ? 'tel' : 'mailto';
  String? v = o.contactValue;
  if (o.contactType == 'Contact No') {
    v = o.contactValue?.replaceWhitespacesUsingRegex('');
  }

  // String url = '$s:$v';
  // Uri uri = Uri.parse(url);
  Uri url = Uri(scheme: s, path: v);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }

  else {
    showCustomDialog('Error', 'Unable to launch contact: ${o.contactValue}', 'Dismiss');
  }
}

void launchWA(DoctorContact o) async {
  String whatsapp = o.contactValue?.replaceAll('+', '').replaceAll(' ', '') ?? '';
  launchWANum(whatsapp);
}

void launchWANum(String num) async {
  String waUrl = 'whatsapp://send?phone=$num';
  if (Platform.isIOS) {
    waUrl = 'https://wa.me/$num';
  }

  Uri url = Uri.parse(waUrl);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }

  else {
    showCustomDialog('Error', 'WhatsApp not installed', 'Dismiss');
  }
}

void launchMap(double latitude, double longitude) async {
  if (await MapLauncher.isMapAvailable(MapType.google)) {
    await MapLauncher.showMarker(
      mapType: MapType.google,
      coords: Coords(latitude, longitude),
      title: 'Metro Hospital',
    );
  }

  else if (await MapLauncher.isMapAvailable(MapType.waze)) {
    await MapLauncher.showMarker(
      mapType: MapType.waze,
      coords: Coords(latitude, longitude),
      title: 'Metro Hospital',
    );
  }

  else if (await MapLauncher.isMapAvailable(MapType.apple)) {
    await MapLauncher.showMarker(
      mapType: MapType.apple,
      coords: Coords(latitude, longitude),
      title: 'Metro Hospital',
    );
  }

  else {
    Uri uri = Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': 'Metro Hospital'});
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    else {
      showCustomDialog('Error', 'Could not open the map', 'Dismiss');
    }
  }
  
  // https://stackoverflow.com/questions/52577780/flutter-open-location-in-maps
  /* String query = '$latitude,$longitude';
  Uri uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});

  if (Platform.isAndroid) {
    uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});
  }

  else if (Platform.isIOS) {
    var params = {'ll': '$latitude,$longitude'};
    uri = Uri.https('maps.apple.com', '/', params);
  }

  else {
    uri = Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': query});
  }

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  else {
    showCustomDialog('Error', 'Could not open the map', 'Dismiss');
  } */
}

void launchURL(String s) async {
  Uri url = Uri.parse(s);
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  else {
    showCustomDialog('Error', 'Could not open the url $s', 'Dismiss');
  }
}