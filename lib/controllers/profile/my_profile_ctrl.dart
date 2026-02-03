import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';

class MyProfileCtrl extends GetxController {

  final _isLoading = false.obs;
  final _user = Rx<UserDetails?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setUserDetails(UserDetails? o) {
    _user.value = o;
  }

  bool get isLoading => _isLoading.value;
  UserDetails? get user => _user.value;
}