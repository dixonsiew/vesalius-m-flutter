import 'package:date_format/date_format.dart';

class GoldenPearlClub {

  int goldenClubId;
  String goldenClubTitle;
  String goldenClubDesc;
  String goldenClubImage;
  String? goldenClubTnc;
  String? goldenClubPartnerLink;

  GoldenPearlClub({
    required this.goldenClubId,
    required this.goldenClubTitle,
    required this.goldenClubDesc,
    required this.goldenClubImage,
    this.goldenClubTnc,
    this.goldenClubPartnerLink,
  });

  factory GoldenPearlClub.fromJson(Map<String, dynamic> json) {
    return GoldenPearlClub(
      goldenClubId: json['golden_club_id'],
      goldenClubTitle: json['goldenClubTitle'],
      goldenClubDesc: json['goldenClubDesc'],
      goldenClubImage: json['goldenClubImage'],
      goldenClubTnc: json['goldenClubTnc'],
      goldenClubPartnerLink: json['goldenClubExtLink'],
    );
  }
}

class MyGoldenPearlActivity {

  String goldenName;
  String goldenMembershipNumber;
  String goldenActivityName;
  String activityDateTime;

  MyGoldenPearlActivity({
    required this.goldenName,
    required this.goldenMembershipNumber,
    required this.goldenActivityName,
    required this.activityDateTime,
  });

  factory MyGoldenPearlActivity.fromJson(Map<String, dynamic> json) {
    return MyGoldenPearlActivity(
      goldenName: json['goldenName'], 
      goldenMembershipNumber: json['goldenMembershipNumber'], 
      goldenActivityName: json['goldenActivityName'], 
      activityDateTime: json['activityDateTime'],
    );
  }

  String get actvityDates {
    String s = activityDateTime;
    DateTime? dt = DateTime.tryParse(activityDateTime);
    if (dt != null) {
      s = formatDate(dt.toLocal(), [dd, ' ', M, ' ', yyyy]);
    }

    return s;
  }
}

class GoldenPearlActivity {

  int goldenActivityId;
  String goldenActivityCode;
  String goldenActivityName;
  String goldenActivityDesc;
  String goldenActivityImage;
  String activityStartDateTime;
  String? activityEndDateTime;
  int activityMaxParticipant;
  String activityTnc;
  int activityDisplayOrder;
  int activityAttendees;
  int activitySeatsAvailable;
  String? activityEndDateTimeCalendar;

  GoldenPearlActivity({
    required this.goldenActivityId,
    required this.goldenActivityCode,
    required this.goldenActivityName,
    required this.goldenActivityDesc,
    required this.goldenActivityImage,
    required this.activityStartDateTime,
    required this.activityEndDateTime,
    required this.activityMaxParticipant,
    required this.activityTnc,
    required this.activityDisplayOrder,
    required this.activityAttendees,
    required this.activitySeatsAvailable,
    this.activityEndDateTimeCalendar,
  });

  factory GoldenPearlActivity.fromJson(Map<String, dynamic> json) {
    return GoldenPearlActivity(
      goldenActivityId: json['golden_activity_id'],
      goldenActivityCode: json['goldenActivityCode'],
      goldenActivityName: json['goldenActivityName'],
      goldenActivityDesc: json['goldenActivityDesc'],
      goldenActivityImage: json['goldenActivityImage'],
      activityStartDateTime: json['activityStartDateTime'],
      activityEndDateTime: json['activityEndDateTime'],
      activityMaxParticipant: json['activityMaxParticipant'],
      activityTnc: json['activityTnc'],
      activityDisplayOrder: json['activityDisplayOrder'],
      activityAttendees: json['activityAttendees'] ?? 0,
      activitySeatsAvailable: json['activitySeatsAvailable'] ?? 0,
      activityEndDateTimeCalendar: json['activityEndDateTimeCalendar'],
    );
  }

  DateTime getDateTime(String s) {
    DateTime dt = DateTime.parse(s);
    return dt.toLocal();
  }

  String getDate(String? s) {
    if (s == null || s == '-') {
      return s ?? '-';
    }

    DateTime dt = getDateTime(s);
    // if (dt.year == DateTime.now().year) {
    //   return formatDate(dt, [dd, ' ', M]);
    // }

    return formatDate(dt, [dd, ' ', M, ' ', yyyy]);
  }

  String get dateRange {
    String start = getDate(activityStartDateTime);
    String end = getDate(activityEndDateTime);
    String s = '$start - $end';
    if (end == '-') {
      s = start;
    }
    
    return s;
  }

