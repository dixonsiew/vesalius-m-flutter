import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/way_finding_data.dart';
import 'package:vesalius_m_flutter/services/way_finding_service.dart';

class WayFindingCtrl extends GetxController {

  final _isLoading = false.obs;
  final _selectedFloor = ''.obs;
  final _selectedLocationFrom = Rx<Location?>(null);
  final _selectedLocationTo = Rx<Location?>(null);
  final _route = Rx<Route?>(null);
  final _list = <WayFinding>[].obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setSelectedFloor(String s) {
    _selectedFloor.value = s;
  }

  void setSelectedLocationFrom(Location? o) {
    _selectedLocationFrom.value = o;
  }

  void setSelectedLocationTo(Location? o) {
    _selectedLocationTo.value = o;
  }

  void setRoute(Route? o) {
    _route.value = o;
  }

  void setList(List<WayFinding> lx) {
    _list.clear();
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }

    if (_list.isNotEmpty) {
      setSelectedFloor(_list[lx.length - 1].floorCode);
    }
  }

  Future<void> loadRoute() async {
    if (selectedLocationFrom == null || selectedLocationTo == null) {
      return;
    }

    Route? x = await WayFindingService.getRoute(selectedLocationFrom!.locationId, selectedLocationTo!.locationId);
    setRoute(x);
    setSelectedFloor(selectedLocationFrom!.locationFloorCode);
  }

  bool get isLoading => _isLoading.value;
  String get selectedFloor => _selectedFloor.value;
  Location? get selectedLocationFrom => _selectedLocationFrom.value;
  Location? get selectedLocationTo => _selectedLocationTo.value;
  Route? get route => _route.value;
  List<WayFinding> get list => [..._list];
}