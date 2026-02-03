import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';

class UpcomingAppointmentCtrl extends GetxController {

  final _isLoading = false.obs;
  final _list = <PatientAppointment>[].obs;
  final _listx = <PatientAppointment>[].obs;
  final _count = 0.obs;
  final _countx = 0.obs;

  void setInit() {
    _list.clear();
  }

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setList(List<PatientAppointment> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }

    setCount(lx.length);
  }

  void setListX(List<PatientAppointment> lx) {
    _listx.clear();
    _listx.addAllIf(lx.isNotEmpty, lx);
    setCountX(lx.length);
  }

  void setCount(int n) {
    _count.value = n;
  }

  void setCountX(int n) {
    _countx.value = n;
  }

  void remove(String apptNo) {
    _list.removeWhere((o) => o.apptNo == apptNo);
    _count.value = _count.value - 1;
  }

  Future<void> load() async {
    final branchDetails = DataManager.instance.branchDetails!;
    List<PatientAppointment> lx = await VesaliusService.getPatientVesaliusFutureAppointments(branchDetails.branch!.branchId!, branchDetails.prn!);
    setInit();
    setList(lx);
  }

  Future<void> loadSoonest() async {
    final branchDetails = DataManager.instance.branchDetails!;
    List<PatientAppointment> lx = await VesaliusService.getPatientVesaliusFutureAppointments(branchDetails.branch!.branchId!, branchDetails.prn!, 1);
    setListX(lx);
  }

  bool get isLoading => _isLoading.value;
  List<PatientAppointment> get list => [..._list];
  List<PatientAppointment> get listx => [..._listx];
  int get count => _count.value;
  int get countx => _countx.value;
}