  List<DateTime?> get datesMinMax {
    DateTime start = getDateTime(activityStartDateTime);
    DateTime? start2;
    String end = getDate(activityEndDateTime);
    if (start.isBefore(DateTime.now()) || formatDate(start, [dd, ' ', M, ' ', yyyy]) == formatDate(DateTime.now(), [dd, ' ', M, ' ', yyyy])) {
      final now = DateTime.now();
      start = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    }

    if (end == '-') {
      if (activityEndDateTimeCalendar != null) {
        start2 = getDateTime(activityEndDateTimeCalendar!);
      }
      
      return [start, start2];
    }

    DateTime ends = getDateTime(activityEndDateTime!);
    return [start, ends];
  } 

  List<DateTime> get dates {
    List<DateTime> lx = [];
    DateTime start = getDateTime(activityStartDateTime);
    String end = getDate(activityEndDateTime);
    if (end == '-') {
      return [start];
    }

    DateTime ends = getDateTime(activityEndDateTime!);
    lx.add(start);
    DateTime a = start.add(const Duration(days: 1));
    while (a.isBefore(ends)) {
      lx.add(a);
      a = a.add(const Duration(days: 1));
    }

    lx.add(ends);
    return lx;
  }
}

class GoldenPearlMembership {

  int goldenMembershipId;
  String goldenMembershipNumber;
  String goldenMembershipJoinDate;
  String? goldenPrn;
  String goldenName;
  String? goldenDob;
  String goldenDocType;
  String goldenDocNumber;
  String goldenGender;
  String goldenNationality;
  String? goldenEmail;
  String? nokPrn;
  String nokName;
  String nokDocType;
  String nokDocNumber;
  String nokGender;
  String nokNationality;
  String nokEmail;
  String? nokHomeContact;
  String? nokMobileContact;
  String? nokAddress1;
  String? nokAddress2;
  String? nokAddress3;
  String? nokPostCode;
  String? nokState;
  String? nokCountryCode;
  String relationship;
  String preferredLanguage;
  String isActive;

  GoldenPearlMembership({
    required this.goldenMembershipId,
    required this.goldenMembershipNumber,
    required this.goldenMembershipJoinDate,
    this.goldenPrn,
    required this.goldenName,
    this.goldenDob,
    required this.goldenDocType,
    required this.goldenDocNumber,
    required this.goldenGender,
    required this.goldenNationality,
    this.goldenEmail,
    this.nokPrn,
    required this.nokName,
    required this.nokDocType,
    required this.nokDocNumber,
    required this.nokGender,
    required this.nokNationality,
    required this.nokEmail,
    this.nokHomeContact,
    this.nokMobileContact,
    this.nokAddress1,
    this.nokAddress2,
    this.nokAddress3,
    this.nokPostCode,
    this.nokState,
    this.nokCountryCode,
    required this.relationship,
    required this.preferredLanguage,
    required this.isActive,
  });

  factory GoldenPearlMembership.fromJson(Map<String, dynamic> json) {
    return GoldenPearlMembership(
      goldenMembershipId: json['golden_membership_id'], 
      goldenMembershipNumber: json['goldenMembershipNumber'], 
      goldenMembershipJoinDate: json['goldenMembershipJoinDate'], 
      goldenPrn: json['goldenPrn'],
      goldenName: json['goldenName'], 
      goldenDob: json['goldenDob'],
      goldenDocType: json['goldenDocType'], 
      goldenDocNumber: json['goldenDocNumber'], 
      goldenGender: json['goldenGender'], 
      goldenNationality: json['goldenNationality'], 
      goldenEmail: json['goldenEmail'],
      nokPrn: json['nokPrn'],
      nokName: json['nokName'], 
      nokDocType: json['nokDocType'], 
      nokDocNumber: json['nokDocNumber'], 
      nokGender: json['nokGender'], 
      nokNationality: json['nokNationality'], 
      nokEmail: json['nokEmail'], 
      nokHomeContact: json['nokHomeContact'],
      nokMobileContact: json['nokMobileContact'],
      nokAddress1: json['nokAddress1'],
      nokAddress2: json['nokAddress2'],
      nokAddress3: json['nokAddress3'],
      nokPostCode: json['nokPostCode'],
      nokState: json['nokState'],
      nokCountryCode: json['nokCountryCode'],
      relationship: json['relationship'], 
      preferredLanguage: json['preferredLanguage'], 
      isActive: json['isActive'],
    );
  }

  DateTime get goldenDobDateTime {
    if (goldenDob != null) {
      DateTime dt = DateTime.parse(goldenDob!);
      return dt.toLocal();
    }

    return DateTime(1900, 1, 1);
  }

  String get goldenDobStr {
    return goldenDob ?? '-';
    //return formatDate(goldenDobDateTime, [dd, '/', mm, '/', yyyy]);
  }
}