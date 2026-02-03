import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'data_manager.dart';
import 'user_details.dart';

class AuthManager {

  String? token;
  String? role;
  bool isFirstTimeLogin = false;
  bool isFirstTimeBiometric = false;
  String? username;
  bool isLogin = false;
  bool isAppStarted = false;
  int signinType = 2;
  String playerId = '';
  bool hasUpdate = false;

  AuthManager._privateConstructor();

  static final AuthManager instance = AuthManager._privateConstructor();

  Future<void> set(String mtoken, String role, bool misFirstTimeLogin, bool misFirstTimeBiometric, String musername, bool misLogin, int signinType, String hp1, String hp2) async {
    token = mtoken;
    isFirstTimeLogin = misFirstTimeLogin;
    isFirstTimeBiometric = misFirstTimeBiometric;
    username = musername;
    isLogin = misLogin;
    await DataManager.instance.write('GmsToken', token!);
    await DataManager.instance.write('role', role);
    await DataManager.instance.write('isFirstTimeLogin', isFirstTimeLogin ? '1' : '0');
    await DataManager.instance.write('isFirstTimeBiometric', isFirstTimeBiometric ? '1' : '0');
    await DataManager.instance.write('username', username!);
    await DataManager.instance.write('isLogin', misLogin ? '1' : '0');
    await DataManager.instance.write('signinType', signinType.toString());
    if (signinType == 1) {
      await DataManager.instance.write('contact1', hp1);
      await DataManager.instance.write('contact2', hp2);
    }
  }

  Future<void> load() async {
    token = await DataManager.instance.read('GmsToken');
    role = await DataManager.instance.read('role');
    isFirstTimeLogin = (await DataManager.instance.read('isFirstTimeLogin')) == '1' ? true : false;
    isFirstTimeBiometric = await DataManager.instance.read('isFirstTimeBiometric') == '1' ? true : false;
    username = await DataManager.instance.read('username');
    isLogin = await DataManager.instance.read('isLogin') == '1' ? true : false;
    isAppStarted = await DataManager.instance.getItem('__app-started__') ?? false;
    signinType = await DataManager.instance.read('signinType') == '1' ? 1 : 2;
  }

  Future<void> setIsLogin(bool misLogin) async {
    isLogin = misLogin;
    await DataManager.instance.write('isLogin', misLogin ? '1' : '');
  }

  Future<void> signOut() async {
    bool acceptTnc = await DataManager.instance.getItem('__accepttnc__') ?? false;
    bool isAppStarted = await DataManager.instance.getItem('__app-started__') ?? false;
    String uname = await DataManager.instance.read('username') ?? '';
    String contact1 = await DataManager.instance.read('contact1') ?? '';
    String contact2 = await DataManager.instance.read('contact2') ?? '';
    String username = await DataManager.instance.read('__biometric-username__') ?? '';
    String deviceId = await DataManager.instance.read('__biometric-uuid__') ?? '';
    String signinType = await DataManager.instance.read('signinType') ?? '1';
    Map<dynamic, dynamic>? m = await DataManager.instance.getItem('biometric');
    await DataManager.instance.clear();
    await DataManager.instance.setItem('isFirstRun', false);
    await DataManager.instance.setItem('__accepttnc__', acceptTnc);
    await DataManager.instance.setItem('__app-started__', isAppStarted);
    await DataManager.instance.write('signinType', signinType);

    if (m != null) {
      await DataManager.instance.setItem('biometric', m);
    }

    if (contact1.isNotEmpty) {
      await DataManager.instance.write('contact1', contact1);
    }

    if (contact2.isNotEmpty) {
      await DataManager.instance.write('contact2', contact2);
    }

    if (uname.isNotEmpty) {
      await DataManager.instance.write('username', uname);
    }

    if (username.isNotEmpty) {
      await DataManager.instance.write('__biometric-username__', username);
      await DataManager.instance.write('__biometric-uuid__', deviceId);
    }

    isLogin = false;
  }

  Future<String> getUserMode() async {
    String userMode = 'guest';
    if (AuthManager.instance.isLogin) {
      UserDetails? userDetails = await DataManager.instance.getUserDetails();
      userMode = userDetails?.email ?? 'guest';
    }

    return userMode;
  }

  String getPlayerId() {
    String playerId = '';
    String? subId = OneSignal.User.pushSubscription.id;
    playerId = subId ?? '';

    this.playerId = playerId;
    return playerId;
  }

  Future<void> waitPlayerId() async {
    await Future.doWhile(() {
      String playerId = getPlayerId();
      if (playerId.isNotEmpty) {
        return false;
      }

      return true;
    });
  }
}
