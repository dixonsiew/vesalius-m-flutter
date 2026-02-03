class FutureOrder {

  String patientName;
  String prn;
  String planType;
  String performDate;
  String orderDoctor;
  String description;

  FutureOrder({
    required this.patientName,
    required this.prn,
    required this.planType,
    required this.performDate,
    required this.orderDoctor,
    required this.description,
  });

  factory FutureOrder.fromJson(Map<String, dynamic> json) {
    return FutureOrder(
      patientName: json['patientName'],
      prn: json['prn'],
      planType: json['planType'],
      performDate: json['performDate'],
      orderDoctor: json['orderDoctor'],
      description: json['description'],
    );
  }
}