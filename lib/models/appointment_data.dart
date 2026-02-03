import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

import 'doctor_data.dart';

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

  String getTime(String s) {
    String ts = '2023-01-01T$s:00';
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(DateTime.parse(ts));
  }

  String getDate(String s) {
    return s.replaceAll('-', ' ');
  }

  @override
  String toString() {
    String s = '';
    if (date != null && startTime != null) {
      s = '${getDate(date!)}, ${getTime(startTime!)}';
    }
    
    return s;
  }
}

class SessionAvailableSlot extends AvailableSlot {

  String sessionType;

  SessionAvailableSlot({
    slotNumber,
    date,
    day,
    startTime,
    endTime,
    doctorName,
    speciality,
    clinic,
    room,
    caseType,
    required this.sessionType,
  }) : super(
    slotNumber: slotNumber,
    date: date,
    day: day,
    startTime: startTime,
    endTime: endTime,
    doctorName: doctorName,
    speciality: speciality,
    clinic: clinic,
    room: room,
    caseType: caseType,
  );

  factory SessionAvailableSlot.fromJson(Map<String, dynamic> json) {
    return SessionAvailableSlot(
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
      sessionType: json['sessionType'],
    );
  }
}

class PatientAppointment {

  int doctorId;
  String? mcr;
  String? name;
  String? gender;
  String? nationality;
  String? image;
  List<DoctorSpecialities> doctorSpecialities;
  List<DoctorClinicLocation> doctorClinicLocation;
  List<DoctorContact> doctorContact;
  String apptNo;
  String apptDate;
  String apptStartTime;
  String apptEndTime;
  String apptCaseType;

  PatientAppointment({
    this.doctorId = 0,
    this.mcr,
    this.name,
    this.gender,
    this.nationality,
    this.image,
    this.doctorSpecialities = const[],
    this.doctorClinicLocation = const[],
    this.doctorContact = const[],
    required this.apptNo,
    required this.apptDate,
    required this.apptStartTime,
    required this.apptEndTime,
    required this.apptCaseType,
  });

  factory PatientAppointment.fromJson(Map<String, dynamic> json) {
    final ls = json['doctorSpecialities'] as List? ?? [];
    List<DoctorSpecialities> lx = ls.map<DoctorSpecialities>((x) => DoctorSpecialities.fromJson(x)).toList();

    final lp = json['doctorClinicLocation'] as List? ?? [];
    List<DoctorClinicLocation> ld = lp.map<DoctorClinicLocation>((x) => DoctorClinicLocation.fromJson(x)).toList();

    final lr = json['doctorContact'] as List? ?? [];
    List<DoctorContact> lf = lr.map<DoctorContact>((x) => DoctorContact.fromJson(x)).toList();

    final app = json['vesaliusApptInfo'];

    return PatientAppointment(
      doctorId: json['doctor_id'],
      mcr: json['mcr'],
      name: json['name'],
      gender: json['gender'],
      nationality: json['nationality'],
      image: json['image'],
      doctorSpecialities: lx,
      doctorClinicLocation: ld,
      doctorContact: lf,
      apptNo: app['apptNo'],
      apptDate: app['apptDate'],
      apptStartTime: app['apptStartTime'],
      apptEndTime: app['apptEndTime'],
      apptCaseType: app['apptCaseType'],
    );
  }
}

class PastAppointment {

  int doctorId;
  String? mcr;
  String? name;
  String? gender;
  String? nationality;
  String? image;
  List<DoctorSpecialities> doctorSpecialities;
  List<DoctorClinicLocation> doctorClinicLocation;
  List<DoctorContact> doctorContact;
  int appointmentRefNo;
  String hospitalCode;
  String patientPrn;
  String appointmentDate;
  String appointmentTime;
  int durationMins;
  String caseType;
  String status;
  String roomNo;
  String clinicName;
  String accountNo;
  String appointmentSource;
  String appointmentType;

  PastAppointment({
    this.doctorId = 0,
    this.mcr,
    this.name,
    this.gender,
    this.nationality,
    this.image,
    this.doctorSpecialities = const[],
    this.doctorClinicLocation = const[],
    this.doctorContact = const[],
    required this.appointmentRefNo,
    required this.hospitalCode,
    required this.patientPrn,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.durationMins,
    required this.caseType,
    required this.status,
    required this.roomNo,
    required this.clinicName,
    required this.accountNo,
    required this.appointmentSource,
    required this.appointmentType,
  });

  factory PastAppointment.fromJson(Map<String, dynamic> json) {
    final ls = json['doctorSpecialities'] as List? ?? [];
    List<DoctorSpecialities> lx = ls.map<DoctorSpecialities>((x) => DoctorSpecialities.fromJson(x)).toList();

    final lp = json['doctorClinicLocation'] as List? ?? [];
    List<DoctorClinicLocation> ld = lp.map<DoctorClinicLocation>((x) => DoctorClinicLocation.fromJson(x)).toList();

    final lr = json['doctorContact'] as List? ?? [];
    List<DoctorContact> lf = lr.map<DoctorContact>((x) => DoctorContact.fromJson(x)).toList();

    final app = json['vesaliusPastApptInfo'];

    return PastAppointment(
      doctorId: json['doctor_id'],
      mcr: json['mcr'],
      name: json['name'],
      gender: json['gender'],
      nationality: json['nationality'],
      image: json['image'],
      doctorSpecialities: lx,
      doctorClinicLocation: ld,
      doctorContact: lf,
      appointmentRefNo: app['appointmentRefNo'],
      hospitalCode: app['hospitalCode'],
      patientPrn: app['patientPrn'],
      appointmentDate: app['appointmentDate'],
      appointmentTime: app['appointmentTime'],
      durationMins: app['durationMins'],
      caseType: app['caseType'],
      status: app['status'],
      roomNo: app['roomNo'],
      clinicName: app['clinicName'],
      accountNo: app['accountNo'],
      appointmentSource: app['appointmentSource'],
      appointmentType: app['appointmentType'],
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

class AppointmentSession {

  final String session;
  final String startTime;
  final String endTime;
  SessionAvailableSlot? slot;

  AppointmentSession({
    required this.session,
    required this.startTime,
    required this.endTime,
    this.slot,
  });

  String getTimeDisplay(String s) {
    String ts = '2023-01-01T$s:00';
    return formatDate(DateTime.parse(ts), [h, ':', nn, am]).toLowerCase();
  }

  @override
  String toString() {
    return '$session (${getTimeDisplay(startTime)}-${getTimeDisplay(endTime)})';
  }
}