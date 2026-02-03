class Branch {

  num? branchId;
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

class UserBranch {

  num? adminId;
  String? prn;
  num? branchId;
  String? branchName;
  num? userId;
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

class UserDetails {

  String? address;
  String? dob;
  String? email;
  String? firstName;
  String? sex;
  String? lastName;
  num? userId;
  bool? firstTimeLogin;
  String? role;
  List<UserBranch>? userBranches;

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
    this.userBranches,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    final ls = json['userBranches'] as List;
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
      'userBranches': userBranches?.map((x) => x.toJson()).toList(),
    };
}
