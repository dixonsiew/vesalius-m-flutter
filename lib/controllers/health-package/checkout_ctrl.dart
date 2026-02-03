import 'package:get/get.dart';

enum PaymentMethod { creditCard, fpx }

class CheckoutCtrl extends GetxController {

  final _paymentMethod = Rx<PaymentMethod?>(null);

  void setPaymentMethod(PaymentMethod? x) {
    _paymentMethod.value = x;
  }

  PaymentMethod? get paymentMethod => _paymentMethod.value;
}