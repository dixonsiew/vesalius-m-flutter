import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'api_helper.dart';

Future<Map<String, dynamic>> authenticate(o) async {
  Map<String, dynamic> m = {};

  try {
    final res = await ApiHelper.dio.post('$kServer/login', data: o);
    String token = res.headers.value('Authorization')!;
    m['token'] = token;
    m['data'] = res.data;
  }

  catch (error) {
    rethrow;
  }

  return m;
}

Future<Map<String, dynamic>> signUp(num branchId, String dob, String email, String fullname, String id) async {
  Map<String, dynamic> m = {};

  try {
    final o = {
      'branchId': branchId,
      'userDOB': dob,
      'userEmail': email,
      'userFullName': fullname,
      'userPersonNumber': id
    };
    final res = await ApiHelper.dio.post('$kServer/admin/self-sign-up', data: o);
    m = res.data;
  }

  catch (error) {
    rethrow;
  }

  return m;
}

Future<Map<String, dynamic>> resetPassword(String email) async {
  Map<String, dynamic> m = {};

  try {
    final res = await ApiHelper.dio.post('$kServer/admin/self-reset-password/1/$email', data: {});
    m = res.data;
  }

  catch (error) {
    rethrow;
  }

  return m;
}

Future<Map<String, dynamic>> postVerificationCode(String verificationCode) async {
  Map<String, dynamic> m = {};

  try {
    final res = await ApiHelper.tokenDioInterceptor.post('$kServer/user/verify/$verificationCode', data: {});
    m = res.data;
  }

  catch (error) {
    rethrow;
  }

  return m;
}

Future<Map<String, dynamic>> updatePlayerId(String playerId) async {
  Map<String, dynamic> m = {};

  try {
    final res = await ApiHelper.tokenDioInterceptor.post('$kServer/user/update-playerid/$playerId', data: {});
    m = res.data;
  }

  catch (error) {
    rethrow;
  }

  return m;
}

Future<UserDetails?> getUser() async {
  UserDetails? o;

  try {
    final res = await ApiHelper.tokenDioInterceptor.get('$kServer/user');
    o = UserDetails.fromJson(res.data);
  }

  catch (error) {
    rethrow;
  }

  return o;
}
