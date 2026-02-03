import 'package:hive/hive.dart';

part 'user_details.g.dart';

@HiveType(typeId: 3)
class Branch extends HiveObject {

  @HiveField(0)
  num? branchId;

  @HiveField(1)
  String? branchName;

  Branch({
    this.branchId,
    this.branchName,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      branchId: json['branchId'],
      branchName: json['branchName'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'branchId': branchId,
      'branchName': branchName,
    };
}

@HiveType(typeId: 2)
class UserBranch extends HiveObject {

  @HiveField(0)
  num? adminId;

  @HiveField(1)
  String? prn;

  @HiveField(2)
  num? branchId;

  @HiveField(3)
  String? branchName;

  @HiveField(4)
  num? userId;

  @HiveField(5)
  Branch? branch;

  UserBranch({
    this.adminId,
    this.prn,
    this.branchId,
    this.branchName,
    this.userId,
    this.branch,
  });

  factory UserBranch.fromJson(Map<String, dynamic> json) {
    return UserBranch(
      adminId: json['adminId'],
      prn: json['prn'],
      userId: json['userId'],
      branch: Branch.fromJson(json['branch']),
    );
  }

  factory UserBranch.fromJson1(Map<String, dynamic> json) {
    return UserBranch(
      adminId: 0,
      prn: '',
      branchId: json['branchId'],
      branchName: json['branchName'],
      userId: 0,
      branch: Branch(
        branchId: json['branchId'],
        branchName: json['branchName'],
      ),
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'adminId': adminId,
      'prn': prn,
      'branchId': branchId,
      'branchName': branchName,
      'userId': userId,
      'branch': branch == null ? { 'branchId': branchId, 'branchName': branchName } : branch!.toJson(),
    };
}

@HiveType(typeId: 1)
class UserDetails extends HiveObject {

  @HiveField(0)
  String? address;

  @HiveField(1)
  String? dob;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? title;

  @HiveField(4)
  String? firstName;

  @HiveField(5)
  String? middleName;

  @HiveField(6)
  String? lastName;

  @HiveField(7)
  String? sex;

  @HiveField(8)
  num? userId;

  @HiveField(9)
  bool? firstTimeLogin;

  @HiveField(10)
  String? role;

  @HiveField(11)
  String? race;

  @HiveField(12)
  String? contactNo;

  @HiveField(13)
  String? prn;

  @HiveField(14)
  String? nationality;

  @HiveField(15)
  List<UserBranch> userBranches;

  @HiveField(16)
  String? address1;

  @HiveField(17)
  String? address2;

  @HiveField(18)
  String? address3;

  @HiveField(19)
  String? cityState;

  @HiveField(20)
  String? postalCode;

  @HiveField(21)
  String? country;

  @HiveField(22)
  int signInType;

  UserDetails({
    this.address,
    this.dob,
    this.email,
    this.title,
    this.firstName,
    this.middleName,
    this.lastName,
    this.sex,
    this.userId,
    this.firstTimeLogin,
    this.role,
    this.race,
    this.contactNo,
    this.prn,
    this.nationality,
    this.address1,
    this.address2,
    this.address3,
    this.cityState,
    this.postalCode,
    this.country,
    this.signInType = 1,
    this.userBranches = const[],
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    final ls = json['userBranches'] as List? ?? [];
    List<UserBranch> lx = ls.map((x) => UserBranch.fromJson(x)).toList();

    return UserDetails(
      address: json['address'],
      dob: json['dob'],
      email: json['email'],
      title: json['title'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      sex: json['sex'],
      userId: json['user_id'],
      firstTimeLogin: json['firstTimeLogin'],
      role: json['role'],
      race: json['race'],
      contactNo: json['contactNumber'],
      prn: json['masterPrn'],
      nationality: json['nationality'],
      address1: json['address1'],
      address2: json['address2'],
      address3: json['address3'],
      cityState: json['cityState'],
      postalCode: json['postalCode'],
      country: json['country'],
      signInType: json['signInType'],
      userBranches: lx,
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'address': address,
      'dob': dob,
      'email': email,
      'title': title,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'sex': sex,
      'user_id': userId,
      'firstTimeLogin': firstTimeLogin,
      'role': role,
      'race': race,
      'contact_number': contactNo,
      'prn': prn,
      'nationality': nationality,
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'cityState': cityState,
      'postalCode': postalCode,
      'country': country,
      'signInType': signInType,
      'userBranches': userBranches.map((x) => x.toJson()).toList(),
    };
}
