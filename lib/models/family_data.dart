class Family {

  int aufId;
  int userId;
  int nokRefNum;
  bool isPatient;
  String fullname;
  String? relationship;
  String? prn;
  String? nricPassport;
  String? docNum;
  String? dob;
  String? gender;
  String? nationality;
  String? contact;
  String? address;
  bool isActive;
  String? maritalStatus;
  String? email;
  bool isKidsExplorer;
  bool isGoldenPearl;

  Family({
    required this.aufId,
    required this.userId,
    required this.nokRefNum,
    required this.isPatient,
    required this.fullname,
    this.relationship,
    this.prn,
    this.nricPassport,
    this.docNum,
    this.dob,
    this.gender,
    this.nationality,
    this.contact,
    this.address,
    this.isActive = false,
    this.maritalStatus,
    this.email,
    required this.isKidsExplorer,
    required this.isGoldenPearl,
  });

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      aufId: json['auf_id'],
      userId: json['user_id'],
      nokRefNum: json['nokRefNumber'],
      isPatient: json['isPatient'],
      fullname: json['fullName'],
      relationship: json['relationship'],
      prn: json['prn'],
      nricPassport: json['nricPassport'],
      docNum: json['docNumber'],
      dob: json['dob'],
      gender: json['gender'],
      nationality: json['nationality'],
      contact: json['contactNumber'],
      address: json['address'],
      isActive: json['isActive'] ?? false,
      maritalStatus: json['maritalStatus'],
      email: json['email'],
      isKidsExplorer: json['isKidsExplorer'] ?? false,
      isGoldenPearl: json['isGoldenPearl'] ?? false,
    );
  }
}