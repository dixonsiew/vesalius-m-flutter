import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/cart_data.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/goldenclub_data.dart';
import 'package:vesalius_m_flutter/models/kidsclub_data.dart';
import 'package:vesalius_m_flutter/models/notification_data.dart';
import 'package:vesalius_m_flutter/models/package_data.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/payment_data.dart';

import 'api_helper.dart';

class GuestModeService {

  static String name = 'guest';

  static Future<List<DoctorInfo>> getAllDoctors(num branchId, num page, num limit) async {
    List<DoctorInfo> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.dio.get('$kServerUrl/$name/vesalius/getAllDoctorInformation/$branchId', queryParameters: q);
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      int totalPage = int.parse(res.headers['x-total-page']!.first);
      if (page > totalPage) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => DoctorInfo.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<DoctorInfo>> searchDoctors(num branchId, num page, num limit, String keyword) async {
    List<DoctorInfo> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final o = {
        'keyword': keyword
      };
      final res = await ApiHelper.dio.post('$kServerUrl/$name/vesalius/getAllDoctorInformation/$branchId', data: o, queryParameters: q);
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      int totalPage = int.parse(res.headers['x-total-page']!.first);
      if (page > totalPage) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => DoctorInfo.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<NotificationX>> getNotifications(String playerId, num page, num limit) async {
    List<NotificationX> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.dio.get('$kServerUrl/$name/notification/all/$playerId', queryParameters: q);
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      int totalPage = int.parse(res.headers['x-total-page']!.first);
      if (page > totalPage) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => NotificationX.fromJson(x)).toList();
    }
    
    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<int> postNotificationSeen(int notificationId, String playerId) async {
    int n = 0;

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/$name/notification/seen/$notificationId/$playerId', data: {});
      Map<String, dynamic> m = res.data;
      if (m.containsKey('userUnseenCount')) {
        n = m['userUnseenCount'];
      }
    }

    catch (error) {
      rethrow;
    }

    return n;
  }

  static Future<int> getUnseenCount(String playerId) async {
    int n = 0;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/notification/unseen/count/$playerId');
      n = res.data as int;
    }

    catch (error) {
      rethrow;
    }

