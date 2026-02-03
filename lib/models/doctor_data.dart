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

class Specialty {

  String? specialtyCode;
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

class DoctorSpecialities {

  num? doctorId;
  num? displaySequence;
  String? specialities;

  DoctorSpecialities({
    this.doctorId,
    this.displaySequence,
    this.specialities,
  });

  factory DoctorSpecialities.fromJson(Map<String, dynamic> json) {
    return DoctorSpecialities(
      doctorId: json['doctorId'],
      displaySequence: json['displaySequence'],
      specialities: json['specialities'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'doctorId': doctorId,
      'displaySequence': displaySequence,
      'specialities': specialities,
    };
}

class DoctorSpecialty {

  num? doctorId;
  Specialty? specialty;
  bool? primarySpecialty;

  DoctorSpecialty({
    this.doctorId,
    this.specialty,
    this.primarySpecialty,
  });

  factory DoctorSpecialty.fromJson(Map<String, dynamic> json) {
    return DoctorSpecialty(
      doctorId: json['doctorId'],
      specialty: Specialty.fromJson(json['specialty']),
      primarySpecialty: json['primarySpecialty'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'doctorId': doctorId,
      'specialty': specialty?.toJson(),
      'primarySpecialty': primarySpecialty,
    };
}

class DoctorSpokenLanguage {

  num? doctorId;
  num? displaySequence;
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

class DoctorQualification {

  num? doctorId;
  num? displaySequence;
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

class DoctorClinicLocation {

  num? doctorId;
  String? location;

  DoctorClinicLocation({
    this.doctorId,
    this.location,
  });

  factory DoctorClinicLocation.fromJson(Map<String, dynamic> json) {
    return DoctorClinicLocation(
      doctorId: json['doctorId'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'doctorId': doctorId,
      'location': location,
    };
}

class DoctorClinicHours {

  num? doctorId;
  num? displaySequence;
  String? dayOfTheWeek;
  String? dayStartTime;
  String? dayEndTime;
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

class DoctorContact {

  num? doctorId;
  num? displaySequence;
  String? contactType;
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

class DoctorInfo {

  String? mcr;
  String? name;
  String? gender;
  String? nationality;
  String? image;
  List<DoctorSpokenLanguage>? doctorSpokenLanguage;
  List<DoctorQualification>? doctorQualifications;
  List<DoctorSpecialities>? doctorSpecialities;
  List<DoctorClinicLocation>? doctorClinicLocation;
  List<DoctorClinicHours>? doctorClinicHours;
  List<DoctorContact>? doctorContact;
  List<DoctorSpecialty>? doctorSpecialty;

  DoctorInfo({
    this.mcr,
    this.name,
    this.gender,
    this.nationality,
    this.image,
    this.doctorSpokenLanguage,
    this.doctorQualifications,
    this.doctorSpecialities,
    this.doctorClinicLocation,
    this.doctorClinicHours,
    this.doctorContact,
    this.doctorSpecialty,
  });

  factory DoctorInfo.fromJson(Map<String, dynamic> json) {
    var ls = json['doctorSpecialities'] as List?;
    List<DoctorSpecialities> lx = ls == null ? [] : ls.map<DoctorSpecialities>((x) => DoctorSpecialities.fromJson(x)).toList();

    var lm = json['doctorSpecialty'] as List?;
    List<DoctorSpecialty> la = lm == null ? [] : lm.map<DoctorSpecialty>((x) => DoctorSpecialty.fromJson(x)).toList();

    var ln = json['doctorSpokenLanguage'] as List?;
    List<DoctorSpokenLanguage> lb = ln == null ? [] : ln.map<DoctorSpokenLanguage>((x) => DoctorSpokenLanguage.fromJson(x)).toList();

    var lo = json['doctorQualifications'] as List?;
    List<DoctorQualification> lc = lo == null ? [] : lo.map<DoctorQualification>((x) => DoctorQualification.fromJson(x)).toList();

    var lp = json['doctorClinicLocation'] as List?;
    List<DoctorClinicLocation> ld = lp == null ? [] : lp.map<DoctorClinicLocation>((x) => DoctorClinicLocation.fromJson(x)).toList();

    var lq = json['doctorClinicHours'] as List?;
    List<DoctorClinicHours> le = lq == null ? [] : lq.map<DoctorClinicHours>((x) => DoctorClinicHours.fromJson(x)).toList();

    var lr = json['doctorContact'] as List?;
    List<DoctorContact> lf = lr == null ? [] : lr.map<DoctorContact>((x) => DoctorContact.fromJson(x)).toList();

    return DoctorInfo(
      mcr: json['mcr'],
      name: json['name'],
      gender: json['gender'],
      nationality: json['nationality'],
      image: json['image'],
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
      'mcr': mcr,
      'name': name,
      'gender': gender,
      'nationality': nationality,
      'image': image,
      'doctorSpokenLanguage': doctorSpokenLanguage?.map((x) => x.toJson()).toList(),
      'doctorQualifications': doctorQualifications?.map((x) => x.toJson()).toList(),
      'doctorSpecialities': doctorSpecialities?.map((x) => x.toJson()).toList(),
      'doctorClinicLocation': doctorClinicLocation?.map((x) => x.toJson()).toList(),
      'doctorClinicHours': doctorClinicHours?.map((x) => x.toJson()).toList(),
      'doctorContact': doctorContact?.map((x) => x.toJson()).toList(),
      'doctorSpecialty': doctorSpecialty?.map((x) => x.toJson()).toList(),
    };
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
    var ls = json['specialtyList'] as List?;
    List<Specialty> lx = ls == null ? [] : ls.map<Specialty>((x) => Specialty.fromJson(x)).toList();

    var lq = json['qualification'] as List?;
    List<String> la = lq == null ? [] : lq.map<String>((x) => x).toList();

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