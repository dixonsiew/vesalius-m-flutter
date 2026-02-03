import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'api_helper.dart';

class AuthService {

  static Future<Map<String, dynamic>> authenticateMobile(o) async {
    Map<String, dynamic> m = {};

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/login/v2', data: o);
      m = res.data;
    }

    catch (error) {
      rethrow;
    }

    return m;
  }

  static Future<Map<String, dynamic>> authenticateEmail(o) async {
    Map<String, dynamic> m = {};

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/login/v2', data: o);
      String token = res.headers.value('Authorization')!;
      m['token'] = token;
      m['data'] = res.data;
    }

    catch (error) {
      rethrow;
    }

    return m;
  }

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

  static Future<void> logout() async {
    try {
      await ApiHelper.tokenDioInterceptor.post('$kServerUrl/logout', data: {});
    }

    catch (error) {
      rethrow;
    }
  }
}

class AdminService {

  static Future<Map<String, dynamic>> signUpV2(num branchId, String prn, String dob, String mobile, String email, String fullname, String id, String pwd, String playerId, int sType) async {
    Map<String, dynamic> m = {};

    try {
      final o = {
        'branchId': branchId,
        'userPrn': prn,
        'userDOB': dob,
        'userMobileNo': mobile,
        'userEmail': email,
        'userFullName': fullname,
        'userPersonNumber': id,
        'userPassword': pwd,
        'playerId': playerId,
        'signInType': sType
      };
      final res = await ApiHelper.dio.post('$kServerUrl/admin/self-sign-up/v2', data: o);
      m = res.data;
    }

    catch (error) {
      rethrow;
    }

    return m;
  }

  static Future<Map<String, dynamic>> signUp(num branchId, String dob, String email, String fullname, String id, String pwd, String playerId) async {
    Map<String, dynamic> m = {};

    try {
      final o = {
        'branchId': branchId,
        'userDOB': dob,
        'userEmail': email,
        'userFullName': fullname,
        'userPersonNumber': id,
        'userPassword': pwd,
        'playerId': playerId
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

  static Future<void> postPlayerID(o) async {
    try {
      await ApiHelper.dio.post('$kServerUrl/common/downloaded-app/v2', data: o);
    }

    catch (error) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> postVerifySmsTacSignIn(String hp, String tac) async {
    Map<String, dynamic> m = {};

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/user/verify-smstac', data: { 'mobileNo': hp, 'tac': tac });
      m = res.data;
    }

    catch (error) {
      rethrow;
    }

    return m;
  }

  /* static Future<bool> postVerifySmsTacSignUp(String hp, String tac) async {
    bool b = false;

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/user/verify-smstac/signup', data: { 'mobileNo': hp, 'tac': tac });
      final m = res.data as Map<String, dynamic>;
      if (m['signUpVerified'] == true) {
        b = true;
      }
    }
    
    catch (error) {
      rethrow;
    }

    return b;
  } */

  static Future<Map<String, dynamic>> postVerificationCode(String email, String verificationCode) async {
    Map<String, dynamic> m = {};

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/user/verify-email', data: { 'email': email, 'verificationCode': verificationCode });
      m = res.data;
    }

    catch (error) {
      rethrow;
    }

    return m;
  }

  static Future<Map<String, dynamic>> postResetPassword(o) async {
    Map<String, dynamic> m = {};

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/user/set-new-password', data: o);
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

  static Future<void> disableFirstTimeBiometric() async {
    try {
      await ApiHelper.tokenDioInterceptor.post('$kServerUrl/user/disable-firsttime-bio', data: {});
    }

    catch (error) {
      rethrow;
    }
  }

  static Future<void> deleteAccount() async {
    try {
      await ApiHelper.tokenDioInterceptor.post('$kServerUrl/user/delete-account', data: {});
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