// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BranchAdapter extends TypeAdapter<Branch> {
  @override
  final int typeId = 3;

  @override
  Branch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Branch(
      branchId: fields[0] as num?,
      branchName: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Branch obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.branchId)
      ..writeByte(1)
      ..write(obj.branchName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BranchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserBranchAdapter extends TypeAdapter<UserBranch> {
  @override
  final int typeId = 2;

  @override
  UserBranch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserBranch(
      adminId: fields[0] as num?,
      prn: fields[1] as String?,
      branchId: fields[2] as num?,
      branchName: fields[3] as String?,
      userId: fields[4] as num?,
      branch: fields[5] as Branch?,
    );
  }

  @override
  void write(BinaryWriter writer, UserBranch obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.adminId)
      ..writeByte(1)
      ..write(obj.prn)
      ..writeByte(2)
      ..write(obj.branchId)
      ..writeByte(3)
      ..write(obj.branchName)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.branch);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserBranchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserDetailsAdapter extends TypeAdapter<UserDetails> {
  @override
  final int typeId = 1;

  @override
  UserDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDetails(
      address: fields[0] as String?,
      dob: fields[1] as String?,
      email: fields[2] as String?,
      firstName: fields[3] as String?,
      sex: fields[4] as String?,
      lastName: fields[5] as String?,
      userId: fields[6] as num?,
      firstTimeLogin: fields[7] as bool?,
      role: fields[8] as String?,
      userBranches: (fields[9] as List).cast<UserBranch>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserDetails obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.dob)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.firstName)
      ..writeByte(4)
      ..write(obj.sex)
      ..writeByte(5)
      ..write(obj.lastName)
      ..writeByte(6)
      ..write(obj.userId)
      ..writeByte(7)
      ..write(obj.firstTimeLogin)
      ..writeByte(8)
      ..write(obj.role)
      ..writeByte(9)
      ..write(obj.userBranches);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
