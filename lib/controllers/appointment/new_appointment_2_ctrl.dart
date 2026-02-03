import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/marked_date.dart';
import 'package:flutter_calendar_carousel/classes/multiple_marked_dates.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

class NewAppointment2Ctrl extends GetxController {

  final _isLoading = false.obs;
  final _date = Rx<DateTime?>(null);
  final _xdate = Rx<DateTime?>(null);
  final _time = 'Select A Time'.obs;
  final _mx = Rx<MultipleMarkedDates?>(null);
  final _fulllist = <DoctorAppointmentStatus>[].obs;
  final _nalist = <DoctorAppointmentStatus>[].obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setDate(DateTime? dx) {
    _date.value = dx;
  }

  void setXDate(DateTime? dx) {
    _xdate.value = dx;
  }

  void setTime(String s) {
    _time.value = s;
  }

  void setMx() {
    List<MarkedDate> lx = [];
    for (int i = 0; i < fullList.length; i++) {
      lx.add(
        MarkedDate(
          color: const Color(0xFFFF5050),
          date: fullList[i].calendarDateDt,
          textStyle: kTextStyle1.copyWith(
            color: Colors.white,
          ),
        )
      );
    }

    for (int i = 0; i < naList.length; i++) {
      lx.add(
        MarkedDate(
          color: Colors.black45,
          date: naList[i].calendarDateDt,
          textStyle: kTextStyle1.copyWith(
            color: Colors.white,
          ),
        )
      );
    }

    if (lx.isEmpty) {
      _mx.value = null;
    }

    else {
      final mx = MultipleMarkedDates(markedDates: lx);
      _mx.value = mx;
    }
  }

  void setList(List<DoctorAppointmentStatus> lx, List<DoctorAppointmentStatus> ly) {
    _fulllist.clear();
    _nalist.clear();
    _fulllist.addAllIf(lx.isNotEmpty, lx);
    _nalist.addAllIf(ly.isNotEmpty, ly);
    setMx();
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
  String get time => _time.value;
  MultipleMarkedDates? get mx => _mx.value;
  List<DoctorAppointmentStatus> get fullList => [..._fulllist];
  List<DoctorAppointmentStatus> get naList => [..._nalist];
}