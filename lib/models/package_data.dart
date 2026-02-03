import 'package:hive/hive.dart';

part 'package_data.g.dart';

@HiveType(typeId: 21)
class Package {

  @HiveField(0)
  int packageId;

  @HiveField(1)
  String packageCode;

  @HiveField(2)
  String packageName;

  @HiveField(3)
  String packageDesc;

  @HiveField(4)
  String packageImage;

  @HiveField(5)
  String packageStartDateTime;

  @HiveField(6)
  String? packageEndDateTime;

  @HiveField(7)
  int packageValidity;

  @HiveField(8)
  String? packageTnc;

  @HiveField(9)
  double packagePrice;

  @HiveField(10)
  int packageMaxPurchase;

  @HiveField(11)
  int packageAssignedDoctor;

  @HiveField(12)
  String packageAllowAppt;

  @HiveField(13)
  String? packageExtLink;

  @HiveField(14)
  int availableToPurchase = 0;

  Package({
    required this.packageId,
    required this.packageCode,
    required this.packageName,
    required this.packageDesc,
    required this.packageImage,
    required this.packageStartDateTime,
    required this.packageEndDateTime,
    required this.packageValidity,
    this.packageTnc,
    required this.packagePrice,
    required this.packageMaxPurchase,
    required this.packageAssignedDoctor,
    required this.packageAllowAppt,
    this.packageExtLink,
    this.availableToPurchase = 0,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    num price = json['packagePrice'] ?? 0.00;
    return Package(
      packageId: json['package_id'],
      packageCode: json['packageCode'],
      packageName: json['packageName'],
      packageDesc: json['packageDesc'],
      packageImage: json['packageImage'],
      packageStartDateTime: json['packageStartDateTime'],
      packageEndDateTime: json['packageEndDateTime'],
      packageValidity: json['packageValidity'],
      packageTnc: json['packageTnc'],
      packagePrice: price.toDouble(),
      packageMaxPurchase: json['packageMaxPurchase'],
      packageAssignedDoctor: json['packageAssignedDoctor'],
      packageAllowAppt: json['packageAllowAppt'],
      packageExtLink: json['packageExtLink'],
    );
  }
}

class PackageStatus {

  int expired;
  int soldout;
  int availableToPurchase;

  PackageStatus({
    required this.expired,
    required this.soldout,
    required this.availableToPurchase,
  });

  factory PackageStatus.fromJson(Map<String, dynamic> json) {
    return PackageStatus(
      expired: json['expired'],
      soldout: json['soldout'],
      availableToPurchase: json['availableToPurchase'],
    );
  }
}