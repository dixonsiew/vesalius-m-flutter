import 'package:dio/dio.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/family_data.dart';
import 'package:vesalius_m_flutter/models/future_order_data.dart';
import 'package:vesalius_m_flutter/models/qms_data.dart';
import 'api_helper.dart';

class MyFamilyService {

  static Future<List<Family>> getAllFamilies(num page, num limit, [bool includeSelf = false, bool onlyPatient = false]) async {
    List<Family> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit,
        '_self': includeSelf ? 1 : 0,
        '_isForAppt': onlyPatient ? 1 : 0
      };
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/my-family', queryParameters: q);
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
      lx = ls.map((x) => Family.fromJson(x)).toList();
    }
    
    catch (error) {
      rethrow;
    }

    return lx;
  }
}

class FeedbackService {

  static Future<void> postFeedback(o) async {
    try {
      final formData = FormData.fromMap(o);
      await ApiHelper.tokenDioInterceptor.post('$kServerUrl/feedback', data: formData);
    }

    catch (error) {
      rethrow;
    }
  }
}

class FutureOrderService {

  static Future<List<FutureOrder>> getAllFutureOrders(String prn, num page, num limit) async {
    List<FutureOrder> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/future-order/all/$prn', queryParameters: q);
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
      lx = ls.map((x) => FutureOrder.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }
}

class QmsService {

  static Future<List<QmsReq>> getAllQmsRequests() async {
    List<QmsReq> lx;

    try {
      final res = await ApiHelper.tokenDioInterceptor.post('$kServerUrl/qms/backend/qms_request', data: {});
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => QmsReq.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }
}