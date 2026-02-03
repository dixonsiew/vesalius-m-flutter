class Allergy {

  num? alertRefNo;
  String? prn;
  String? alertType;
  String? allergyType;
  String? description;
  String? reaction;
  String? createdBy;
  String? creationDate;
  String? inactiveReason;

  Allergy({
    this.alertRefNo,
    this.prn,
    this.alertType,
    this.allergyType,
    this.description,
    this.reaction,
    this.createdBy,
    this.creationDate,
    this.inactiveReason,
  });

  factory Allergy.fromJson(Map<String, dynamic> json) {
    return Allergy(
      alertRefNo: json['alertRefNo'],
      prn: json['prn'],
      alertType: json['alertType'],
      allergyType: json['allergyType'],
      description: json['description'],
      reaction: json['reaction'],
      createdBy: json['createdBy'],
      creationDate: json['creationDate'],
      inactiveReason: json['inactiveReason'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'alertRefNo': alertRefNo,
      'prn': prn,
      'alertType': alertType,
      'allergyType': allergyType,
      'description': description,
      'reaction': reaction,
      'createdBy': createdBy,
      'creationDate': creationDate,
      'inactiveReason': inactiveReason,
    };
}

class AllergyGroup {

  String? alertType;
  List<Allergy>? list;

  AllergyGroup({
    this.alertType,
    this.list,
  });

  Map<String, dynamic> toJson() =>
    {
      'alertType': alertType,
      'list': list?.map((x) => x.toJson()).toList(),
    };
}