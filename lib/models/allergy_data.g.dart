// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allergy_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllergyAdapter extends TypeAdapter<Allergy> {
  @override
  final int typeId = 22;

  @override
  Allergy read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Allergy(
      alertRefNo: fields[0] as num?,
      prn: fields[1] as String?,
      alertType: fields[2] as String?,
      allergyType: fields[3] as String?,
      description: fields[4] as String?,
      reaction: fields[5] as String?,
      createdBy: fields[6] as String?,
      creationDate: fields[7] as String?,
      inactiveReason: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Allergy obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.alertRefNo)
      ..writeByte(1)
      ..write(obj.prn)
      ..writeByte(2)
      ..write(obj.alertType)
      ..writeByte(3)
      ..write(obj.allergyType)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.reaction)
      ..writeByte(6)
      ..write(obj.createdBy)
      ..writeByte(7)
      ..write(obj.creationDate)
      ..writeByte(8)
      ..write(obj.inactiveReason);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllergyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AllergyGroupAdapter extends TypeAdapter<AllergyGroup> {
  @override
  final int typeId = 23;

  @override
  AllergyGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllergyGroup(
      alertType: fields[0] as String?,
      list: (fields[1] as List).cast<Allergy>(),
    );
  }

  @override
  void write(BinaryWriter writer, AllergyGroup obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.alertType)
      ..writeByte(1)
      ..write(obj.list);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllergyGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
