import 'package:date_format/date_format.dart';

class NotificationX {

  int notificationId;
  int userId;
  String notificationTitle;
  String msgType;
  String shortMessage;
  String fullMessage;
  bool isSeen;
  String? dateCreates;
  String? visitType;
  String? accountNo;

  NotificationX({
    required this.notificationId,
    required this.userId,
    required this.notificationTitle,
    required this.msgType,
    required this.shortMessage,
    required this.fullMessage,
    required this.isSeen,
    this.dateCreates,
    this.visitType,
    this.accountNo,
  });

  factory NotificationX.fromJson(Map<String, dynamic> json) {
    return NotificationX(
      notificationId: json['notification_id'],
      userId: json['user_id'] ?? 0,
      notificationTitle: json['notificationTitle'],
      msgType: json['msgType'],
      shortMessage: json['shortMessage'],
      fullMessage: json['fullMessage'],
      isSeen: json['isSeen'],
      dateCreates: json['dateCreate'],
      visitType: json['visitType'],
      accountNo: json['accountNo'],
    );
  }

  DateTime get dateCreate {
    DateTime dx = DateTime(1900, 1, 1);
    if (dateCreates != null) {
      DateTime? dt = DateTime.tryParse(dateCreates!);
      return dt?.toLocal() ?? dx;
    }
    
    return dx;
  }

  String get dateCreateText {
    return isToday ? 'TODAY' : 'OLDER';
  }

  bool get isToday {
    DateTime dt = DateTime.now();
    return dt.day == dateCreate.day && dt.month == dateCreate.month && dt.year == dateCreate.year;
  }

  String get showTime {
    return isToday ? time : date;
  }

  String get time {
    return formatDate(dateCreate, [hh, ':', nn, ' ', am]);
  }

  String get date {
    return formatDate(dateCreate, [dd, ' ', M]).toUpperCase();
  }

  String get dateTime {
    String dt = formatDate(dateCreate, [dd, ' ', MM, ' ', yyyy]);
    return '$dt | $time';
  }
}