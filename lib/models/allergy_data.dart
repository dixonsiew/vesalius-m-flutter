import 'package:hive/hive.dart';

part 'allergy_data.g.dart';

@HiveType(typeId: 22)
class Allergy {

  @HiveField(0)
  num? alertRefNo;

  @HiveField(1)
  String? prn;

  @HiveField(2)
  String? alertType;

  @HiveField(3)
  String? allergyType;

  @HiveField(4)
  String? description;

  @HiveField(5)
  String? reaction;

  @HiveField(6)
  String? createdBy;

  @HiveField(7)
  String? creationDate;

  @HiveField(8)
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

@HiveType(typeId: 23)
class AllergyGroup {

  @HiveField(0)
  String? alertType;

  @HiveField(1)
  List<Allergy> list;

  AllergyGroup({
    this.alertType,
    required this.list,
  });

  Map<String, dynamic> toJson() =>
    {
      'alertType': alertType,
      'list': list.map((x) => x.toJson()).toList(),
    };
}