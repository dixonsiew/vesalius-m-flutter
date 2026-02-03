import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/goldenclub_data.dart';

class JoinClubActivityCtrl extends GetxController {

  final _goldenPearlActivity = Rx<GoldenPearlActivity?>(null);

  void setGoldenPearlActivity(GoldenPearlActivity? o) {
    _goldenPearlActivity.value = o;
  }

  GoldenPearlActivity? get goldenPearlActivity => _goldenPearlActivity.value;
}