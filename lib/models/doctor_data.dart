import 'package:hive/hive.dart';

part 'doctor_data.g.dart';

class Name {

  String? firstName;
  String? lastName;
  String? middleName;
  String? title;

  Name({
    this.firstName,
    this.lastName,
    this.middleName,
    this.title,
  });

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      firstName: json['firstName'],
      lastName: json['lastName'],
      middleName: json['middleName'],
      title: json['title']
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'title': title,
    };
}

class Gender {

  String? code;
  String? description;

  Gender({
    this.code,
    this.description,
  });

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(
      code: json['code'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'code': code,
      'description': description,
    };
}

class Address {

  String? address1;
  String? address2;
  String? address3;
  String? address4;
  String? address5;

  Address({
    this.address1,
    this.address2,
    this.address3,
    this.address4,
    this.address5,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address1: json['address1'],
      address2: json['address2'],
      address3: json['address3'],
      address4: json['address4'],
      address5: json['address5'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'address4': address4,
      'address5': address5,
    };
}

class Nationality {

  String? code;
  String? description;

  Nationality({
    this.code,
    this.description,
  });

  factory Nationality.fromJson(Map<String, dynamic> json) {
    return Nationality(
      code: json['code'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'code': code,
      'description': description,
    };
}

@HiveType(typeId: 19)
class Specialty {

  @HiveField(0)
  String? specialtyCode;

  @HiveField(1)
  String? specialtyDesc;

  Specialty({
    this.specialtyCode,
    this.specialtyDesc,
  });

  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      specialtyCode: json['specialtyCode'],
      specialtyDesc: json['specialtyDesc'],
    );
  }

  factory Specialty.fromJson1(Map<String, dynamic> json) {
    return Specialty(
      specialtyCode: json['specialtyCode'],
      specialtyDesc: json['specialtyDesc'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'specialtyCode': specialtyCode,
      'specialtyDesc': specialtyDesc,
    };
}

class AppImage {

  String? type;
  num? height;
  num? width;
  String? base64ImageData;

  AppImage({
    this.type,
    this.height,
    this.width,
    this.base64ImageData,
  });

  factory AppImage.fromJson(Map<String, dynamic> json) {
    return AppImage(
      type: json['type'],
      height: json['height'],
      width: json['width'],
      base64ImageData: json['base64ImageData'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'type': type,
      'height': height,
      'width': width,
      'base64ImageData': base64ImageData,
    };
}

@HiveType(typeId: 14)
class DoctorSpecialities extends HiveObject {

  @HiveField(0)
  int? doctorId;

  @HiveField(1)
  int? displaySequence;

  @HiveField(2)
  String? specialities;

  @HiveField(3)
  String? subspecialty;

  DoctorSpecialities({
    this.doctorId,
    this.displaySequence,
    this.specialities,
    this.subspecialty,
  });

  factory DoctorSpecialities.fromJson(Map<String, dynamic> json) {
    return DoctorSpecialities(
      doctorId: json['doctorId'],
      displaySequence: json['displaySequence'],
      specialities: json['specialities'],
      subspecialty: json['subspecialty'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'doctorId': doctorId,
      'displaySequence': displaySequence,
      'specialities': specialities,
      'subspecialty': subspecialty,
    };

  @override
  String toString() {
    String s = specialities ?? '';
    String ws = subspecialty ?? '';
    if (ws.isEmpty) {
      return s;
    }

    return '$s / $ws';
  }
}

@HiveType(typeId: 18)
class DoctorSpecialty extends HiveObject {

  @HiveField(0)
  int? doctorId;

  @HiveField(1)
  bool? primarySpecialty;

  @HiveField(2)
  Specialty? specialty;

  DoctorSpecialty({
    this.doctorId,
    this.primarySpecialty,
    this.specialty,
  });

  factory DoctorSpecialty.fromJson(Map<String, dynamic> json) {
    return DoctorSpecialty(
      doctorId: json['doctorId'],
      primarySpecialty: json['primarySpecialty'],
      specialty: Specialty.fromJson(json['specialty']),
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'doctorId': doctorId,
      'primarySpecialty': primarySpecialty,
      'specialty': specialty?.toJson(),
    };

  // factory DoctorSpecialty.fromObjectbox(DoctorSpecialtyModel o) {
  //   return DoctorSpecialty(
  //     doctorId: o.doctorId,
  //     primarySpecialty: o.primarySpecialty,
  //     specialty: o.specialty.target,
  //   );
  // }
}

@HiveType(typeId: 12)
class DoctorSpokenLanguage extends HiveObject {

  @HiveField(0)
  int? doctorId;

  @HiveField(1)
  int? displaySequence;

  @HiveField(2)
  String? spokenLanguage;

  DoctorSpokenLanguage({
    this.doctorId,
    this.displaySequence,
    this.spokenLanguage,
  });

  factory DoctorSpokenLanguage.fromJson(Map<String, dynamic> json) {
    return DoctorSpokenLanguage(
      doctorId: json['doctorId'],
      displaySequence: json['displaySequence'],
      spokenLanguage: json['spokenLanguage'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'doctorId': doctorId,
      'displaySequence': displaySequence,
      'spokenLanguage': spokenLanguage,
    };
}

@HiveType(typeId: 13)
class DoctorQualification extends HiveObject {

  @HiveField(0)
  int? doctorId;

  @HiveField(1)
  int? displaySequence;

  @HiveField(2)
  String? qualification;

  DoctorQualification({
    this.doctorId,
    this.displaySequence,
    this.qualification,
  });

  factory DoctorQualification.fromJson(Map<String, dynamic> json) {
    return DoctorQualification(
      doctorId: json['doctorId'],
      displaySequence: json['displaySequence'],
      qualification: json['qualification'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'doctorId': doctorId,
      'displaySequence': displaySequence,
      'qualification': qualification,
    };
}

@HiveType(typeId: 15)
class DoctorClinicLocation extends HiveObject {

  @HiveField(0)
  int? doctorId;

  @HiveField(1)
  String? location;

  @HiveField(2)
  String? building;

  DoctorClinicLocation({
    this.doctorId,
    this.location,
    this.building,
  });

  factory DoctorClinicLocation.fromJson(Map<String, dynamic> json) {
    return DoctorClinicLocation(
      doctorId: json['doctorId'],
      location: json['location'],
      building: json['building'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'doctorId': doctorId,
      'location': location,
      'building': building,
    };

  @override
  String toString() {
    String s = '';
    if (building == null) {
      s = location ?? '';
    }

    else {
      String loc = location ?? '';
      s = '$building\n$loc';
    }

    return s;
  }
}

@HiveType(typeId: 16)
class DoctorClinicHours extends HiveObject {

  @HiveField(0)
  int? doctorId;

  @HiveField(1)
  int? displaySequence;

  @HiveField(2)
  String? dayOfTheWeek;

  @HiveField(3)
  String? dayStartTime;

  @HiveField(4)
  String? dayEndTime;

  @HiveField(5)
  bool? byAppointmentOnly;

  DoctorClinicHours({
    this.doctorId,
    this.displaySequence,
    this.dayOfTheWeek,
    this.dayStartTime,
    this.dayEndTime,
    this.byAppointmentOnly,
  });

  factory DoctorClinicHours.fromJson(Map<String, dynamic> json) {
    return DoctorClinicHours(
      doctorId: json['doctorId'],
      displaySequence: json['displaySequence'],
      dayOfTheWeek: json['dayOfTheWeek'],
      dayStartTime: json['dayStartTime'],
      dayEndTime: json['dayEndTime'],
      byAppointmentOnly: json['byAppointmentOnly'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'doctorId': doctorId,
      'displaySequence': displaySequence,
      'dayOfTheWeek': dayOfTheWeek,
      'dayStartTime': dayStartTime,
      'dayEndTime': dayEndTime,
      'byAppointmentOnly': byAppointmentOnly,
    };
}

@HiveType(typeId: 17)
class DoctorContact extends HiveObject {

  @HiveField(0)
  int? doctorId;

  @HiveField(1)
  int? displaySequence;

  @HiveField(2)
  String? contactType;

  @HiveField(3)
  String? contactValue;

  DoctorContact({
    this.doctorId,
    this.displaySequence,
    this.contactType,
    this.contactValue,
  });

  factory DoctorContact.fromJson(Map<String, dynamic> json) {
    return DoctorContact(
      doctorId: json['doctorId'],
      displaySequence: json['displaySequence'],
      contactType: json['contactType'],
      contactValue: json['contactValue'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'doctorId': doctorId,
      'displaySequence': displaySequence,
      'contactType': contactType,
      'contactValue': contactValue,
    };
}

class DoctorAppointment {

  String apptDayOfWeek;
  String apptSlotType;
  String apptSessionType;
  String apptStartTime;
  String apptEndTime;

  DoctorAppointment({
    required this.apptDayOfWeek,
    required this.apptSlotType,
    required this.apptSessionType,
    required this.apptStartTime,
    required this.apptEndTime,
  });

  factory DoctorAppointment.fromJson(Map<String, dynamic> json) {
    return DoctorAppointment(
      apptDayOfWeek: json['apptDayOfWeek'],
      apptSlotType: json['apptSlotType'],
      apptSessionType: json['apptSessionType'],
      apptStartTime: json['apptStartTime'],
      apptEndTime: json['apptEndTime'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'apptDayOfWeek': apptDayOfWeek,
      'apptSlotType': apptSlotType,
      'apptSessionType': apptSessionType,
      'apptStartTime': apptStartTime,
      'apptEndTime': apptEndTime,
    };
}

// class DoctorInfoModel {

//   @Id()
//   int id = 0;
//   String user = '';
//   int doctorId = 0;
//   String? mcr;
//   String? name;
//   String? gender;
//   String? nationality;
//   String? image;
//   String? allowAppointment;
//   String? qualifications;
//   String? registrationNum;

//   final doctorSpokenLanguage = ToMany<DoctorSpokenLanguage>();

//   final doctorQualifications = ToMany<DoctorQualification>();

//   final doctorSpecialities = ToMany<DoctorSpecialities>();

//   final doctorClinicLocation = ToMany<DoctorClinicLocation>();

//   final doctorClinicHours = ToMany<DoctorClinicHours>();

//   final doctorContact = ToMany<DoctorContact>();

//   final doctorSpecialty = ToMany<DoctorSpecialtyModel>();

//   @Property(type: PropertyType.date) // Store as int in milliseconds
//   DateTime? date;

//   void set(String user, DoctorInfo o) {
//     this.user = user;
//     doctorId = o.doctorId;
//     mcr = o.mcr;
//     name = o.name;
//     gender = o.gender;
//     nationality = o.nationality;
//     image = o.image;
//     allowAppointment = o.allowAppointment;
//     qualifications = o.qualifications;
//     registrationNum = o.registrationNum;
//     doctorSpokenLanguage.addAll(o.doctorSpokenLanguage);
//     doctorQualifications.addAll(o.doctorQualifications);
//     doctorSpecialities.addAll(o.doctorSpecialities);
//     doctorClinicLocation.addAll(o.doctorClinicLocation);
//     doctorClinicHours.addAll(o.doctorClinicHours);
//     doctorContact.addAll(o.doctorContact);
//     doctorSpecialty.addAll(o.doctorSpecialty.map((x) => DoctorSpecialtyModel()..target = x).toList());
//     date = DateTime.now();
//   }
// }

@HiveType(typeId: 11)
class DoctorInfo extends HiveObject {

  @HiveField(0)
  int doctorId;

  @HiveField(1)
  String? mcr;

  @HiveField(2)
  String? name;

  @HiveField(3)
  String? gender;

  @HiveField(4)
  String? nationality;

  @HiveField(5)
  String? image;

  @HiveField(17)
  String? showMakeAppointmentButton;

  @HiveField(6)
  String? allowAppointment;

  @HiveField(7)
  String? qualifications;

  @HiveField(8)
  String? registrationNum;

  @HiveField(9)
  List<DoctorSpokenLanguage> doctorSpokenLanguage;

  @HiveField(10)
  List<DoctorQualification> doctorQualifications;

  @HiveField(11)
  List<DoctorSpecialities> doctorSpecialities;

  @HiveField(12)
  List<DoctorClinicLocation> doctorClinicLocation;

  @HiveField(13)
  List<DoctorClinicHours> doctorClinicHours;

  @HiveField(14)
  List<DoctorContact> doctorContact;

  @HiveField(15)
  List<DoctorSpecialty> doctorSpecialty;

  @HiveField(16)
  DateTime? date;

  DoctorInfo({
    this.doctorId = 0,
    this.mcr,
    this.name,
    this.gender,
    this.nationality,
    this.image,
    this.showMakeAppointmentButton,
    this.allowAppointment,
    this.qualifications,
    this.registrationNum,
    this.doctorSpokenLanguage = const[],
    this.doctorQualifications = const[],
    this.doctorSpecialities = const[],
    this.doctorClinicLocation = const[],
    this.doctorClinicHours = const[],
    this.doctorContact = const[],
    this.doctorSpecialty = const[],
  });

  factory DoctorInfo.fromJson(Map<String, dynamic> json) {
    final ls = json['doctorSpecialities'] as List? ?? [];
    List<DoctorSpecialities> lx = ls.map<DoctorSpecialities>((x) => DoctorSpecialities.fromJson(x)).toList();

    final lm = json['doctorSpecialty'] as List? ?? [];
    List<DoctorSpecialty> la = lm.map<DoctorSpecialty>((x) => DoctorSpecialty.fromJson(x)).toList();

    final ln = json['doctorSpokenLanguage'] as List? ?? [];
    List<DoctorSpokenLanguage> lb = ln.map<DoctorSpokenLanguage>((x) => DoctorSpokenLanguage.fromJson(x)).toList();

    final lo = json['doctorQualifications'] as List? ?? [];
    List<DoctorQualification> lc = lo.map<DoctorQualification>((x) => DoctorQualification.fromJson(x)).toList();

    final lp = json['doctorClinicLocation'] as List? ?? [];
    List<DoctorClinicLocation> ld = lp.map<DoctorClinicLocation>((x) => DoctorClinicLocation.fromJson(x)).toList();

    final lq = json['doctorClinicHours'] as List? ?? [];
    List<DoctorClinicHours> le = lq.map<DoctorClinicHours>((x) => DoctorClinicHours.fromJson(x)).toList();

    final lr = json['doctorContact'] as List? ?? [];
    List<DoctorContact> lf = lr.map<DoctorContact>((x) => DoctorContact.fromJson(x)).toList();

    return DoctorInfo(
      doctorId: json['doctor_id'],
      mcr: json['mcr'],
      name: json['name'],
      gender: json['gender'],
      nationality: json['nationality'],
      image: json['image'],
      showMakeAppointmentButton: json['showMakeAppointmentButton'],
      allowAppointment: json['allowAppointment'],
      qualifications: json['qualifications'],
      registrationNum: json['registrationNum'],
      doctorSpokenLanguage: lb,
      doctorQualifications: lc,
      doctorSpecialities: lx,
      doctorClinicLocation: ld,
      doctorClinicHours: le,
      doctorContact: lf,
      doctorSpecialty: la,
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'doctorId': doctorId,
      'mcr': mcr,
      'name': name,
      'gender': gender,
      'nationality': nationality,
      'image': image,
      'showMakeAppointmentButton': showMakeAppointmentButton,
      'allowAppointment': allowAppointment,
      'qualifications': qualifications,
      'registrationNum': registrationNum,
      'doctorSpokenLanguage': doctorSpokenLanguage.map((x) => x.toJson()).toList(),
      'doctorQualifications': doctorQualifications.map((x) => x.toJson()).toList(),
      'doctorSpecialities': doctorSpecialities.map((x) => x.toJson()).toList(),
      'doctorClinicLocation': doctorClinicLocation.map((x) => x.toJson()).toList(),
      'doctorClinicHours': doctorClinicHours.map((x) => x.toJson()).toList(),
      'doctorContact': doctorContact.map((x) => x.toJson()).toList(),
      'doctorSpecialty': doctorSpecialty.map((x) => x.toJson()).toList(),
    };

  // factory DoctorInfo.fromObjectbox(DoctorInfoModel o) {
  //   return DoctorInfo(
  //     doctorId: o.doctorId,
  //     mcr: o.mcr,
  //     name: o.name,
  //     gender: o.gender,
  //     nationality: o.nationality,
  //     image: o.image,
  //     allowAppointment: o.allowAppointment,
  //     qualifications: o.qualifications,
  //     registrationNum: o.registrationNum,
  //     doctorSpokenLanguage: o.doctorSpokenLanguage,
  //     doctorQualifications: o.doctorQualifications,
  //     doctorSpecialities: o.doctorSpecialities,
  //     doctorClinicLocation: o.doctorClinicLocation,
  //     doctorClinicHours: o.doctorClinicHours,
  //     doctorContact: o.doctorContact,
  //     doctorSpecialty: o.doctorSpecialty.map((x) => DoctorSpecialty.fromObjectbox(x)).toList(),
  //   );
  // }
}

class DoctorDetails {

  String? mcr;
  String? shortName;
  String? grade;
  String? dob;
  String? contact;
  Name? name;
  Gender? gender;
  Address? address;
  Nationality? nationality;
  List<Specialty>? specialtyList;
  AppImage? image;
  List<String>? qualification;

  DoctorDetails({
    this.mcr,
    this.shortName,
    this.grade,
    this.dob,
    this.contact,
    this.name,
    this.gender,
    this.address,
    this.nationality,
    this.specialtyList,
    this.image,
    this.qualification,
  });

  factory DoctorDetails.fromJson(Map<String, dynamic> json) {
    final ls = json['specialtyList'] as List? ?? [];
    List<Specialty> lx = ls.map<Specialty>((x) => Specialty.fromJson(x)).toList();

    final lq = json['qualification'] as List? ?? [];
    List<String> la = lq.map<String>((x) => x).toList();

    return DoctorDetails(
      mcr: json['mcr'],
      shortName: json['shortName'],
      grade: json['grade'],
      dob: json['dob'],
      contact: json['contact'],
      name: Name.fromJson(json['name']),
      gender: Gender.fromJson(json['gender']),
      address: Address.fromJson(json['address']),
      nationality: Nationality.fromJson(json['nationality']),
      specialtyList: lx,
      image: AppImage.fromJson(json['image']),
      qualification: la,
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'mcr': mcr,
      'shortName': shortName,
      'grade': grade,
      'dob': dob,
      'contact': contact,
      'name': name?.toJson(),
      'gender': gender?.toJson(),
      'address': address?.toJson(),
      'nationality': nationality?.toJson(),
      'specialtyList': specialtyList?.map((x) => x.toJson()).toList(),
      'image': image?.toJson(),
      'qualification': qualification?.map((x) => x).toList(),
    };
}

class DoctorAppointmentStatus {

  String calendarDate;
  String normalStatus;
  String morningStatus;
  String afternoonStatus;
  String nightStatus;
  String dailyStatus;

  DoctorAppointmentStatus({
    required this.calendarDate,
    required this.normalStatus,
    required this.morningStatus,
    required this.afternoonStatus,
    required this.nightStatus,
    required this.dailyStatus,
  });

  factory DoctorAppointmentStatus.fromJson(Map<String, dynamic> json) {
    return DoctorAppointmentStatus(
      calendarDate: json['calendarDate'],
      normalStatus: json['normalStatus'],
      morningStatus: json['morningStatus'],
      afternoonStatus: json['afternoonStatus'],
      nightStatus: json['nightStatus'],
      dailyStatus: json['dailyStatus'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'calendarDate': calendarDate,
      'normalStatus': normalStatus,
      'morningStatus': morningStatus,
      'afternoonStatus': afternoonStatus,
      'nightStatus': nightStatus,
      'dailyStatus': dailyStatus,
    };

  DateTime get calendarDateDt {
    final s = calendarDate.split('/');
    String d = '${s[2]}-${s[1]}-${s[0]}';
    DateTime dt = DateTime.parse(d);
    return dt;
  }
}

class PatientRef {

  int id;
  String first;
  String name;
  String type;

  PatientRef({
    required this.id,
    required this.first,
    required this.name,
    required this.type,
  });
}