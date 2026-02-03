import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class HealthDashboardCtrl extends GetxController {

  final _isLoading = false.obs;

  final _bpList = <VitalSignsData>[].obs;
  final _bmiList = <VitalSignsData>[].obs;
  final _prList = <VitalSignsData>[].obs;
  final _heightList = <VitalSignsData>[].obs;
  final _weightList = <VitalSignsData>[].obs;

  final _hdlList = <LabData>[].obs;
  final _ldlList = <LabData>[].obs;
  final _gluList = <LabData>[].obs;
  final _hmgList = <LabData>[].obs;

  final _tabIndex = 0.obs;
  final _current0 = 0.obs;
  final _current1 = 0.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setBpList(List<VitalSignsData> lx) {
    _bpList.clear();
    _bpList.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _bpList.clear();
    }
  }

  void setBmiList(List<VitalSignsData> lx) {
    _bmiList.clear();
    _bmiList.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _bmiList.clear();
    }
  }

  void setPrList(List<VitalSignsData> lx) {
    _prList.clear();
    _prList.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _prList.clear();
    }
  }

  void setHeightList(List<VitalSignsData> lx) {
    _heightList.clear();
    _heightList.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _heightList.clear();
    }
  }

  void setWeightList(List<VitalSignsData> lx) {
    _weightList.clear();
    _weightList.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _weightList.clear();
    }
  }

  void setHdlList(List<LabData> lx) {
    _hdlList.clear();
    _hdlList.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _hdlList.clear();
    }
  }

  void setLdlList(List<LabData> lx) {
    _ldlList.clear();
    _ldlList.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _ldlList.clear();
    }
  }

  void setGluList(List<LabData> lx) {
    _gluList.clear();
    _gluList.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _gluList.clear();
    }
  }

  void setHmgList(List<LabData> lx) {
    _hmgList.clear();
    _hmgList.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _hmgList.clear();
    }
  }

  void setTabIndex(int i) {
    _tabIndex.value = i;
  }

  void setCurrent0(int i) {
    _current0.value = i;
  }

  void setCurrent1(int i) {
    _current1.value = i;
  }

  bool get isLoading => _isLoading.value;

  List<VitalSignsData> get bpList => [..._bpList];
  List<VitalSignsData> get bmiList => [..._bmiList];
  List<VitalSignsData> get prList => [..._prList];
  List<VitalSignsData> get heightList => [..._heightList];
  List<VitalSignsData> get weightList => [..._weightList];

  List<LabData> get hdlList => [..._hdlList];
  List<LabData> get ldlList => [..._ldlList];
  List<LabData> get gluList => [..._gluList];
  List<LabData> get hmgList => [..._hmgList];

  int get tabIndex => _tabIndex.value;
  int get current0 => _current0.value;
  int get current1 => _current1.value;
}