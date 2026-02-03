import 'package:hive/hive.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/main.dart';

import 'cart_data.dart';
import 'doctor_data.dart';

class UserDataManager {

  UserDataManager._privateConstructor();

  static final UserDataManager instance = UserDataManager._privateConstructor();

  Future<LazyBox> initHive() async {
    return await Hive.openLazyBox(kHiveBoxUserName);
  }

  Future<void> addDoctorBookmark(String userMode, DoctorInfo o) async {
    o.date = DateTime.now();
    final m = await getItem('doctorBookmarkList') as Map<dynamic, dynamic>? ?? {};
    if (m.containsKey(userMode)) {
      List lo = m[userMode] ?? [];
      List<DoctorInfo> la = lo.cast<DoctorInfo>();
      if (la.indexWhere((x) => x.mcr == o.mcr) < 0) {
        la.add(o);
        m[userMode] = la;
      }
    }

    else {
      List<DoctorInfo> la = [o];
      m.putIfAbsent(userMode, () => la);
    }

    await setItem('doctorBookmarkList', m);
  }

  Future<void> removeDoctorBookmark(String userMode, String mcr) async {
    final m = await getItem('doctorBookmarkList') as Map<dynamic, dynamic>? ?? {};
    if (m.containsKey(userMode)) {
      List lo = m[userMode] ?? [];
      List<DoctorInfo> la = lo.cast<DoctorInfo>();
      la.removeWhere((x) => x.mcr == mcr);
      m[userMode] = la;
      await setItem('doctorBookmarkList', m);
    }
  }

  Future<List<String>> getDoctorBookmarkMCRList(String userMode) async {
    final m = await getItem('doctorBookmarkList') as Map<dynamic, dynamic>? ?? {};
    if (m.containsKey(userMode)) {
      List lo = m[userMode] ?? [];
      List<DoctorInfo> la = lo.cast<DoctorInfo>();
      return la.map((x) => x.mcr!).toList();
    }

    return [];
  }

  Future<List<DoctorInfo>> getDoctorBookmarkList(String userMode) async {
    final m = await getItem('doctorBookmarkList') as Map<dynamic, dynamic>? ?? {};
    if (m.containsKey(userMode)) {
      List lo = m[userMode] ?? [];
      List<DoctorInfo> la = lo.cast<DoctorInfo>();
      la.sort((a, b) {
        return b.date!.compareTo(a.date!);
      });
      return la;
    }

    return [];
  }

  Future<void> clearCart(String userMode) async {
    final m = await getItem('myCart') as Map<dynamic, dynamic>? ?? {};
    if (m.containsKey(userMode)) {
      m[userMode] = [];
    }

    await setItem('myCart', m);
  }

  Future<void> addToCart(String userMode, MyCartItem o) async {
    o.date = DateTime.now();
    final m = await getItem('myCart') as Map<dynamic, dynamic>? ?? {};
    if (m.containsKey(userMode)) {
      List lo = m[userMode] ?? [];
      List<MyCartItem> la = lo.cast<MyCartItem>();
      la.add(o);
      m[userMode] = la;
    }

    else {
      List<MyCartItem> la = [o];
      m.putIfAbsent(userMode, () => la);
    }

    await setItem('myCart', m);
  }

  Future<void> removeFromCart(String userMode, int packageId) async {
    final m = await getItem('myCart') as Map<dynamic, dynamic>? ?? {};
    if (m.containsKey(userMode)) {
      List lo = m[userMode] ?? [];
      List<MyCartItem> la = lo.cast<MyCartItem>();
      la.removeWhere((x) => x.id == packageId);
      m[userMode] = la;
      await setItem('myCart', m);
    }
  }

  Future<void> updateCart(String userMode, int packageId, MyCartItem o) async {
    o.date = DateTime.now();
    final m = await getItem('myCart') as Map<dynamic, dynamic>? ?? {};
    if (m.containsKey(userMode)) {
      List lo = m[userMode] ?? [];
      List<MyCartItem> la = lo.cast<MyCartItem>();
      int i = la.indexWhere((x) => x.id == packageId);
      if (i >= 0) {
        la[i] = o;
      }

      else {
        la.add(o);
      }

      m[userMode] = la;
    }

    else {
      List<MyCartItem> la = [o];
      m.putIfAbsent(userMode, () => la);
    }

    await setItem('myCart', m);
  }

  Future<List<MyCartItem>> getMyCartList(String userMode) async {
    final m = await getItem('myCart') as Map<dynamic, dynamic>? ?? {};
    if (m.containsKey(userMode)) {
      List lo = m[userMode] ?? [];
      List<MyCartItem> la = lo.cast<MyCartItem>();
      la.sort((a, b) {
        return a.date!.compareTo(b.date!);
      });
      return la;
    }

    return [];
  }

  Future<void> setItem(String key, dynamic o) async {
    await boxUser.put(key, o);
  }

  Future<dynamic> getItem(String key) async {
    return await boxUser.get(key);
  }

  Future<void> removeItem(String key) async {
    await boxUser.delete(key);
  }
}