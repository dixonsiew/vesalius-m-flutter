class LogisticReqForm {

  String name;
  String dob;
  String idType;
  String idNum;
  String nationality;
  String email;
  String doc;
  String visitWithCompanion;

  LogisticReqForm({
    required this.name,
    required this.dob,
    required this.idType,
    required this.idNum,
    required this.nationality,
    required this.email,
    required this.doc,
    required this.visitWithCompanion,
  });
}

class LogisticReqForm2 {

  String name;
  String dob;
  String idType;
  String idNum;
  String relationship;

  LogisticReqForm2({
    required this.name,
    required this.dob,
    required this.idType,
    required this.idNum,
    required this.relationship,
  });
}

class LogisticReqForm3 {

  String name;
  String num;
  String arrDate;
  String arrTime;
  String pickDate;
  String pickTime;

  LogisticReqForm3({
    required this.name,
    required this.num,
    required this.arrDate,
    required this.arrTime,
    required this.pickDate,
    required this.pickTime,
  });
}

class LogisticSlot {

  String dayOfWeek;
  String pickUpDate;
  String pickUpTime;

  LogisticSlot({
    required this.dayOfWeek,
    required this.pickUpDate,
    required this.pickUpTime,
  });

  factory LogisticSlot.fromJson(Map<String, dynamic> json) {
    return LogisticSlot(
      dayOfWeek: json['dayOfWeek'],
      pickUpDate: json['pickUpDate'],
      pickUpTime: json['pickUpTime'],
    );
  }
}

class LogisticRequest {

  String logisticRequestNumber;
  String logisticRequestStatus;
  bool displayCancelBtn;
  String requesterName;
  String? primaryDoctorName;
  String visitWithCompanion;
  String? companionName;
  String flightAirlineName;
  String flightNumber;
  String flightArrivalDate;
  String flightArrivalTime;
  String requestedPickupDate;
  String requestedPickupTime;

  LogisticRequest({
    required this.logisticRequestNumber,
    required this.logisticRequestStatus,
    required this.displayCancelBtn,
    required this.requesterName,
    this.primaryDoctorName,
    required this.visitWithCompanion,
    this.companionName,
    required this.flightAirlineName,
    required this.flightNumber,
    required this.flightArrivalDate,
    required this.flightArrivalTime,
    required this.requestedPickupDate,
    required this.requestedPickupTime,
  });

  factory LogisticRequest.fromJson(Map<String, dynamic> json) {
    return LogisticRequest(
      logisticRequestNumber: json['logisticRequestNumber'],
      logisticRequestStatus: json['logisticRequestStatus'],
      displayCancelBtn: json['displayCancelBtn'],
      requesterName: json['requesterName'],
      primaryDoctorName: json['primaryDoctorName'],
      visitWithCompanion: json['visitWithCompanion'],
      companionName: json['companionName'],
      flightAirlineName: json['flightAirlineName'],
      flightNumber: json['flightNumber'],
      flightArrivalDate: json['flightArrivalDate'],
      flightArrivalTime: json['flightArrivalTime'],
      requestedPickupDate: json['requestedPickupDate'],
      requestedPickupTime: json['requestedPickupTime'],
    );
  }
}