import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/kidsclub_data.dart';

class LittleExplorerCtrl extends GetxController {

  final _isLoading = false.obs;
  final _kidsClub = Rx<KidsClub?>(null);
  final _list = <KidsActivity>[].obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setKidsClub(KidsClub? o) {
    _kidsClub.value = o;
  }

  void setList(List<KidsActivity> lx) {
    _list.clear();
    _list.addAllIf(lx.isNotEmpty, lx);
  }

  bool get isLoading => _isLoading.value;
  KidsClub? get kidsClub => _kidsClub.value;
  List<KidsActivity> get list => [..._list];
}