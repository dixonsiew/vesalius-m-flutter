import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/goldenclub_data.dart';

class SelectMemberCtrl extends GetxController {

  final _isLoading = false.obs;
  final _list = <GoldenPearlMembership>[].obs;
  final _selectedMemberList = <GoldenPearlMembership>[].obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setList(List<GoldenPearlMembership> lx) {
    _list.clear();
    _list.addAllIf(lx.isNotEmpty, lx);
    setMember([]);
  }

  void setMember(List<GoldenPearlMembership> lx) {
    _selectedMemberList.clear();
    _selectedMemberList.addAllIf(lx.isNotEmpty, lx);
  }

  void addMember(GoldenPearlMembership o) {
    _selectedMemberList.add(o);
  }

  void removeMember(GoldenPearlMembership o) {
    _selectedMemberList.removeWhere((x) => x.goldenMembershipId == o.goldenMembershipId);
  }

  bool hasMemberId(int id) {
    return _selectedMemberList.any((o) => o.goldenMembershipId == id);
  }

  bool get isLoading => _isLoading.value;
  List<GoldenPearlMembership> get list => [..._list];
  List<GoldenPearlMembership> get selectedMemberList => [..._selectedMemberList];
}