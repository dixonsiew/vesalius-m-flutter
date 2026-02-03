import 'package:date_format/date_format.dart';

class KidsClub {

  int kidsClubId;
  String kidsClubTitle;
  String kidsClubDesc;
  String kidsClubImage;
  String? kidsClubTnc;
  String? kidsClubPartnerLink;

  KidsClub({
    required this.kidsClubId,
    required this.kidsClubTitle,
    required this.kidsClubDesc,
    required this.kidsClubImage,
    this.kidsClubTnc,
    this.kidsClubPartnerLink,
  });

  factory KidsClub.fromJson(Map<String, dynamic> json) {
    return KidsClub(
      kidsClubId: json['kids_club_id'],
      kidsClubTitle: json['kidsClubTitle'],
      kidsClubDesc: json['kidsClubDesc'],
      kidsClubImage: json['kidsClubImage'],
      kidsClubTnc: json['kidsClubTnc'],
      kidsClubPartnerLink: json['kidsClubPartnerLink'],
    );
  }
}

class MyKidsActivity {

  String kidsName;
  String kidsMembershipNumber;
  String kidsActivityName;
  String activityDateTime;

  MyKidsActivity({
    required this.kidsName,
    required this.kidsMembershipNumber,
    required this.kidsActivityName,
    required this.activityDateTime,
  });

  factory MyKidsActivity.fromJson(Map<String, dynamic> json) {
    return MyKidsActivity(
      kidsName: json['kidsName'], 
      kidsMembershipNumber: json['kidsMembershipNumber'], 
      kidsActivityName: json['kidsActivityName'], 
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

class KidsActivity {

  int kidsActivityId;
  String kidsActivityCode;
  String kidsActivityName;
  String kidsActivityDesc;
  String kidsActivityImage;
  String activityStartDateTime;
  String? activityEndDateTime;
  int activityMaxParticipant;
  String activityTnc;
  int activityDisplayOrder;
  int activityAttendees;
  int activitySeatsAvailable;
  String? activityEndDateTimeCalendar;

  KidsActivity({
    required this.kidsActivityId,
    required this.kidsActivityCode,
    required this.kidsActivityName,
    required this.kidsActivityDesc,
    required this.kidsActivityImage,
    required this.activityStartDateTime,
    required this.activityEndDateTime,
    required this.activityMaxParticipant,
    required this.activityTnc,
    required this.activityDisplayOrder,
    required this.activityAttendees,
    required this.activitySeatsAvailable,
    this.activityEndDateTimeCalendar,
  });

  factory KidsActivity.fromJson(Map<String, dynamic> json) {
    return KidsActivity(
      kidsActivityId: json['kids_activity_id'],
      kidsActivityCode: json['kidsActivityCode'],
      kidsActivityName: json['kidsActivityName'],
      kidsActivityDesc: json['kidsActivityDesc'],
      kidsActivityImage: json['kidsActivityImage'],
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

class KidsMembership {

  int kidsMembershipId;
  String kidsMembershipNumber;
  String kidsMembershipJoinDate;
  String? kidsPrn;
  String kidsName;
  String? kidsDob;
  String kidsDocType;
  String kidsDocNumber;
  String kidsGender;
  String kidsNationality;
  String? kidsEmail;
  String? guardianPrn;
  String guardianName;
  String guardianDocType;
  String guardianDocNumber;
  String guardianGender;
  String guardianNationality;
  String guardianEmail;
  String? guardianHomeContact;
  String? guardianMobileContact;
  String? guardianAddress1;
  String? guardianAddress2;
  String? guardianAddress3;
  String? guardianPostCode;
  String? guardianState;
  String? guardianCountryCode;
  String relationship;
  String preferredLanguage;
  String isActive;

  KidsMembership({
    required this.kidsMembershipId,
    required this.kidsMembershipNumber,
    required this.kidsMembershipJoinDate,
    this.kidsPrn,
    required this.kidsName,
    this.kidsDob,
    required this.kidsDocType,
    required this.kidsDocNumber,
    required this.kidsGender,
    required this.kidsNationality,
    this.kidsEmail,
    this.guardianPrn,
    required this.guardianName,
    required this.guardianDocType,
    required this.guardianDocNumber,
    required this.guardianGender,
    required this.guardianNationality,
    required this.guardianEmail,
    this.guardianHomeContact,
    this.guardianMobileContact,
    this.guardianAddress1,
    this.guardianAddress2,
    this.guardianAddress3,
    this.guardianPostCode,
    this.guardianState,
    this.guardianCountryCode,
    required this.relationship,
    required this.preferredLanguage,
    required this.isActive,
  });

  factory KidsMembership.fromJson(Map<String, dynamic> json) {
    return KidsMembership(
      kidsMembershipId: json['kids_membership_id'], 
      kidsMembershipNumber: json['kidsMembershipNumber'], 
      kidsMembershipJoinDate: json['kidsMembershipJoinDate'], 
      kidsPrn: json['kidsPrn'],
      kidsName: json['kidsName'], 
      kidsDob: json['kidsDob'],
      kidsDocType: json['kidsDocType'], 
      kidsDocNumber: json['kidsDocNumber'], 
      kidsGender: json['kidsGender'], 
      kidsNationality: json['kidsNationality'], 
      kidsEmail: json['kidsEmail'],
      guardianPrn: json['guardianPrn'],
      guardianName: json['guardianName'], 
      guardianDocType: json['guardianDocType'], 
      guardianDocNumber: json['guardianDocNumber'], 
      guardianGender: json['guardianGender'], 
      guardianNationality: json['guardianNationality'], 
      guardianEmail: json['guardianEmail'], 
      guardianHomeContact: json['guardianHomeContact'],
      guardianMobileContact: json['guardianMobileContact'],
      guardianAddress1: json['guardianAddress1'],
      guardianAddress2: json['guardianAddress2'],
      guardianAddress3: json['guardianAddress3'],
      guardianPostCode: json['guardianPostCode'],
      guardianState: json['guardianState'],
      guardianCountryCode: json['guardianCountryCode'],
      relationship: json['relationship'], 
      preferredLanguage: json['preferredLanguage'], 
      isActive: json['isActive'],
    );
  }

  DateTime get kidsDobDateTime {
    if (kidsDob != null) {
      DateTime dt = DateTime.parse(kidsDob!);
      return dt.toLocal();
    }

    return DateTime(1900, 1, 1);
  }

  String get kidsDobStr {
    return kidsDob ?? '-';
    //return formatDate(kidsDobDateTime, [dd, '/', mm, '/', yyyy]);
  }
}