    return n;
  }

  static Future<KidsClub?> getLittleKidsAboutUs() async {
    KidsClub? o;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/clubs/littlekids/about-us');
      o = KidsClub.fromJson(res.data);
    }

    catch (error) {
      rethrow;
    }

    return o;
  }

  static Future<List<KidsActivity>> getAllLittleKidsActivities(num page, num limit, [int home = 0]) async {
    List<KidsActivity> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.dio.get('$kServerUrl/$name/clubs/littlekids/activity/all/mobile/$home', queryParameters: q);
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      int totalPage = int.parse(res.headers['x-total-page']!.first);
      if (page > totalPage) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => KidsActivity.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<KidsMembership>> getLittleKidsMembership(String idnum) async {
    List<KidsMembership> lx = [];

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/clubs/littlekids/membership/$idnum');
      if (res.statusCode == 204) {
        return lx;
      }

      final x = res.data;
      if (x['membershipDetails'] != null) {
        final o = KidsMembership.fromJson(x['membershipDetails']);
        lx = [o];
      }
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<void> postLittleKidsMembership(o) async {
    try {
      await ApiHelper.dio.post('$kServerUrl/$name/clubs/littlekids/membership', data: o);
    }

    catch (error) {
      rethrow;
    }
  }

  static Future<void> postLittleKidsActivityJoin(o) async {
    try {
      await ApiHelper.dio.post('$kServerUrl/$name/clubs/littlekids/activity/participate', data: o);
    }

    catch (error) {
      rethrow;
    }
  }

  static Future<GoldenPearlClub?> getGoldenPearlAboutUs() async {
    GoldenPearlClub? o;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/clubs/goldenpearl/about-us');
      o = GoldenPearlClub.fromJson(res.data);
    }

    catch (error) {
      rethrow;
    }

    return o;
  }

  static Future<List<GoldenPearlActivity>> getAllGoldenPearlActivities(num page, num limit, [int home = 0]) async {
    List<GoldenPearlActivity> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.dio.get('$kServerUrl/$name/clubs/goldenpearl/activity/all/mobile/$home', queryParameters: q);
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      int totalPage = int.parse(res.headers['x-total-page']!.first);
      if (page > totalPage) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => GoldenPearlActivity.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<GoldenPearlMembership>> getGoldenPearlMembership(String idnum) async {
    List<GoldenPearlMembership> lx = [];

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/clubs/goldenpearl/membership/$idnum');
      if (res.statusCode == 204) {
        return lx;
      }

      final x = res.data;
      if (x['membershipDetails'] != null) {
        final o = GoldenPearlMembership.fromJson(x['membershipDetails']);
        lx = [o];
      }
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<void> postGoldenPearlMembership(o) async {
    try {
      await ApiHelper.dio.post('$kServerUrl/$name/clubs/goldenpearl/membership', data: o);
    }

    catch (error) {
      rethrow;
    }
  }

  static Future<void> postGoldenPearlActivityJoin(o) async {
    try {
      await ApiHelper.dio.post('$kServerUrl/$name/clubs/goldenpearl/activity/participate', data: o);
    }

    catch (error) {
      rethrow;
    }
  }

  static Future<List<Package>> getAllPackages(num page, num limit, [int home = 0]) async {
    List<Package> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.dio.get('$kServerUrl/$name/package/all/mobile/$home', queryParameters: q);
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      int totalPage = int.parse(res.headers['x-total-page']!.first);
      if (page > totalPage) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => Package.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<PackageStatus?> getPackageStatus(int packageId) async {
    PackageStatus? o;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/package/packageStatus/$packageId');
      o = PackageStatus.fromJson(res.data);
    }

    catch (error) {
      rethrow;
    }

    return o;
  }

  static Future<CartStatus?> checkCartValidity(o) async {
    CartStatus? x;

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/$name/package/check/expiry-maxpurchase', data: o);
      x = CartStatus.fromJson(res.data);
    }

    catch (error) {
      rethrow;
    }

    return x;
  }

  static Future<String?> postPurchaseIpay(o) async {
    String? r;

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/$name/purchase/2', data: o);
      r = res.data;
    }

    catch (error) {
      rethrow;
    }

    return r;
  }

  static Future<WallexRes?> postPurchaseWallex(o) async {
    WallexRes? x;

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/$name/purchase/1', data: o);
      Map<String, dynamic> m = res.data;
      x = WallexRes.fromJson(m['wallexDetails']);
    }

    catch (error) {
      rethrow;
    }

    return x;
  }

  static Future<RetPatient?> getRetPatient(o) async {
    RetPatient? x;

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/$name/appointment/returning-patient', data: o);
      Map<String, dynamic> m = res.data;
      x = RetPatient.fromJson(m);
    }

    catch (error) {
      rethrow;
    }

    return x;
  }

  static Future<Map<String, dynamic>> getDoctorAppointments(num doctorId, int month, int year, [int appt = 0]) async {
    Map<String, dynamic> m = {};

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/appointment/get-doctor-appointments/$doctorId/$month/$year/$appt');
      final ls = res.data['calendarDailyStatus'] as List? ?? [];
      final lk = res.data['doctorAppointment'] as List? ?? [];
      List<DoctorAppointmentStatus> lx = ls.map((x) => DoctorAppointmentStatus.fromJson(x)).toList();
      List<DoctorAppointment> ly = lk.map((x) => DoctorAppointment.fromJson(x)).toList();
      m['calendarDailyStatus'] = lx;
      m['doctorAppointment'] = ly;
    }

    catch (error) {
      rethrow;
    }

    return m;
  }

  static Future<bool> postCheckAppointment(String prn, Map data) async {
    bool b = false;

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/$name/appointment/check-make-appointment/1/$prn', data: data);
      b = res.data as bool;
    }

    catch (error) {
      rethrow;
    }

    return b;
  }

  static Future<void> postVesaliusMakeAppointment(String prn, Map data) async {
    try {
      await ApiHelper.dio.post('$kServerUrl/$name/appointment/make-appointment/1/$prn', data: data);
    }

    catch (error) {
      rethrow;
    }
  }

  static Future<RetPatient?> postNewPatient(o) async {
    RetPatient? x;

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/$name/appointment/new-patient', data: o);
      Map<String, dynamic> m = res.data;
      x = RetPatient.fromJson(m);
    }

    catch (error) {
      rethrow;
    }

    return x;
  }
}