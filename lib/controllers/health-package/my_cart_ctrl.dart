import 'package:get/get.dart';
import 'package:vesalius_m_flutter/models/cart_data.dart';
import 'package:vesalius_m_flutter/models/package_data.dart';

class MyCartCtrl extends GetxController {

  final _isLoading = false.obs;
  final _cartMap = Rx<Map<int, MyCartItem>>({});
  final _cartQuantity = 0.obs;
  final _cartTotalPrice = Rx<double>(0);
  final _cartList = <MyCartItem>[].obs;
  final _invalidPackages = Rx<Map<int, CartResult>>({});
  final _cartIsValid = false.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setInvalidPackages(List<CartResult> lx) {
    _invalidPackages.value.clear();
    if (lx.isNotEmpty) {
      _invalidPackages.value = { for (var x in lx) x.packageId : x };
    }
  }

  void setCartIsValid(bool b) {
    _cartIsValid.value = b;
  }

  void setTotal() {
    double totalPrice = 0;
    int totalQty = 0;
    for (int i = 0; i < _cartList.length; i++) {
      MyCartItem x = _cartList[i];
      double p = x.package.packagePrice * x.quantity;
      totalQty += x.quantity;
      totalPrice += p;
    }

    _cartQuantity.value = totalQty;
    _cartTotalPrice.value = totalPrice;
  }

  void setCartList(List<MyCartItem> lx) {
    double totalPrice = 0;
    int totalQty = 0;
    for (int i = 0; i < lx.length; i++) {
      MyCartItem x = lx[i];
      Package o = x.package;
      double p = o.packagePrice * x.quantity;
      totalQty += x.quantity;
      totalPrice += p;
      _cartList.add(x);
      _cartMap.value.update(o.packageId, (value) => x, ifAbsent: () => x);
    }

    _cartQuantity.value = totalQty;
    _cartTotalPrice.value = totalPrice;
  }

  MyCartItem? set(Package o, int qty) {
    MyCartItem? v;

    if (qty < 1) {
      return v;
    }

    if (_cartMap.value.containsKey(o.packageId)) {
      MyCartItem x = _cartMap.value[o.packageId]!;
      _cartQuantity.value -= x.quantity;
      x.quantity = qty;
      _cartQuantity.value += qty;
      _cartMap.value[o.packageId] = x;
      Map<int, MyCartItem> m = _cartMap.value;
      m[o.packageId] = x;
      m.update(o.packageId, (value) => _cartMap.value[o.packageId]!);
      _cartMap.value = m;
      v = x;
    }

    setTotal();
    return v;
  }

  MyCartItem? add(Package o, int qty) {
    MyCartItem? v;

    if (qty < 1) {
      return v;
    }

    if (_cartMap.value.containsKey(o.packageId)) {
      MyCartItem x = _cartMap.value[o.packageId]!;
      x.quantity = x.quantity + qty;
      _cartQuantity.value += qty;
      _cartMap.value[o.packageId] = x;
      Map<int, MyCartItem> m = _cartMap.value;
      m[o.packageId] = x;
      m.update(o.packageId, (value) => _cartMap.value[o.packageId]!);
      _cartMap.value = m;
      v = x;
    }

    else {
      MyCartItem x = MyCartItem(id: o.packageId, package: o, quantity: qty);
      _cartMap.value.update(o.packageId, (value) => x, ifAbsent: () => x);
      _cartQuantity.value += qty;
      _cartList.add(x);
      v = x;
    }

    setTotal();
    return v;
  }

  MyCartItem? remove(Package o) {
    MyCartItem? v;

    if (_cartMap.value.containsKey(o.packageId)) {
      MyCartItem x = _cartMap.value[o.packageId]!;
      if (x.quantity > 0) {
        x.quantity -= 1;
        _cartQuantity.value -= 1;
        _cartMap.value[o.packageId] = x;
        _cartMap.value.update(o.packageId, (value) => _cartMap.value[o.packageId]!);
        v = x;
        if (x.quantity == 0) {
          _cartMap.value.remove(o.packageId);
          _cartList.removeWhere((k) => k.package.packageId == o.packageId);
        }
      }

      setTotal();
    }
    
    return v;
  }

  void delete(MyCartItem o) {
    _cartMap.value.remove(o.package.packageId);
    _cartList.removeWhere((k) => k.package.packageId == o.package.packageId);
    setTotal();
  }

  void clear() {
    _cartMap.value.clear();
    _cartList.clear();
    setTotal();
  }

  bool get isLoading => _isLoading.value;
  Map<int, MyCartItem> get cartMap => _cartMap.value;
  int get cartQuantity => _cartQuantity.value;
  double get cartTotalPrice => _cartTotalPrice.value;
  List<MyCartItem> get cartList => [..._cartList];
  Map<int, CartResult> get invalidPackages => _invalidPackages.value;
  bool get cartIsValid => _cartIsValid.value;
}