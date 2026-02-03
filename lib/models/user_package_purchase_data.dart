import 'package:date_format/date_format.dart';

class UserPackagePurchase {

  int packageId;
  String packageStatus;
  String packagePurchaseNo;
  String packageName;
  String packageImage;
  String packageAllowAppt;
  String doctorMcr;
  String expiredDateTime;
  String purchasedDateTime;
  String billingFullname;
  String paymentTransDate;
  num paymentAmountCollected;
  String paymentGateway;
  String paymentRequestNo;
  String appointmentDateTime;
  String redeemedDateTime;
  String cancelledDateTime;

  UserPackagePurchase({
    required this.packageId,
    required this.packageStatus,
    required this.packagePurchaseNo,
    required this.packageName,
    required this.packageImage,
    required this.packageAllowAppt,
    required this.doctorMcr,
    required this.expiredDateTime,
    required this.purchasedDateTime,
    required this.billingFullname,
    required this.paymentTransDate,
    required this.paymentAmountCollected,
    required this.paymentGateway,
    required this.paymentRequestNo,
    required this.appointmentDateTime,
    required this.redeemedDateTime,
    required this.cancelledDateTime,
  });

  factory UserPackagePurchase.fromJson(Map<String, dynamic> json) {
    var mpaymentAmountCollected = json['paymentAmountCollected'] ?? '-';
    num paymentAmountCollected = 0;

    if (mpaymentAmountCollected != '-') {
      paymentAmountCollected = json['paymentAmountCollected'];
    }

    return UserPackagePurchase(
      packageId: json['package_id'],
      packageStatus: json['packageStatus'],
      packagePurchaseNo: json['packagePurchaseNo'],
      packageName: json['packageName'],
      packageImage: json['packageImage'],
      packageAllowAppt: json['packageAllowAppt'],
      doctorMcr: json['doctorMcr'],
      expiredDateTime: json['expiredDateTime'],
      purchasedDateTime: json['purchasedDateTime'] ?? '-',
      billingFullname: json['billingFullname'] ?? '-',
      paymentTransDate: json['paymentTransDate'] ?? '-',
      paymentAmountCollected: paymentAmountCollected,
      paymentGateway: json['paymentGateway'] ?? '-',
      paymentRequestNo: json['paymentRequestNo'] ?? '-',
      appointmentDateTime: json['appointmentDateTime'] ?? '-',
      redeemedDateTime: json['redeemedDateTime'] ?? '-',
      cancelledDateTime: json['cancelledDateTime'] ?? '-',
    );
  }

  DateTime? get expDateTime {
    if (expiredDateTime == '-') {
      return null;
    }

    DateTime dt = DateTime.parse(expiredDateTime);
    return dt.toLocal();
  }

  String get dateTime {
    if (expiredDateTime == '-') {
      return '-';
    }

    return formatDate(expDateTime!, [dd, ' ', MM, ' ', yyyy]);
  }

  String get dateTime1 {
    if (expiredDateTime == '-') {
      return '-';
    }

    return formatDate(expDateTime!, [dd, ' ', M, ' ', yyyy]);
  }

  DateTime? get purchasedDateTimedt {
    if (purchasedDateTime == '-') {
      return null;
    }

    DateTime dt = DateTime.parse(purchasedDateTime);
    return dt.toLocal();
  }

  String get purchasedDateTimes {
    if (purchasedDateTime == '-') {
      return '-';
    }

    return formatDate(purchasedDateTimedt!, [dd, ' ', M, ' ', yyyy]);
  }

  String get paymentAmountCollecteds {
    String s = '-';

    if (paymentAmountCollected > 0) {
      s = paymentAmountCollected.toStringAsFixed(2);
      s = 'RM $s';
    }

    return s;
  }

  String get appointmentDateTimes {
    if (appointmentDateTime == '-') {
      return '-';
    }

    DateTime? dt = DateTime.tryParse(appointmentDateTime);
    if (dt != null) {
      return formatDate(dt.toLocal(), [dd, ' ', M, ' ', yyyy, ' ', HH, ':', nn]);
    }
    
    return '-';
  }

  String get redeemedDateTimes {
    if (redeemedDateTime == '-') {
      return '-';
    }

    DateTime? dt = DateTime.tryParse(redeemedDateTime);
    if (dt != null) {
      return formatDate(dt.toLocal(), [dd, ' ', M, ' ', yyyy, ' ', HH, ':', nn]);
    }
    
    return '-';
  }

  String get cancelledDateTimes {
    if (cancelledDateTime == '-') {
      return '-';
    }

    DateTime? dt = DateTime.tryParse(cancelledDateTime);
    if (dt != null) {
      return formatDate(dt.toLocal(), [dd, ' ', M, ' ', yyyy, ' ', HH, ':', nn]);
    }
    
    return '-';
  }
}