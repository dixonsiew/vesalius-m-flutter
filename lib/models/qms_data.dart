class QmsReq {

  String queueNumber;
  String patientsAheadOfYou;
  String ticketStatus;
  String patientPrn;
  String doctorName;
  String roomNumber;
  String asAt;
  String patientName;
  String relationship;

  QmsReq({
    required this.queueNumber,
    required this.patientsAheadOfYou,
    required this.ticketStatus,
    required this.patientPrn,
    required this.doctorName,
    required this.roomNumber,
    required this.asAt,
    required this.patientName,
    required this.relationship,
  });

  factory QmsReq.fromJson(Map<String, dynamic> json) {
    return QmsReq(
      queueNumber: json['queueNumber'],
      patientsAheadOfYou: json['patientsAheadOfYou'],
      ticketStatus: json['ticketStatus'],
      patientPrn: json['patientPrn'],
      doctorName: json['doctorName'],
      roomNumber: json['roomNumber'],
      asAt: json['asAt'],
      patientName: json['patientName'],
      relationship: json['relationship'],
    );
  }
}