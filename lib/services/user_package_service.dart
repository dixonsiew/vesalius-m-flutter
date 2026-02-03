import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/cart_data.dart';
import 'package:vesalius_m_flutter/models/payment_data.dart';
import 'package:vesalius_m_flutter/models/user_package_purchase_data.dart';

import 'api_helper.dart';

class UserPackageService {

  static String name = 'user-package';

  static Future<String?> postPurchaseIpay(o) async {
    String? r;

    try {
      final res = await ApiHelper.tokenDioInterceptor.post('$kServerUrl/$name/purchase/2', data: o);
      r = res.data;
    }

    catch (error) {
      rethrow;
    }

    return r;
  }

  static Future<WallexRes?> postPurchaseWallex(o) async {
    WallexRes? x;

    try {
      final res = await ApiHelper.tokenDioInterceptor.post('$kServerUrl/$name/purchase/1', data: o);
      Map<String, dynamic> m = res.data;
      x = WallexRes.fromJson(m['wallexDetails']);
    }

    catch (error) {
      rethrow;
    }

    return x;
  }

  static Future<CartStatus?> checkCartValidity(o) async {
    CartStatus? x;

    try {
      final res = await ApiHelper.tokenDioInterceptor.post('$kServerUrl/$name/check/expiry-maxpurchase', data: o);
      x = CartStatus.fromJson(res.data);
    }

    catch (error) {
      rethrow;
    }

    return x;
  }

  static Future<List<UserPackagePurchase>> getAllPackages(num page, num limit) async {
    List<UserPackagePurchase> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/$name/all/mobile', queryParameters: q);
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
      lx = ls.map((x) => UserPackagePurchase.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }
}