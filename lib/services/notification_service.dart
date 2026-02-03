import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/notification_data.dart';

import 'api_helper.dart';

class NotificationService {

  static Future<List<NotificationX>> getNotifications(num page, num limit) async {
    List<NotificationX> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/notification/all', queryParameters: q);
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
      lx = ls.map((x) => NotificationX.fromJson(x)).toList();
    }
    
    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<NotificationX?> getNotification(int notificationId) async {
    NotificationX? o;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/notification/$notificationId');
      o = NotificationX.fromJson(res.data);
    }

    catch (error) {
      rethrow;
    }

    return o;
  }

  static Future<int> postNotificationSeen(int notificationId) async {
    int n = 0;

    try {
      final res = await ApiHelper.tokenDioInterceptor.post('$kServerUrl/notification/seen/$notificationId', data: {});
      Map<String, dynamic> m = res.data;
      if (m.containsKey('userUnseenCount')) {
        n = m['userUnseenCount'];
      }
    }

    catch (error) {
      rethrow;
    }

    return n;
  }

  static Future<int> getUnseenCount() async {
    int n = 0;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/notification/unseen/count');
      n = res.data as int;
    }

    catch (error) {
      rethrow;
    }

    return n;
  }
}