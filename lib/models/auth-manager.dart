import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {

  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static String? token;
  static String? role;
  static bool isFirstTimeLogin = false;
  static String? username;
  static bool isLogin = false;

  static Future<void> set(String _token, String role, bool _isFirstTimeLogin, String _username, bool _isLogin) async {
    token = _token;
    isFirstTimeLogin = _isFirstTimeLogin;
    username = _username;
    isLogin = _isLogin;
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('GmsToken', token!);
    await prefs.setString('role', role);
    await prefs.setBool('isFirstTimeLogin', isFirstTimeLogin);
    await prefs.setString('username', username!);
    await prefs.setBool('isLogin', isLogin);
  }

  static Future<void> load() async {
    final SharedPreferences prefs = await _prefs;
    token = prefs.getString('GmsToken');
    role = prefs.getString('role');
    isFirstTimeLogin = prefs.getBool('isFirstTimeLogin') ?? false;
    username = prefs.getString('username');
    isLogin = prefs.getBool('isLogin') ?? false;
  }

  static Future<void> setIsLogin(bool _isLogin) async {
    isLogin = _isLogin;
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('isLogin', isLogin);
  }
}
