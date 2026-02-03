import 'package:date_format/date_format.dart';

class WallexRes {

  String expiredAt;
  String paymentUrl;

  WallexRes({
    required this.expiredAt,
    required this.paymentUrl,
  });

  factory WallexRes.fromJson(Map<String, dynamic> json) {
    return WallexRes(
      expiredAt: json['expiredAt'],
      paymentUrl: json['paymentUrl'],
    );
  }

  String get expDateTime {
    // 2023-08-23T08:40:43Z
    String s = '';
    DateTime? dt = DateTime.tryParse(expiredAt);
    if (dt != null) {
      s = formatDate(dt.toLocal(), [dd, ' ', M, ' ', yyyy, ' ', hh, ':', nn, ' ', am, ' ', z]);
    }

    return s;
  }
}