import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/goldenclub_data.dart';
import 'package:vesalius_m_flutter/models/kidsclub_data.dart';

import 'api_helper.dart';

class ClubsService {

  static String name = 'clubs';

  static Future<KidsClub?> getLittleKidsAboutUs() async {
    KidsClub? o;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/$name/littlekids/about-us');
      o = KidsClub.fromJson(res.data);
    }

    catch (error) {
      rethrow;
    }

    return o;
  }

  static Future<List<KidsActivity>> getAllLittleKidsActivities(num page, num limit, [int home = 0]) async {
    List<KidsActivity> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/$name/littlekids/activity/all/mobile/$home', queryParameters: q);
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
      lx = ls.map((x) => KidsActivity.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<MyKidsActivity>> getAllLittleKidsMyActivities(num page, num limit, [int home = 0]) async {
    List<MyKidsActivity> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/$name/littlekids/my-activity/all', queryParameters: q);
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      // int totalPage = int.parse(res.headers['x-total-page']!.first);
      // if (page > totalPage) {
      //   lx = [];
      //   return lx;
      // }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => MyKidsActivity.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  } 

  static Future<List<KidsMembership>> getAllLittleKidsMemberships(num page, num limit) async {
    List<KidsMembership> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/$name/littlekids/membership/all/mobile', queryParameters: q);
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      // int totalPage = int.parse(res.headers['x-total-page']!.first);
      // if (page > totalPage) {
      //   lx = [];
      //   return lx;
      // }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => KidsMembership.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<void> postLittleKidsMembership(o) async {
    try {
      await ApiHelper.tokenDioInterceptor.post('$kServerUrl/$name/littlekids/membership', data: o);
    }

    catch (error) {
      rethrow;
    }
  }

  static Future<void> postLittleKidsActivityJoin(o) async {
    try {
      await ApiHelper.tokenDioInterceptor.post('$kServerUrl/$name/littlekids/activity/participate', data: o);
    }

    catch (error) {
      rethrow;
    }
  }

  static Future<GoldenPearlClub?> getGoldenPearlAboutUs() async {
    GoldenPearlClub? o;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/$name/goldenpearl/about-us');
      o = GoldenPearlClub.fromJson(res.data);
    }

    catch (error) {
      rethrow;
    }

    return o;
  }

  static Future<List<GoldenPearlActivity>> getAllGoldenPearlActivities(num page, num limit, [int home = 0]) async {
    List<GoldenPearlActivity> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/$name/goldenpearl/activity/all/mobile/$home', queryParameters: q);
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
      lx = ls.map((x) => GoldenPearlActivity.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<MyGoldenPearlActivity>> getAllGoldenPearlMyActivities(num page, num limit, [int home = 0]) async {
    List<MyGoldenPearlActivity> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/$name/goldenpearl/my-activity/all', queryParameters: q);
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      // int totalPage = int.parse(res.headers['x-total-page']!.first);
      // if (page > totalPage) {
      //   lx = [];
      //   return lx;
      // }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => MyGoldenPearlActivity.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<GoldenPearlMembership>> getAllGoldenPearlMemberships(num page, num limit) async {
    List<GoldenPearlMembership> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/$name/goldenpearl/membership/all/mobile', queryParameters: q);
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      // int totalPage = int.parse(res.headers['x-total-page']!.first);
      // if (page > totalPage) {
      //   lx = [];
      //   return lx;
      // }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => GoldenPearlMembership.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<void> postGoldenPearlMembership(o) async {
    try {
      await ApiHelper.tokenDioInterceptor.post('$kServerUrl/$name/goldenpearl/membership', data: o);
    }

    catch (error) {
      rethrow;
    }
  }

  static Future<void> postGoldenPearlActivityJoin(o) async {
    try {
      await ApiHelper.tokenDioInterceptor.post('$kServerUrl/$name/goldenpearl/activity/participate', data: o);
    }

    catch (error) {
      rethrow;
    }
  }
}