import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/way_finding_data.dart';

import 'api_helper.dart';

class WayFindingService {

  static String name = 'way-finding';

  static Future<Location?> getLocationQr(String locationId, String locationTypeId) async {
    Location? x;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/location-qr/$locationId/$locationTypeId');
      if (res.data == null) {
        return x;
      }

      x = Location.fromJson(res.data);
    }

    catch (error) {
      rethrow;
    }

    return x;
  }

  static Future<Route?> getRoute(num fromId, num toId) async {
    Route? x;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/route/$fromId/$toId');
      if (res.data == null) {
        return x;
      }

      x = Route.fromJson(res.data);
    }

    catch (error) {
      rethrow;
    }

    return x;
  }

  static Future<List<WayFinding>> getAllFloors() async {
    List<WayFinding> lx;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/floors');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => WayFinding.fromJson(x)).toList();
      lx = lx.reversed.toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<LocationType>> getAllLocationTypes(num page, num limit) async {
    List<LocationType> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.dio.get('$kServerUrl/$name/location-types', queryParameters: q);
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
      lx = ls.map((x) => LocationType.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<LocationType>> searchLocationTypes(num page, num limit, String keyword) async {
    List<LocationType> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final o = {
        'keyword': keyword
      };
      final res = await ApiHelper.dio.post('$kServerUrl/$name/location-types', data: o, queryParameters: q);
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
      lx = ls.map((x) => LocationType.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<Location>> getAllLocations(String code, num page, num limit) async {
    List<Location> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.dio.get('$kServerUrl/$name/location/$code', queryParameters: q);
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
      lx = ls.map((x) => Location.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<Location>> searchLocations(String code, num page, num limit, String keyword) async {
    List<Location> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final o = {
        'keyword': keyword
      };
      final res = await ApiHelper.dio.post('$kServerUrl/$name/location/$code', data: o, queryParameters: q);
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
      lx = ls.map((x) => Location.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }
}