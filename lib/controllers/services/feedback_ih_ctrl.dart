import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackIHCtrl extends GetxController {

  final _isLoading = false.obs;
  final _val = 10.0.obs;
  final _valr = 10.0.obs;
  final _lxval = [5.0.obs, 5.0.obs, 5.0.obs, 5.0.obs, 5.0.obs];
  final _isViewMore = false.obs;
  final _opacityLevel = 0.0.obs;
  final _imageFile = Rx<File?>(null);
  final _lx = <Widget>[].obs;
  final _filesCount = 0.obs;

  List<ImageData> ld = [];

  void init(Widget w) {
    _lx.add(w);
  }

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setVal(double v) {
    _val.value = v;
  }

  void setValr(double v) {
    _valr.value = v;
  }

  void setValx(int i, double v) {
    _lxval[i].value = v;
  }

  void setViewMore(bool b) {
    _isViewMore.value = b;
  }

  void setOpacityLevel(double v) {
    _opacityLevel.value = v;
  }

  void setImageFile (File? f) {
    _imageFile.value = f;
  }

  void addWidget(Widget w) {
    _lx.add(w);
    setFilesCount();
  }

  void removeWidget(Key key) {
    _lx.removeWhere((x) => x.key == key);
    ld.removeWhere((x) => x.key == key);
    setFilesCount();
  }

  void setFilesCount() {
    _filesCount.value = _lx.length;
  }

  bool get isLoading => _isLoading.value;
  double get val => _val.value;
  double get valr => _valr.value;
  List<double> get lxval => [_lxval[0].value, _lxval[1].value, _lxval[2].value, _lxval[3].value, _lxval[4].value];
  bool get isViewMore => _isViewMore.value;
  double get opacityLevel => _opacityLevel.value;
  File? get imageFile => _imageFile.value;
  List<Widget> get lx => [..._lx];
  int get filesCount => _filesCount.value;
}

class ImageData {

  Key key;
  String path;
  String filename;

  ImageData({
    required this.key,
    required this.path,
    required this.filename,
  });
}