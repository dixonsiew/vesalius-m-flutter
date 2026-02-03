import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'api_helper.dart';

class AuthService {

  static Future<Map<String, dynamic>> authenticate(o) async {
    Map<String, dynamic> m = {};

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/login', data: o);
      String token = res.headers.value('Authorization')!;
      m['token'] = token;
      m['data'] = res.data;
    }

    catch (error) {
      rethrow;
    }

    return m;
  }
}

class AdminService {

  static Future<Map<String, dynamic>> signUp(num branchId, String dob, String email, String fullname, String id) async {
    Map<String, dynamic> m = {};

    try {
      final o = {
        'branchId': branchId,
        'userDOB': dob,
        'userEmail': email,
        'userFullName': fullname,
        'userPersonNumber': id
      };
      final res = await ApiHelper.dio.post('$kServerUrl/admin/self-sign-up', data: o);
      m = res.data;
    }

    catch (error) {
      rethrow;
    }

    return m;
  }

  static Future<Map<String, dynamic>> resetPassword(String email) async {
    Map<String, dynamic> m = {};

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/admin/self-reset-password/1/$email', data: {});
      m = res.data;
    }

    catch (error) {
      rethrow;
    }

    return m;
  }
}

class UserService {

  static Future<Map<String, dynamic>> postVerificationCode(String verificationCode) async {
    Map<String, dynamic> m = {};

    try {
      final res = await ApiHelper.tokenDioInterceptor.post('$kServerUrl/user/verify/$verificationCode', data: {});
      m = res.data;
    }

    catch (error) {
      rethrow;
    }

    return m;
  }

  static Future<Map<String, dynamic>> updatePlayerId(String playerId) async {
    Map<String, dynamic> m = {};

    try {
      final res = await ApiHelper.tokenDioInterceptor.post('$kServerUrl/user/update-playerid/$playerId', data: {});
      m = res.data;
    }

    catch (error) {
      rethrow;
    }

    return m;
  }

  static Future<Map<String, dynamic>> addMachineId(o) async {
    Map<String, dynamic> m = {};

    try {
      final res = await ApiHelper.tokenDioInterceptor.post('$kServerUrl/user/add-machine-id', data: o);
      m = res.data;
    }

    catch (error) {
      rethrow;
    }

    return m;
  }

  static Future<UserDetails?> getUser() async {
    UserDetails? o;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/user');
      o = UserDetails.fromJson(res.data);
    }

    catch (error) {
      rethrow;
    }

    return o;
  }

  static Future<void> changePassword(o) async {
    try {
      await ApiHelper.tokenDioInterceptor.post('$kServerUrl/user/change-password', data: o);
    }

    catch (error) {
      rethrow;
    }
  }

  static Future<List<UserBranch>> getUserBranches() async {
    List<UserBranch> lx;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/user/branches');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => UserBranch.fromJson(x)).toList();
    }
    
    catch (error) {
      rethrow;
    }

    return lx;
  }
}