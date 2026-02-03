import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/logistic_arrangement_data.dart';

import 'api_helper.dart';

class LogisticService {

  static String name = 'logistic';

  static Future<List<LogisticRequest>> getAllLogisticRequests(num page, num limit) async {
    List<LogisticRequest> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/$name/request/all/mobile', queryParameters: q);
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
      lx = ls.map((x) => LogisticRequest.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<void> postLogisticRequestStatus(o) async {
    try {
      await ApiHelper.tokenDioInterceptor.post('$kServerUrl/$name/request/status', data: o);
    }

    catch (error) {
      rethrow;
    }
  }

  static Future<void> postLogisticRequest(o) async {
    try {
      await ApiHelper.tokenDioInterceptor.post('$kServerUrl/$name/request', data: o);
    }

    catch (error) {
      rethrow;
    }
  }

  static Future<List<LogisticSlot>> postLogisticSlots(o) async {
    List<LogisticSlot> lx;

    try {
      final res = await ApiHelper.tokenDioInterceptor.post('$kServerUrl/$name/slot/all/mobile', data: o);
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => LogisticSlot.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<String> getTnC() async {
    String s = '';

    try {
      final res = await ApiHelper.tokenDioInterceptor.get(('$kServerUrl/$name/setup'));
      final m = res.data as Map<String, dynamic>;
      s = m['logisticSetupValue'];
    }

    catch (error) {
      rethrow;
    }

    return s;
  }
}