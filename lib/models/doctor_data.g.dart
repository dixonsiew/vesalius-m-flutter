// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpecialtyAdapter extends TypeAdapter<Specialty> {
  @override
  final int typeId = 19;

  @override
  Specialty read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Specialty(
      specialtyCode: fields[0] as String?,
      specialtyDesc: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Specialty obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.specialtyCode)
      ..writeByte(1)
      ..write(obj.specialtyDesc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpecialtyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DoctorSpecialitiesAdapter extends TypeAdapter<DoctorSpecialities> {
  @override
  final int typeId = 14;

  @override
  DoctorSpecialities read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorSpecialities(
      doctorId: fields[0] as int?,
      displaySequence: fields[1] as int?,
      specialities: fields[2] as String?,
      subspecialty: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DoctorSpecialities obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.doctorId)
      ..writeByte(1)
      ..write(obj.displaySequence)
      ..writeByte(2)
      ..write(obj.specialities)
      ..writeByte(3)
      ..write(obj.subspecialty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorSpecialitiesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DoctorSpecialtyAdapter extends TypeAdapter<DoctorSpecialty> {
  @override
  final int typeId = 18;

  @override
  DoctorSpecialty read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorSpecialty(
      doctorId: fields[0] as int?,
      primarySpecialty: fields[1] as bool?,
      specialty: fields[2] as Specialty?,
    );
  }

  @override
  void write(BinaryWriter writer, DoctorSpecialty obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.doctorId)
      ..writeByte(1)
      ..write(obj.primarySpecialty)
      ..writeByte(2)
      ..write(obj.specialty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorSpecialtyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DoctorSpokenLanguageAdapter extends TypeAdapter<DoctorSpokenLanguage> {
  @override
  final int typeId = 12;

  @override
  DoctorSpokenLanguage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorSpokenLanguage(
      doctorId: fields[0] as int?,
      displaySequence: fields[1] as int?,
      spokenLanguage: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DoctorSpokenLanguage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.doctorId)
      ..writeByte(1)
      ..write(obj.displaySequence)
      ..writeByte(2)
      ..write(obj.spokenLanguage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorSpokenLanguageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DoctorQualificationAdapter extends TypeAdapter<DoctorQualification> {
  @override
  final int typeId = 13;

  @override
  DoctorQualification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorQualification(
      doctorId: fields[0] as int?,
      displaySequence: fields[1] as int?,
      qualification: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DoctorQualification obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.doctorId)
      ..writeByte(1)
      ..write(obj.displaySequence)
      ..writeByte(2)
      ..write(obj.qualification);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorQualificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DoctorClinicLocationAdapter extends TypeAdapter<DoctorClinicLocation> {
  @override
  final int typeId = 15;

  @override
  DoctorClinicLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorClinicLocation(
      doctorId: fields[0] as int?,
      location: fields[1] as String?,
      building: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DoctorClinicLocation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.doctorId)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(2)
      ..write(obj.building);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorClinicLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DoctorClinicHoursAdapter extends TypeAdapter<DoctorClinicHours> {
  @override
  final int typeId = 16;

  @override
  DoctorClinicHours read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorClinicHours(
      doctorId: fields[0] as int?,
      displaySequence: fields[1] as int?,
      dayOfTheWeek: fields[2] as String?,
      dayStartTime: fields[3] as String?,
      dayEndTime: fields[4] as String?,
      byAppointmentOnly: fields[5] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, DoctorClinicHours obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.doctorId)
      ..writeByte(1)
      ..write(obj.displaySequence)
      ..writeByte(2)
      ..write(obj.dayOfTheWeek)
      ..writeByte(3)
      ..write(obj.dayStartTime)
      ..writeByte(4)
      ..write(obj.dayEndTime)
      ..writeByte(5)
      ..write(obj.byAppointmentOnly);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorClinicHoursAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DoctorContactAdapter extends TypeAdapter<DoctorContact> {
  @override
  final int typeId = 17;

  @override
  DoctorContact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorContact(
      doctorId: fields[0] as int?,
      displaySequence: fields[1] as int?,
      contactType: fields[2] as String?,
      contactValue: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DoctorContact obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.doctorId)
      ..writeByte(1)
      ..write(obj.displaySequence)
      ..writeByte(2)
      ..write(obj.contactType)
      ..writeByte(3)
      ..write(obj.contactValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorContactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DoctorInfoAdapter extends TypeAdapter<DoctorInfo> {
  @override
  final int typeId = 11;

  @override
  DoctorInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorInfo(
      doctorId: fields[0] as int,
      mcr: fields[1] as String?,
      name: fields[2] as String?,
      gender: fields[3] as String?,
      nationality: fields[4] as String?,
      image: fields[5] as String?,
      showMakeAppointmentButton: fields[17] as String?,
      allowAppointment: fields[6] as String?,
      qualifications: fields[7] as String?,
      registrationNum: fields[8] as String?,
      doctorSpokenLanguage: (fields[9] as List).cast<DoctorSpokenLanguage>(),
      doctorQualifications: (fields[10] as List).cast<DoctorQualification>(),
      doctorSpecialities: (fields[11] as List).cast<DoctorSpecialities>(),
      doctorClinicLocation: (fields[12] as List).cast<DoctorClinicLocation>(),
      doctorClinicHours: (fields[13] as List).cast<DoctorClinicHours>(),
      doctorContact: (fields[14] as List).cast<DoctorContact>(),
      doctorSpecialty: (fields[15] as List).cast<DoctorSpecialty>(),
    )..date = fields[16] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, DoctorInfo obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.doctorId)
      ..writeByte(1)
      ..write(obj.mcr)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.nationality)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(17)
      ..write(obj.showMakeAppointmentButton)
      ..writeByte(6)
      ..write(obj.allowAppointment)
      ..writeByte(7)
      ..write(obj.qualifications)
      ..writeByte(8)
      ..write(obj.registrationNum)
      ..writeByte(9)
      ..write(obj.doctorSpokenLanguage)
      ..writeByte(10)
      ..write(obj.doctorQualifications)
      ..writeByte(11)
      ..write(obj.doctorSpecialities)
      ..writeByte(12)
      ..write(obj.doctorClinicLocation)
      ..writeByte(13)
      ..write(obj.doctorClinicHours)
      ..writeByte(14)
      ..write(obj.doctorContact)
      ..writeByte(15)
      ..write(obj.doctorSpecialty)
      ..writeByte(16)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
