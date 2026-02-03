import 'package:hive_flutter/hive_flutter.dart';

import 'package_data.dart';

part 'cart_data.g.dart';

// @HiveType(typeId: 19)
// class MyCartItemModel {
  
//   @HiveField(0)
//   String user = '';

//   @HiveField(1)
//   int pckId = 0;

//   @HiveField(2)
//   Package? package;

//   @HiveField(3)
//   int quantity = 0;

//   @Property(type: PropertyType.date) // Store as int in milliseconds
//   DateTime? date;

//   void set(String user, MyCartItem o) {
//     this.user = user;
//     pckId = o.package.packageId;
//     package = o.package;
//     quantity = o.quantity;
//     date = DateTime.now();
//   }
// }

@HiveType(typeId: 20)
class MyCartItem {

  @HiveField(0)
  int id;

  @HiveField(1)
  Package package;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  DateTime? date;

  MyCartItem({
    required this.id,
    required this.package,
    required this.quantity,
  });

  double get subtotal => package.packagePrice * quantity;
}

class CartResult {

  int packageId;
  int expired;
  int soldout;
  int exceedPurchase;
  int recommendedQuantity;

  CartResult({
    required this.packageId,
    required this.expired,
    required this.soldout,
    required this.exceedPurchase,
    required this.recommendedQuantity,
  });

  factory CartResult.fromJson(Map<String, dynamic> json) {
    return CartResult(
      packageId: json['package_id'],
      expired: json['expired'],
      soldout: json['soldout'],
      exceedPurchase: json['exceedPurchase'],
      recommendedQuantity: json['recommendedQuantity'],
    );
  }
}

class CartStatus {

  bool cartIsValid;
  List<CartResult> invalidPackages;

  CartStatus({
    required this.cartIsValid,
    this.invalidPackages = const[],
  });

  factory CartStatus.fromJson(Map<String, dynamic> json) {
    final ls = json['cartResult'] as List? ?? [];
    List<CartResult> lx = ls.map<CartResult>((x) => CartResult.fromJson(x)).toList();

    return CartStatus(
      cartIsValid: json['cartIsValid'],
      invalidPackages: lx,
    );
  }
}