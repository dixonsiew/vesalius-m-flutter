import 'package:date_format/date_format.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';

class TransportArrangementCtrl extends GetxController {

  final _isLoading = false.obs;
  final _date = Rx<DateTime?>(null);
  final _user = Rx<UserDetails?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setDate(DateTime? dx) {
    _date.value = dx;
  }

  void setUserDetails(UserDetails? o) {
    _user.value = o;
  }

  String get time {
    String s = 'Select Time';
    if (date == null) {
      return s;
    }

    return formatDate(date!, [h, ':', nn, ' ', am]);
  }

  bool get isLoading => _isLoading.value;
  DateTime? get date => _date.value;
  UserDetails? get user => _user.value;
}