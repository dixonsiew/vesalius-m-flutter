import 'package:date_format/date_format.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

class RescheduleAppointmentCtrl extends GetxController {

  final _isLoading = false.obs;
  final _date = Rx<DateTime?>(null);
  final _xdate = Rx<DateTime?>(null);
  final _fulllist = <DoctorAppointmentStatus>[].obs;
  final _nalist = <DoctorAppointmentStatus>[].obs;
  final _docInfo = Rx<DoctorInfo?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setDate(DateTime? dx) {
    _date.value = dx;
  }

  void setXDate(DateTime? dx) {
    _xdate.value = dx;
  }

  void setOthers() {
    DateTime now = DateTime.now();
    DateTime a = DateTime(now.year, now.month, now.day, 12, 0);
    bool isAfterNoon = now.isAfter(a);
    if (isAfterNoon) {
      _nalist.add(DoctorAppointmentStatus(calendarDate: formatDate(now, [dd, '/', mm, '/', yyyy]), normalStatus: '', morningStatus: '', afternoonStatus: '', nightStatus: '', dailyStatus: ''));
    }
  }

  void setList(List<DoctorAppointmentStatus> lx, List<DoctorAppointmentStatus> ly) {
    _fulllist.clear();
    _nalist.clear();
    _fulllist.addAllIf(lx.isNotEmpty, lx);
    _nalist.addAllIf(ly.isNotEmpty, ly);
    setOthers();
  }

  void setDocInfo(DoctorInfo? o) {
    _docInfo.value = o;
  }

  String getDate() {
    String s = '';
    if (date == null) {
      return s;
    }

    return formatDate(date!, [dd, ' ', M, ' ', yyyy]);
  }

  bool get isLoading => _isLoading.value;
  DateTime? get date => _date.value;
  DateTime? get xdate => _xdate.value;
  // MultipleMarkedDates? get mx => _mx.value;
  List<DoctorAppointmentStatus> get fullList => [..._fulllist];
  List<DoctorAppointmentStatus> get naList => [..._nalist];
  DoctorInfo? get doctorInfo => _docInfo.value;
}