import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/hospital_data.dart';
import 'package:vesalius_m_flutter/models/kidsclub_data.dart';

class MyMembershipCtrl extends GetxController {

  final _isLoading = false.obs;
  final _list = <KidsMembership>[].obs;
  final _hospitalData = Rx<HospitalInfo?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setList(List<KidsMembership> lx) {
    _list.clear();
    _list.addAllIf(lx.isNotEmpty, lx);
  }

  void setHospitalData(HospitalInfo? o) {
    _hospitalData.value = o;
  }

  bool get isLoading => _isLoading.value;
  List<KidsMembership> get list => [..._list];
  HospitalInfo? get hospitalData => _hospitalData.value;
}