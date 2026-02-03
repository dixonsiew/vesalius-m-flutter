// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PackageAdapter extends TypeAdapter<Package> {
  @override
  final int typeId = 21;

  @override
  Package read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Package(
      packageId: fields[0] as int,
      packageCode: fields[1] as String,
      packageName: fields[2] as String,
      packageDesc: fields[3] as String,
      packageImage: fields[4] as String,
      packageStartDateTime: fields[5] as String,
      packageEndDateTime: fields[6] as String?,
      packageValidity: fields[7] as int,
      packageTnc: fields[8] as String?,
      packagePrice: fields[9] as double,
      packageMaxPurchase: fields[10] as int,
      packageAssignedDoctor: fields[11] as int,
      packageAllowAppt: fields[12] as String,
      packageExtLink: fields[13] as String?,
      availableToPurchase: fields[14] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Package obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.packageId)
      ..writeByte(1)
      ..write(obj.packageCode)
      ..writeByte(2)
      ..write(obj.packageName)
      ..writeByte(3)
      ..write(obj.packageDesc)
      ..writeByte(4)
      ..write(obj.packageImage)
      ..writeByte(5)
      ..write(obj.packageStartDateTime)
      ..writeByte(6)
      ..write(obj.packageEndDateTime)
      ..writeByte(7)
      ..write(obj.packageValidity)
      ..writeByte(8)
      ..write(obj.packageTnc)
      ..writeByte(9)
      ..write(obj.packagePrice)
      ..writeByte(10)
      ..write(obj.packageMaxPurchase)
      ..writeByte(11)
      ..write(obj.packageAssignedDoctor)
      ..writeByte(12)
      ..write(obj.packageAllowAppt)
      ..writeByte(13)
      ..write(obj.packageExtLink)
      ..writeByte(14)
      ..write(obj.availableToPurchase);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PackageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
