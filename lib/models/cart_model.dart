import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {

  int _cartItemCount = 0;

  void addCartItem(int n) {
    _cartItemCount += n;
    notifyListeners();
  }

  void removeCartItem() {
    _cartItemCount--;
    notifyListeners();
  }

  int get cartItemCount => _cartItemCount;
}