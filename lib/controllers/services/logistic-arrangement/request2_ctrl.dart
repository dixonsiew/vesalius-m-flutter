import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/doctype_data.dart';

class Request2Ctrl extends GetxController {

  final _isValid = false.obs;
  final _selectedDocType = Rx<DocType?>(null);
  final _selectedRelationship = ''.obs;

  void setIsValid(bool b) {
    _isValid.value = b;
  }

  void setSelectedDocType(DocType? o) {
    _selectedDocType.value = o;
  }

  void setSelectedRelationship(String s) {
    _selectedRelationship.value = s;
  }

  bool get isValid => _isValid.value;
  DocType? get selectedDocType => _selectedDocType.value;
  String get selectedRelationship => _selectedRelationship.value;
}