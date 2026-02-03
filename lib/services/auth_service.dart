import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'api_helper.dart';

Future<Map<String, dynamic>> authenticate(o) async {
  Map<String, dynamic> m = {};

  try {
    var res = await ApiHelper.dio.post('$kServerUrl/login', data: o);
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
    var o = {
      'branchId': branchId,
      'userDOB': dob,
      'userEmail': email,
      'userFullName': fullname,
      'userPersonNumber': id
    };
    var res = await ApiHelper.dio.post('$kServerUrl/admin/self-sign-up', data: o);
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
    var res = await ApiHelper.dio.post('$kServerUrl/admin/self-reset-password/1/$email', data: {});
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
    var res = await ApiHelper.tokenDioInterceptor.post('$kServerUrl/user/verify/$verificationCode', data: {});
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
    var res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/user');
    o = UserDetails.fromJson(res.data);
  }

  catch (error) {
    rethrow;
  }

  return o;
}
