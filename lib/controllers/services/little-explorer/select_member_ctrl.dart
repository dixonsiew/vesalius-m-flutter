import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/kidsclub_data.dart';

class SelectMemberCtrl extends GetxController {

  final _isLoading = false.obs;
  final _list = <KidsMembership>[].obs;
  final _selectedMemberList = <KidsMembership>[].obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setList(List<KidsMembership> lx) {
    _list.clear();
    _list.addAllIf(lx.isNotEmpty, lx);
    setMember([]);
  }

  void setMember(List<KidsMembership> lx) {
    _selectedMemberList.clear();
    _selectedMemberList.addAllIf(lx.isNotEmpty, lx);
  }

  void addMember(KidsMembership o) {
    _selectedMemberList.add(o);
  }

  void removeMember(KidsMembership o) {
    _selectedMemberList.removeWhere((x) => x.kidsMembershipId == o.kidsMembershipId);
  }

  bool hasMemberId(int id) {
    return _selectedMemberList.any((o) => o.kidsMembershipId == id);
  }

  bool get isLoading => _isLoading.value;
  List<KidsMembership> get list => [..._list];
  List<KidsMembership> get selectedMemberList => [..._selectedMemberList];
}