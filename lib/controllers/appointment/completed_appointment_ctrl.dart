import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

class CompletedAppointmentCtrl extends GetxController {

  final _isLoading = false.obs;
  final _list = <PastAppointment>[].obs;
  final _count = 0.obs;

  void setInit() {
    _list.clear();
  }

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setList(List<PastAppointment> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }

    setCount(lx.length);
  }

  void setCount(int n) {
    _count.value = n;
  }

  Future<void> load() async {
    final branchDetails = DataManager.branchDetails!;
    List<PastAppointment> lx = await VesaliusService.getVesaliusPastAppointments(branchDetails.branch!.branchId!, branchDetails.prn!);
    setInit();
    setList(lx);
  }

  bool get isLoading => _isLoading.value;
  List<PastAppointment> get list => [..._list];
  int get count => _count.value;
}