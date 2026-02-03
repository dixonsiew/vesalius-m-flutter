class AvailableSlot {

  String? slotNumber;
  String? date;
  String? day;
  String? startTime;
  String? endTime;
  String? doctorName;
  String? speciality;
  String? clinic;
  String? room;
  String? caseType;

  AvailableSlot({
    this.slotNumber,
    this.date,
    this.day,
    this.startTime,
    this.endTime,
    this.doctorName,
    this.speciality,
    this.clinic,
    this.room,
    this.caseType,
  });

  factory AvailableSlot.fromJson(Map<String, dynamic> json) {
    return AvailableSlot(
      slotNumber: json['slotNumber'],
      date: json['date'],
      day: json['day'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      doctorName: json['doctorName'],
      speciality: json['speciality'],
      clinic: json['clinic'],
      room: json['room'],
      caseType: json['caseType'],
    );
  }
}

class FutureAppointment {

  String? appointmentNumber;
  String? date;
  String? day;
  String? startTime;
  String? endTime;
  String? doctorMcr;
  String? doctorName;
  String? specialtyCode;
  String? specialty;
  String? clinic;
  String? room;
  String? caseType;

  FutureAppointment({
    this.appointmentNumber,
    this.date,
    this.day,
    this.startTime,
    this.endTime,
    this.doctorMcr,
    this.doctorName,
    this.specialtyCode,
    this.specialty,
    this.clinic,
    this.room,
    this.caseType,
  });

  factory FutureAppointment.fromJson(Map<String, dynamic> json) {
    return FutureAppointment(
      appointmentNumber: json['appointmentNumber'],
      date: json['date'],
      day: json['day'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      doctorMcr: json['doctorMcr'],
      doctorName: json['doctorName'],
      specialtyCode: json['specialtyCode'],
      specialty: json['specialty'],
      clinic: json['clinic'],
      room: json['room'],
      caseType: json['caseType'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'appointmentNumber': appointmentNumber,
      'date': date,
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'doctorMcr': doctorMcr,
      'doctorName': doctorName,
      'specialtyCode': specialtyCode,
      'specialty': specialty,
      'clinic': clinic,
      'room': room,
      'caseType': caseType,
    };
}