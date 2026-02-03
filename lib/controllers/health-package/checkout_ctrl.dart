import 'package:get/get.dart';

enum PaymentMethod { creditCard, fpx }

class CheckoutCtrl extends GetxController {

  final _isLoading = false.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  bool get isLoading => _isLoading.value;
}