import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {

  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static String? token;
  static String? role;
  static bool isFirstTimeLogin = false;
  static String? username;
  static bool isLogin = false;

  static Future<void> set(String mtoken, String role, bool misFirstTimeLogin, String musername, bool misLogin) async {
    token = mtoken;
    isFirstTimeLogin = misFirstTimeLogin;
    username = musername;
    isLogin = misLogin;
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

  static Future<void> setIsLogin(bool misLogin) async {
    isLogin = misLogin;
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('isLogin', isLogin);
  }
}
