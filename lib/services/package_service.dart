import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/package_data.dart';

import 'api_helper.dart';

class PackageService {

  static Future<List<Package>> getAllPackages(num page, num limit, [int home = 0]) async {
    List<Package> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/package/all/mobile/$home', queryParameters: q);
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
      lx = ls.map((x) => Package.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<PackageStatus?> getPackageStatus(int packageId) async {
    PackageStatus? o;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/package/packageStatus/$packageId');
      o = PackageStatus.fromJson(res.data);
    }

    catch (error) {
      rethrow;
    }

    return o;
  }
}