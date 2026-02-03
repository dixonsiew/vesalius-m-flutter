import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/kidsclub_data.dart';

class JoinClubActivityCtrl extends GetxController {

  final _kidsActivity = Rx<KidsActivity?>(null);

  void setKidsActivity(KidsActivity? o) {
    _kidsActivity.value = o;
  }

  KidsActivity? get kidsActivity => _kidsActivity.value;
}