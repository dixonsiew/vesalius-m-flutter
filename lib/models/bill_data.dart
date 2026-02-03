import 'package:date_format/date_format.dart';

class Bill {

  String regDateTime;
  String billNumber;
  String invoiceNumber;
  String billInvoiceDateTime;
  String billAmount;
  String invoiceAmount;
  String outstandingAmount;

  Bill({
    required this.regDateTime,
    required this.billNumber,
    required this.invoiceNumber,
    required this.billInvoiceDateTime,
    required this.billAmount,
    required this.invoiceAmount,
    required this.outstandingAmount,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      regDateTime: json['regDateTime'],
      billNumber: json['billNumber'],
      invoiceNumber: json['invoiceNumber'],
      billInvoiceDateTime: json['billInvoiceDateTime'],
      billAmount: json['billAmount'],
      invoiceAmount: json['invoiceAmount'],
      outstandingAmount: json['outstandingAmount'],
    );
  }

  // "": "24-May-2022 17:44",
  //     "": "BL22-0000198",
  //     "": "IN22-0000219",
  //     "": "24-May-2022 17:46",
  //     "": "5,325.00",
  //     "": "5,325.00"
}

class OutstandingBill {

  String name;
  String prn;
  List<Bill> bills;

  OutstandingBill({
    required this.name,
    required this.prn,
    required this.bills,
  });

  factory OutstandingBill.fromJson(Map<String, dynamic> json) {
    final ls = json['bills'] as List? ?? [];
    List<Bill> lx = ls.map((x) => Bill.fromJson(x)).toList();

    return OutstandingBill(
      name: json['name'],
      prn: json['prn'],
      bills: lx,
    );
  }
}

class PaidBill {

  String patientPrn;
  String patientName;
  String patientDocNumber;
  String vesBillNumber;
  String vesInvoiceDateTime;
  String vesInvoiceAmount;
  String vesOutstandingAmount;
  String paymentGateway;
  String paymentRequestNo;
  String paymentAmountCollected;
  String? paymentTransDate;
  String billingFullname;
  String? vesPaymentReceiptNo;

  PaidBill({
    required this.patientPrn,
    required this.patientName,
    required this.patientDocNumber,
    required this.vesBillNumber,
    required this.vesInvoiceDateTime,
    required this.vesInvoiceAmount,
    required this.vesOutstandingAmount,
    required this.paymentGateway,
    required this.paymentRequestNo,
    required this.paymentAmountCollected,
    required this.paymentTransDate,
    required this.billingFullname,
    required this.vesPaymentReceiptNo,
  });

  factory PaidBill.fromJson(Map<String, dynamic> json) {
    return PaidBill(
      patientPrn: json['patientPrn'],
      patientName: json['patientName'],
      patientDocNumber: json['patientDocNumber'],
      vesBillNumber: json['vesBillNumber'],
      vesInvoiceDateTime: json['vesInvoiceDateTime'],
      vesInvoiceAmount: json['vesInvoiceAmount'],
      vesOutstandingAmount: json['vesOutstandingAmount'],
      paymentGateway: json['paymentGateway'],
      paymentRequestNo: json['paymentRequestNo'],
      paymentAmountCollected: json['paymentAmountCollected'],
      paymentTransDate: json['paymentTransDate'],
      billingFullname: json['billingFullname'],
      vesPaymentReceiptNo: json['vesPaymentReceiptNo'],
    );
  }

  String get vesInvoiceDateTimes {
    String s = vesInvoiceDateTime;
    final dt = DateTime.tryParse(vesInvoiceDateTime);
    if (dt != null) {
      s = formatDate(dt.toLocal(), [dd, '-', M, '-', yyyy, ' ', HH, ':', nn]);
    }

    return s;
  }

  String get paymentTransDates {
    String s = '';
    if (paymentTransDate != null) {
      final dt = DateTime.tryParse(paymentTransDate!);
      if (dt != null) {
        s = formatDate(dt.toLocal(), [dd, '-', M, '-', yyyy, ' ', HH, ':', nn]);
      }
    }

    return s;
  }
}