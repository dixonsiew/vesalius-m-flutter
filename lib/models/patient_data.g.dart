// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactNumberAdapter extends TypeAdapter<ContactNumber> {
  @override
  final int typeId = 5;

  @override
  ContactNumber read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactNumber(
      home: fields[0] as String?,
      email: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ContactNumber obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.home)
      ..writeByte(1)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactNumberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AddressAdapter extends TypeAdapter<Address> {
  @override
  final int typeId = 6;

  @override
  Address read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Address(
      address1: fields[0] as String?,
      address2: fields[1] as String?,
      address3: fields[2] as String?,
      address4: fields[3] as String?,
      address5: fields[4] as String?,
      cityState: fields[5] as String?,
      postalCode: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Address obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.address1)
      ..writeByte(1)
      ..write(obj.address2)
      ..writeByte(2)
      ..write(obj.address3)
      ..writeByte(3)
      ..write(obj.address4)
      ..writeByte(4)
      ..write(obj.address5)
      ..writeByte(5)
      ..write(obj.cityState)
      ..writeByte(6)
      ..write(obj.postalCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NameAdapter extends TypeAdapter<Name> {
  @override
  final int typeId = 7;

  @override
  Name read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Name(
      firstName: fields[0] as String?,
      lastName: fields[1] as String?,
      middleName: fields[2] as String?,
      title: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Name obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.middleName)
      ..writeByte(3)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NationalityAdapter extends TypeAdapter<Nationality> {
  @override
  final int typeId = 8;

  @override
  Nationality read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Nationality(
      code: fields[0] as String?,
      description: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Nationality obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NationalityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SexAdapter extends TypeAdapter<Sex> {
  @override
  final int typeId = 9;

  @override
  Sex read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sex(
      code: fields[0] as String?,
      description: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Sex obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SexAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DocumentAdapter extends TypeAdapter<Document> {
  @override
  final int typeId = 10;

  @override
  Document read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Document(
      code: fields[0] as String?,
      description: fields[1] as String?,
      value: fields[2] as String?,
      expiryDate: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Document obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.value)
      ..writeByte(3)
      ..write(obj.expiryDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PatientDetailsAdapter extends TypeAdapter<PatientDetails> {
  @override
  final int typeId = 4;

  @override
  PatientDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PatientDetails(
      contactNumber: fields[0] as ContactNumber?,
      dob: fields[1] as String?,
      homeAddress: fields[2] as Address?,
      name: fields[3] as Name?,
      nationality: fields[4] as Nationality?,
      prn: fields[5] as String?,
      resident: fields[6] as String?,
      sex: fields[7] as Sex?,
      documents: (fields[8] as List).cast<Document>(),
    );
  }

  @override
  void write(BinaryWriter writer, PatientDetails obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.contactNumber)
      ..writeByte(1)
      ..write(obj.dob)
      ..writeByte(2)
      ..write(obj.homeAddress)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.nationality)
      ..writeByte(5)
      ..write(obj.prn)
      ..writeByte(6)
      ..write(obj.resident)
      ..writeByte(7)
      ..write(obj.sex)
      ..writeByte(8)
      ..write(obj.documents);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
