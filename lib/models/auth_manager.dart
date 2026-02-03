import 'data_manager.dart';

class AuthManager {

  static String? token;
  static String? role;
  static bool isFirstTimeLogin = false;
  static String? username;
  static bool isLogin = false;
  static bool isAppStarted = false;

  static Future<void> set(String mtoken, String role, bool misFirstTimeLogin, String musername, bool misLogin) async {
    token = mtoken;
    isFirstTimeLogin = misFirstTimeLogin;
    username = musername;
    isLogin = misLogin;
    await DataManager.write('GmsToken', token!);
    await DataManager.write('role', role);
    await DataManager.write('isFirstTimeLogin', '1');
    await DataManager.write('username', username!);
    await DataManager.write('isLogin', '1');
  }

  static Future<void> load() async {
    token = await DataManager.read('GmsToken');
    role = await DataManager.read('role');
    isFirstTimeLogin = (await DataManager.read('isFirstTimeLogin')) == '1' ? true  : false;
    username = await DataManager.read('username');
    isLogin = (await DataManager.read('isLogin') ?? '') == '1' ? true : false;
  }

  static Future<void> setIsLogin(bool misLogin) async {
    isLogin = misLogin;
    await DataManager.write('isLogin', misLogin ? '1' : '');
  }

  static Future<void> signOut() async {
    String username = await DataManager.read('__biometric-username__') ?? '';
    String deviceId = await DataManager.read('__biometric-uuid__') ?? '';
    Map<dynamic, dynamic>? m = await DataManager.getItem('biometric');
    await DataManager.clear();
    if (m != null) {
      await DataManager.setItem('biometric', m);
    }

    if (username.isNotEmpty) {
      await DataManager.write('__biometric-username__', username);
      await DataManager.write('__biometric-uuid__', deviceId);
    }

    isLogin = false;
  }
}
