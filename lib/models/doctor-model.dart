import 'package:flutter/material.dart';

class DoctorModel extends ChangeNotifier {

  bool _isbookmarkChanged = false;

  void setBookmarkChanged(bool b) {
    _isbookmarkChanged = b;
    notifyListeners();
  }

  bool get isbookmarkChanged => _isbookmarkChanged;
}