import 'package:get/get.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/notification_data.dart';
import 'package:vesalius_m_flutter/services/guest_service.dart';
import 'package:vesalius_m_flutter/services/notification_service.dart';

class NotificationsCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _page = 1.obs;
  final _list = <NotificationX>[].obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsLoadingMore(bool b) {
    _isLoadingMore.value = b;
  }

  void setPage(int i) {
    _page.value = i;
  }

  void setSeen(int s) {
    int i = _list.indexWhere((o) => o.notificationId == s);
    NotificationX x = _list[i];
    x.isSeen = true;
    _list[i] = x;
  }

  Future<void> load() async {
    if (AuthManager.instance.isLogin) {
      setPage(1);
      List<NotificationX> lx = await NotificationService.getNotifications(page, kPageSize);
      _list.clear();
      _list.addAll(lx);
    }
    
    else {
      setPage(1);
      List<NotificationX> lx = await GuestModeService.getNotifications(AuthManager.instance.playerId, page, kPageSize);
      _list.clear();
      _list.addAll(lx);
    }
  }

  Future<void> loadMore() async {
    if (AuthManager.instance.isLogin) {
      int p = page + 1;
      List<NotificationX> lx = await NotificationService.getNotifications(p, kPageSize);
      if (lx.isNotEmpty) {
        setPage(p);
        _list.addAll(lx);
      }
    }

    else {
      int p = page + 1;
      List<NotificationX> lx = await GuestModeService.getNotifications(AuthManager.instance.playerId, p, kPageSize);
      if (lx.isNotEmpty) {
        setPage(p);
        _list.addAll(lx);
      }
    }
  }

  Future<void> loadFix(int n) async {
    List<NotificationX> lx = await NotificationService.getNotifications(1, n);
    _list.insertAll(0, lx);
  }

  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  int get page => _page.value;
  List<NotificationX> get list => [..._list];
}