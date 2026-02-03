import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/bill_data.dart';
import 'package:vesalius_m_flutter/models/payment_data.dart';
import 'package:vesalius_m_flutter/services/api_helper.dart';

class UserBillingService {

  static String name = 'user-billing';

  static Future<String?> postPurchaseIpay(o) async {
    String? r;

    try {
      final res = await ApiHelper.tokenDioInterceptor.post('$kServerUrl/$name/pay/2', data: o);
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
      final res = await ApiHelper.tokenDioInterceptor.post('$kServerUrl/$name/pay/1', data: o);
      Map<String, dynamic> m = res.data;
      x = WallexRes.fromJson(m['wallexDetails']);
    }

    catch (error) {
      rethrow;
    }

    return x;
  }

  static Future<List<PaidBill>> getPaidBills(num page, num limit) async {
    List<PaidBill> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/$name/paid/all/mobile', queryParameters: q);
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
      lx = ls.map((x) => PaidBill.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }
}