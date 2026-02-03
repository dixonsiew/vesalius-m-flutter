class AppService {

  String name;
  String image;

  AppService({
    required this.name,
    required this.image,
  });

  factory AppService.fromJson(Map<String, dynamic> json) {
    return AppService(
      name: json['serviceName'],
      image: json['serviceImage'],
    );
  }

  bool get isConfig {
    final List<String> ls = ['DeleteAccount', 'PurchaseAndPayment'];
    return ls.contains(name) || image == '-';
  }
}