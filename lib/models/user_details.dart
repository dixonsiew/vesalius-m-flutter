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
  String? firstName;

  @HiveField(4)
  String? sex;

  @HiveField(5)
  String? lastName;

  @HiveField(6)
  num? userId;

  @HiveField(7)
  bool? firstTimeLogin;

  @HiveField(8)
  String? role;

  @HiveField(9)
  String? race;

  @HiveField(10)
  List<UserBranch> userBranches;

  UserDetails({
    this.address,
    this.dob,
    this.email,
    this.firstName,
    this.sex,
    this.lastName,
    this.userId,
    this.firstTimeLogin,
    this.role,
    this.race,
    this.userBranches = const[],
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    final ls = json['userBranches'] as List? ?? [];
    List<UserBranch> lx = ls.map((x) => UserBranch.fromJson(x)).toList();

    return UserDetails(
      address: json['address'],
      dob: json['dob'],
      email: json['email'],
      firstName: json['first_name'],
      sex: json['sex'],
      lastName: json['last_name'],
      userId: json['user_id'],
      firstTimeLogin: json['firstTimeLogin'],
      role: json['role'],
      race: json['race'],
      userBranches: lx,
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'address': address,
      'dob': dob,
      'email': email,
      'first_name': firstName,
      'sex': sex,
      'last_name': lastName,
      'user_id': userId,
      'firstTimeLogin': firstTimeLogin,
      'role': role,
      'race': race,
      'userBranches': userBranches.map((x) => x.toJson()).toList(),
    };
}
