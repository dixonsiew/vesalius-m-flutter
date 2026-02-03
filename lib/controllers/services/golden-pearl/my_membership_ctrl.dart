import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/goldenclub_data.dart';
import 'package:vesalius_m_flutter/models/hospital_data.dart';

class MyMembershipCtrl extends GetxController {

  final _isLoading = false.obs;
  final _list = <GoldenPearlMembership>[].obs;
  final _hospitalData = Rx<HospitalInfo?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setList(List<GoldenPearlMembership> lx) {
    _list.clear();
    _list.addAllIf(lx.isNotEmpty, lx);
  }

  void setHospitalData(HospitalInfo? o) {
    _hospitalData.value = o;
  }

  bool get isLoading => _isLoading.value;
  List<GoldenPearlMembership> get list => [..._list];
  HospitalInfo? get hospitalData => _hospitalData.value;
}