import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';

import 'api_helper.dart';

class PublicVesaliusService {

  static String name = 'public';

  static Future<List<SessionAvailableSlot>> getVesaliusNextSessionAvailableSlot(num branchId, String prn, Map data) async {
    List<SessionAvailableSlot> lx;

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/$name/vesalius/get-next-session-available-slots/$branchId/$prn', data: data);
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => SessionAvailableSlot.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<AvailableSlot>> getVesaliusNextAvailableSlot(num branchId, String prn, Map data) async {
    List<AvailableSlot> lx;

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/$name/vesalius/get-next-available-slots/$branchId/$prn', data: data);
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => AvailableSlot.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<DoctorDetails>> getPublicDoctorData(num branchId) async {
    List<DoctorDetails> lx;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/$name/vesalius/doctor-data/$branchId');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }
      
      final ls = res.data as List? ?? [];
      lx = ls.map((x) => DoctorDetails.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List> getPublicHospitalInformation() async {
    List lx = [];

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/$name/hospital-information');
      lx = res.data;
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<UserBranch>> getPublicBranchList() async {
    List<UserBranch> lx;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/branch/list');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => UserBranch.fromJson1(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

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

  static Future<DoctorInfo?> getDoctorByMCR(num branchId, String mcr) async {
    DoctorInfo? o;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/vesalius/getDoctorInformationByMCR/$branchId/$mcr');
      if (res.statusCode == 204) {
        return o;
      }

      final ls = res.data as List? ?? [];
      final lx = ls.map((x) => DoctorInfo.fromJson(x)).toList();
      if (lx.isNotEmpty) {
        o = lx.first;
      }
    }

    catch (error) {
      rethrow;
    }

    return o;
  }
}