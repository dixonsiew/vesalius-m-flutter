import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/qms_data.dart';

class QueueTrackerCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isDown = false.obs;
  final _isNoNetwork = false.obs;
  final _list = <QmsReq>[].obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsDown(bool b) {
    _isDown.value = b;
  }

  void setIsNoNetwork(bool b) {
    _isNoNetwork.value = b;
  }

  void setList(List<QmsReq> lx) {
    _list.clear();
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  bool get isLoading => _isLoading.value;
  bool get isDown => _isDown.value;
  bool get isNoNetwork => _isNoNetwork.value;
  List<QmsReq> get list => [..._list];
}