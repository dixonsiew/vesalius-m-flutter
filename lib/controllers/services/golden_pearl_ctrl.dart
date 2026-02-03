import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/goldenclub_data.dart';

class GoldenPearlCtrl extends GetxController {

  final _isLoading = false.obs;
  final _goldenPearlClub = Rx<GoldenPearlClub?>(null);
  final _list = <GoldenPearlActivity>[].obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setGoldenPearlClub(GoldenPearlClub? o) {
    _goldenPearlClub.value = o;
  }

  void setList(List<GoldenPearlActivity> lx) {
    _list.clear();
    _list.addAllIf(lx.isNotEmpty, lx);
  }

  bool get isLoading => _isLoading.value;
  GoldenPearlClub? get goldenPearlClub => _goldenPearlClub.value;
  List<GoldenPearlActivity> get list => [..._list];
}