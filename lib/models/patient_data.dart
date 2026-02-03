import 'package:hive/hive.dart';

part 'patient_data.g.dart';

@HiveType(typeId: 5)
class ContactNumber extends HiveObject {

  @HiveField(0)
  String? home;

  @HiveField(1)
  String? email;

  ContactNumber({
    this.home,
    this.email,
  });

  factory ContactNumber.fromJson(Map<String, dynamic> json) {
    return ContactNumber(
      home: json['home'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'home': home,
      'email': email,
    };
}

@HiveType(typeId: 6)
class Address extends HiveObject {

  @HiveField(0)
  String? address1;

  @HiveField(1)
  String? address2;

  @HiveField(2)
  String? address3;

  @HiveField(3)
  String? address4;

  @HiveField(4)
  String? address5;

  @HiveField(5)
  String? cityState;

  @HiveField(6)
  String? postalCode;

  Address({
    this.address1,
    this.address2,
    this.address3,
    this.address4,
    this.address5,
    this.cityState,
    this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address1: json['address1'],
      address2: json['address2'],
      address3: json['address3'],
      address4: json['address4'],
      address5: json['address5'],
      cityState: json['cityState'],
      postalCode: json['postalCode'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'address4': address4,
      'address5': address5,
      'cityState': cityState,
      'postalCode': postalCode,
    };
}

@HiveType(typeId: 7)
class Name extends HiveObject {

  @HiveField(0)
  String? firstName;

  @HiveField(1)
  String? lastName;

  @HiveField(2)
  String? middleName;

  @HiveField(3)
  String? title;

  Name({
    this.firstName,
    this.lastName,
    this.middleName,
    this.title,
  });

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      firstName: json['firstName'],
      lastName: json['lastName'],
      middleName: json['middleName'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'title': title,
    };
}

@HiveType(typeId: 8)
class Nationality extends HiveObject {

  @HiveField(0)
  String? code;

  @HiveField(1)
  String? description;

  Nationality({
    this.code,
    this.description,
  });

  factory Nationality.fromJson(Map<String, dynamic> json) {
    return Nationality(
      code: json['code'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'code': code,
      'description': description,
    };
}

@HiveType(typeId: 9)
class Sex extends HiveObject {

  @HiveField(0)
  String? code;

  @HiveField(1)
  String? description;

  Sex({
    this.code,
    this.description,
  });

  factory Sex.fromJson(Map<String, dynamic> json) {
    return Sex(
      code: json['code'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'code': code,
      'description': description,
    };
}

@HiveType(typeId: 10)
class Document extends HiveObject {

  @HiveField(0)
  String? code;

  @HiveField(1)
  String? description;

  @HiveField(2)
  String? value;

  @HiveField(3)
  String? expiryDate;

  Document({
    this.code,
    this.description,
    this.value,
    this.expiryDate,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      code: json['code'],
      description: json['description'],
      value: json['value'],
      expiryDate: json['expireDate'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'code': code,
      'description': description,
      'value': value,
      'expireDate': expiryDate,
    };
}

@HiveType(typeId: 4)
class PatientDetails extends HiveObject {

  @HiveField(0)
  ContactNumber? contactNumber;

  @HiveField(1)
  String? dob;

  @HiveField(2)
  Address? homeAddress;

  @HiveField(3)
  Name? name;

  @HiveField(4)
  Nationality? nationality;

  @HiveField(5)
  String? prn;

  @HiveField(6)
  String? resident;

  @HiveField(7)
  Sex? sex;

  @HiveField(8)
  List<Document> documents;

  PatientDetails({
    this.contactNumber,
    this.dob,
    this.homeAddress,
    this.name,
    this.nationality,
    this.prn,
    this.resident,
    this.sex,
    this.documents = const[],
  });

  factory PatientDetails.fromJson(Map<String, dynamic> json) {
    final ls = json['documents'] as List? ?? [];
    List<Document> lx = ls.map<Document>((x) => Document.fromJson(x)).toList();

    return PatientDetails(
      contactNumber: ContactNumber.fromJson(json['contactNumber']),
      dob: json['dob'],
      homeAddress: Address.fromJson(json['homeAddress']),
      name: Name.fromJson(json['name']),
      nationality: Nationality.fromJson(json['nationality']),
      prn: json['prn'],
      resident: json['resident'],
      sex: Sex.fromJson(json['sex']),
      documents: lx,
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'contactNumber': contactNumber?.toJson(),
      'dob': dob,
      'homeAddress': homeAddress?.toJson(),
      'name': name?.toJson(),
      'nationality': nationality?.toJson(),
      'prn': prn,
      'resident': resident,
      'sex': sex?.toJson(),
      'documents': documents.map((x) => x.toJson()).toList(),
    };

  String get displayName {
    Name? x = name;
    String s = '${x?.title ?? ''} ${x?.firstName ?? ''} ${x?.middleName ?? ''} ${x?.lastName ?? ''}'.trim();
    return s;
  }
}

class NovaBill {

  String? accountNumber;
  num? amount;
  dynamic badDebtStatus;
  String? billDate;
  String? billNumber;
  String? billTime;
  String? billType;
  num? cnAmount;
  num? dnAmount;
  num? exclusiveTax;
  String? finalizeCounter;
  String? finalizeLocation;
  String? finalizeUser;
  num? inclusiveTax;
  String? invoiceNumber;
  String? invoiceType;
  dynamic memberId;
  dynamic originalBillNumber;
  num? osAmount;
  String? payer;
  dynamic paymentTerm;
  String? prn;
  String? remark;
  num? roundingAmount;
  String? syncDate;
  String? transferDateTime;
  String? transferFlag;
  dynamic transferSystem;

  NovaBill({
    this.accountNumber,
    this.amount,
    this.badDebtStatus,
    this.billDate,
    this.billNumber,
    this.billTime,
    this.billType,
    this.cnAmount,
    this.dnAmount,
    this.exclusiveTax,
    this.finalizeCounter,
    this.finalizeLocation,
    this.finalizeUser,
    this.inclusiveTax,
    this.invoiceNumber,
    this.invoiceType,
    this.memberId,
    this.originalBillNumber,
    this.osAmount,
    this.payer,
    this.paymentTerm,
    this.prn,
    this.remark,
    this.roundingAmount,
    this.syncDate,
    this.transferDateTime,
    this.transferFlag,
    this.transferSystem,
  });

  factory NovaBill.fromJson(Map<String, dynamic> json) {
    return NovaBill(
      accountNumber: json['accountNumber'],
      amount: json['amount'],
      badDebtStatus: json['badDebtStatus'],
      billDate: json['billDate'],
      billNumber: json['billNumber'],
      billTime: json['billTime'],
      billType: json['billType'],
      cnAmount: json['cnAmount'],
      dnAmount: json['dnAmount'],
      exclusiveTax: json['exclusiveTax'],
      finalizeCounter: json['finalizeCounter'],
      finalizeLocation: json['finalizeLocation'],
      finalizeUser: json['finalizeUser'],
      inclusiveTax: json['inclusiveTax'],
      invoiceNumber: json['invoiceNumber'],
      invoiceType: json['invoiceType'],
      memberId: json['memberId'],
      originalBillNumber: json['originalBillNumber'],
      osAmount: json['osAmount'],
      payer: json['payer'],
      paymentTerm: json['paymentTerm'],
      prn: json['prn'],
      remark: json['remark'],
      roundingAmount: json['roundingAmount'],
      syncDate: json['syncDate'],
      transferDateTime: json['transferDateTime'],
      transferFlag: json['transferFlag'],
      transferSystem: json['transferSystem'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'accountNumber': accountNumber,
      'amount': amount,
      'badDebtStatus': badDebtStatus,
      'billDate': billDate,
      'billNumber': billNumber,
      'billTime': billTime,
      'billType': billType,
      'cnAmount': cnAmount,
      'dnAmount': dnAmount,
      'exclusiveTax': exclusiveTax,
      'finalizeCounter': finalizeCounter,
      'finalizeLocation': finalizeLocation,
      'finalizeUser': finalizeUser,
      'inclusiveTax': inclusiveTax,
      'invoiceNumber': invoiceNumber,
      'invoiceType': invoiceType,
      'memberId': memberId,
      'originalBillNumber': originalBillNumber,
      'osAmount': osAmount,
      'payer': payer,
      'paymentTerm': paymentTerm,
      'prn': prn,
      'remark': remark,
      'roundingAmount': roundingAmount,
      'syncDate': syncDate,
      'transferDateTime': transferDateTime,
      'transferFlag': transferFlag,
      'transferSystem': transferSystem,
    };
}

class NovaVisit {

  String? accountNo;
  String? admissionDate;
  String? admissionStatus;
  String? admissionTime;
  String? admittingDoctor;
  String? bedNo;
  String? caseType;
  String? chargeCategoryCode;
  String? clinicName;
  String? createdBy;
  String? dischargeDate;
  dynamic dischargeDiagnosis;
  String? dischargeDoctor;
  String? dischargeReason;
  String? dischargeTime;
  String? dispositionRemark;
  String? dispositionStatus;
  String? healthCheck;
  String? hospitalCode;
  String? mcrNo;
  String? paymentClassCode;
  String? prelimDischargeDate;
  String? prelimDischargeTime;
  String? primaryDoctor;
  String? primarySpecialty;
  String? prn;
  String? referral;
  String? referralText;
  String? referrerCode;
  String? registrationDate;
  String? registrationTime;
  String? roomNo;
  String? syncDate;
  String? transferChargeAccountNo;
  String? transferDateTime;
  String? transferFlag;
  dynamic transferSystem;
  String? visitStatus;
  String? visitType;
  String? wardNo;

  NovaVisit({
    this.accountNo,
    this.admissionDate,
    this.admissionStatus,
    this.admissionTime,
    this.admittingDoctor,
    this.bedNo,
    this.caseType,
    this.chargeCategoryCode,
    this.clinicName,
    this.createdBy,
    this.dischargeDate,
    this.dischargeDiagnosis,
    this.dischargeDoctor,
    this.dischargeReason,
    this.dischargeTime,
    this.dispositionRemark,
    this.dispositionStatus,
    this.healthCheck,
    this.hospitalCode,
    this.mcrNo,
    this.paymentClassCode,
    this.prelimDischargeDate,
    this.prelimDischargeTime,
    this.primaryDoctor,
    this.primarySpecialty,
    this.prn,
    this.referral,
    this.referralText,
    this.referrerCode,
    this.registrationDate,
    this.registrationTime,
    this.roomNo,
    this.syncDate,
    this.transferChargeAccountNo,
    this.transferDateTime,
    this.transferFlag,
    this.transferSystem,
    this.visitStatus,
    this.visitType,
    this.wardNo,
  });

  factory NovaVisit.fromJson(Map<String, dynamic> json) {
    return NovaVisit(
      accountNo: json['accountNo'],
      admissionDate: json['admissionDate'],
      admissionStatus: json['admissionStatus'],
      admissionTime: json['admissionTime'],
      admittingDoctor: json['admittingDoctor'],
      bedNo: json['bedNo'],
      caseType: json['caseType'],
      chargeCategoryCode: json['chargeCategoryCode'],
      clinicName: json['clinicName'],
      createdBy: json['createdBy'],
      dischargeDate: json['dischargeDate'],
      dischargeDiagnosis: json['dischargeDiagnosis'],
      dischargeDoctor: json['dischargeDoctor'],
      dischargeReason: json['dischargeReason'],
      dischargeTime: json['dischargeTime'],
      dispositionRemark: json['dispositionRemark'],
      dispositionStatus: json['dispositionStatus'],
      healthCheck: json['healthCheck'],
      hospitalCode: json['hospitalCode'],
      mcrNo: json['mcrNo'],
      paymentClassCode: json['paymentClassCode'],
      prelimDischargeDate: json['prelimDischargeDate'],
      prelimDischargeTime: json['prelimDischargeTime'],
      primaryDoctor: json['primaryDoctor'],
      primarySpecialty: json['primarySpecialty'],
      prn: json['prn'],
      referral: json['referral'],
      referralText: json['referralText'],
      referrerCode: json['referrerCode'],
      registrationDate: json['registrationDate'],
      registrationTime: json['registrationTime'],
      roomNo: json['roomNo'],
      syncDate: json['syncDate'],
      transferChargeAccountNo: json['transferChargeAccountNo'],
      transferDateTime: json['transferDateTime'],
      transferFlag: json['transferFlag'],
      transferSystem: json['transferSystem'],
      visitStatus: json['visitStatus'],
      visitType: json['visitType'],
      wardNo: json['wardNo'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'accountNo': accountNo,
      'admissionDate': admissionDate,
      'admissionStatus': admissionStatus,
      'admissionTime': admissionTime,
      'admittingDoctor': admittingDoctor,
      'bedNo': bedNo,
      'caseType': caseType,
      'chargeCategoryCode': chargeCategoryCode,
      'clinicName': clinicName,
      'createdBy': createdBy,
      'dischargeDate': dischargeDate,
      'dischargeDiagnosis': dischargeDiagnosis,
      'dischargeDoctor': dischargeDoctor,
      'dischargeReason': dischargeReason,
      'dischargeTime': dischargeTime,
      'dispositionRemark': dispositionRemark,
      'dispositionStatus': dispositionStatus,
      'healthCheck': healthCheck,
      'hospitalCode': hospitalCode,
      'mcrNo': mcrNo,
      'paymentClassCode': paymentClassCode,
      'prelimDischargeDate': prelimDischargeDate,
      'prelimDischargeTime': prelimDischargeTime,
      'primaryDoctor': primaryDoctor,
      'primarySpecialty': primarySpecialty,
      'prn': prn,
      'referral': referral,
      'referralText': referralText,
      'referrerCode': referrerCode,
      'registrationDate': registrationDate,
      'registrationTime': registrationTime,
      'roomNo': roomNo,
      'syncDate': syncDate,
      'transferChargeAccountNo': transferChargeAccountNo,
      'transferDateTime': transferDateTime,
      'transferFlag': transferFlag,
      'transferSystem': transferSystem,
      'visitStatus': visitStatus,
      'visitType': visitType,
      'wardNo': wardNo,
    };
}

class NovaVisitVitalSignsDetail {

  String? code;
  String? desc;
  String? value1;
  String? value2;
  String? unit;

  NovaVisitVitalSignsDetail({
    this.code,
    this.desc,
    this.value1,
    this.value2,
    this.unit,
  });

  factory NovaVisitVitalSignsDetail.fromJson(Map<String, dynamic> json) {
    return NovaVisitVitalSignsDetail(
      code: json['code'],
      desc: json['desc'],
      value1: json['value1'],
      value2: json['value2'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'code': code,
      'desc': desc,
      'value1': value1,
      'value2': value2,
      'unit': unit,
    };
}

class PatientVisit {

  List<NovaBill> novaBills;
  NovaVisit? novaVisit;
  List novaVisitSummaries;
  List novaVisitPrescriptionList;
  List<NovaHealthScreeningRpt> novaHealthScreeningRptList;
  List? novaPatientDiagnosisDetails;
  List<NovaVisitInvestigationDetail> novaVisitInvestigationDetailList;
  List<NovaVisitVitalSignsDetail> novaVisitVitalSignsDetailList;
  List<NovaVisitReferralLetter> novaVisitReferralLetterList;
  List<NovaVisitPatientRx> novaVisitPatientRxList;

  PatientVisit({
    this.novaBills = const[],
    this.novaVisit,
    this.novaVisitSummaries = const[],
    this.novaVisitPrescriptionList = const[],
    this.novaHealthScreeningRptList = const[],
    this.novaPatientDiagnosisDetails = const[],
    this.novaVisitInvestigationDetailList = const[],
    this.novaVisitVitalSignsDetailList = const[],
    this.novaVisitReferralLetterList = const[],
    this.novaVisitPatientRxList = const[],
  });

  factory PatientVisit.fromJson(Map<String, dynamic> json) {
    final ls = json['novaBills'] as List? ?? [];
    List<NovaBill> lx = ls.map<NovaBill>((x) => NovaBill.fromJson(x)).toList();

    final lm = json['novaVisitVitalSignsDetailList'] as List? ?? [];
    List<NovaVisitVitalSignsDetail> ly = lm.map<NovaVisitVitalSignsDetail>((x) => NovaVisitVitalSignsDetail.fromJson(x)).toList();

    final ln = json['novaVisitInvestigationDetailList'] as List? ?? [];
    List<NovaVisitInvestigationDetail> la = ln.map<NovaVisitInvestigationDetail>((x) => NovaVisitInvestigationDetail.fromJson(x)).toList();

    final lo = json['novaVisitReferralLetterList'] as List? ?? [];
    List<NovaVisitReferralLetter> lb = lo.map<NovaVisitReferralLetter>((x) => NovaVisitReferralLetter.fromJson(x)).toList();

    final lp = json['novaHealthScreeningRptList'] as List? ?? [];
    List<NovaHealthScreeningRpt> lc = lp.map<NovaHealthScreeningRpt>((x) => NovaHealthScreeningRpt.fromJson(x)).toList();

    final lq = json['novaVisitPatientRxList'] as List? ?? [];
    List<NovaVisitPatientRx> ld = lq.map<NovaVisitPatientRx>((x) => NovaVisitPatientRx.fromJson(x)).toList();

    return PatientVisit(
      novaBills: lx,
      novaVisit: NovaVisit.fromJson(json['novaVisit']),
      novaVisitVitalSignsDetailList: ly,
      novaVisitInvestigationDetailList: la,
      novaVisitReferralLetterList: lb,
      novaHealthScreeningRptList: lc,
      novaVisitPatientRxList: ld,
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'novaBills': novaBills.map((x) => x.toJson()).toList(),
      'novaVisit': novaVisit?.toJson(),
      'novaVisitVitalSignsDetailList': novaVisitVitalSignsDetailList.map((x) => x.toJson()).toList(),
      'novaVisitInvestigationDetailList': novaVisitInvestigationDetailList.map((x) => x.toJson()).toList(),
      'novaVisitReferralLetterList': novaVisitReferralLetterList.map((x) => x.toJson()).toList(),
      'novaHealthScreeningRptList': novaHealthScreeningRptList.map((x) => x.toJson()).toList(),
    };
}

class NovaPatientVitalSignsDetail {

  String? code;
  String? description;
  String? value1;
  String? value2;
  String? unit;
  String? recordedDate;
  String? refNo;

  NovaPatientVitalSignsDetail({
    this.code,
    this.description,
    this.value1,
    this.value2,
    this.unit,
    this.recordedDate,
    this.refNo,
  });

  factory NovaPatientVitalSignsDetail.fromJson(Map<String, dynamic> json) {
    return NovaPatientVitalSignsDetail(
      code: json['code'],
      description: json['description'],
      value1: json['value1'],
      value2: json['value2'],
      unit: json['unit'],
      recordedDate: json['recordedDate'],
      refNo: json['refNo'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'code': code,
      'description': description,
      'value1': value1,
      'value2': value2,
      'unit': unit,
      'recordedDate': recordedDate,
      'refNo': refNo,
    };
}

class VitalSignsData {

  NovaPatientVitalSignsDetail? novaPatientVitalSignsDetail;
  String? value1High;
  String? value1Low;
  String? value2High;
  String? value2Low;

  VitalSignsData({
    this.novaPatientVitalSignsDetail,
    this.value1High,
    this.value1Low,
    this.value2High,
    this.value2Low,
  });

  factory VitalSignsData.fromJson(Map<String, dynamic> json) {
    return VitalSignsData(
      novaPatientVitalSignsDetail: NovaPatientVitalSignsDetail.fromJson(json['novaPatientVitalSignsDetail']),
      value1High: json['value1_high_value'],
      value1Low: json['value1_low_value'],
      value2High: json['value2_high_value'],
      value2Low: json['value2_low_value'],
    );
  }
}

class LabData {

  String? investigationRefNo;
  String? code;
  String? resultValue;
  String? resultUnit;
  String? referenceRange;
  String? rangeType;
  String? resultClob;
  String? recordedDate;

  LabData({
    this.investigationRefNo,
    this.code,
    this.resultValue,
    this.resultUnit,
    this.referenceRange,
    this.rangeType,
    this.resultClob,
    this.recordedDate,
  });

  factory LabData.fromJson(Map<String, dynamic> json) {
    return LabData(
      investigationRefNo: json['investigationRefNo'],
      code: json['code'],
      resultValue: json['resultValue'],
      resultUnit: json['resultUnit'],
      referenceRange: json['referenceRange'],
      rangeType: json['rangeType'],
      resultClob: json['resultClob'],
      recordedDate: json['recordedDate'],
    );
  }
}

class VitalSignsHistory {

  String? vitalSignCode;
  List<VitalSignsData> vitalSignsData;

  VitalSignsHistory({
    this.vitalSignCode,
    this.vitalSignsData = const[],
  });

  factory VitalSignsHistory.fromJson(Map<String, dynamic> json) {
    final ls = json['vitalSignsData'] as List? ?? [];
    List<VitalSignsData> lx = ls.map<VitalSignsData>((x) => VitalSignsData.fromJson(x)).toList();

    return VitalSignsHistory(
      vitalSignCode: json['vitalSignCode'],
      vitalSignsData: lx,
    );
  }
}

class LabHistory {

  String? labCode;
  List<LabData> labData;

  LabHistory({
    this.labCode,
    this.labData = const[],
  });

  factory LabHistory.fromJson(Map<String, dynamic> json) {
    final ls = json['labData'] as List? ?? [];
    List<LabData> lx = ls.map<LabData>((x) => LabData.fromJson(x)).toList();

    return LabHistory(
      labCode: json['labCode'],
      labData: lx,
    );
  }
}

class PanelDetail {

  String? code;
  String? description;
  String? resultValue;
  String? resultUnit;
  String? referenceRange;
  String? rangeType;
  String? resultClob;

  PanelDetail({
    this.code,
    this.description,
    this.resultValue,
    this.resultUnit,
    this.referenceRange,
    this.rangeType,
    this.resultClob,
  });

  factory PanelDetail.fromJson(Map<String, dynamic> json) {
    return PanelDetail(
      code: json['code'],
      description: json['description'],
      resultValue: json['resultValue'],
      resultUnit: json['resultUnit'],
      referenceRange: json['referenceRange'],
      rangeType: json['rangeType'],
      resultClob: json['resultClob'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'code': code,
      'description': description,
      'resultValue': resultValue,
      'resultUnit': resultUnit,
      'referenceRange': referenceRange,
      'rangeType': rangeType,
      'resultClob': resultClob,
    };
}

class NovaVisitInvestigationDetail {

  String? investigationRefNo;
  String? investigationType;
  String? accountNo;
  String? code;
  String? description;
  String? resultValue;
  String? resultUnit;
  String? referenceRange;
  String? rangeType;
  String? resultClob;
  String? panelCode;
  String? panelDescription;
  List<PanelDetail> panelDetail;

  NovaVisitInvestigationDetail({
    this.investigationRefNo,
    this.investigationType,
    this.accountNo,
    this.code,
    this.description,
    this.resultValue,
    this.resultUnit,
    this.referenceRange,
    this.rangeType,
    this.resultClob,
    this.panelCode,
    this.panelDescription,
    this.panelDetail = const[],
  });

  factory NovaVisitInvestigationDetail.fromJson(Map<String, dynamic> json) {
    final ls = json['panelDetail'] as List? ?? [];
    List<PanelDetail> lx = ls.map<PanelDetail>((x) => PanelDetail.fromJson(x)).toList();

    return NovaVisitInvestigationDetail(
      investigationRefNo: json['investigationRefNo'],
      investigationType: json['investigationType'],
      accountNo: json['accountNo'],
      code: json['code'],
      description: json['description'],
      resultValue: json['resultValue'],
      resultUnit: json['resultUnit'],
      referenceRange: json['referenceRange'],
      rangeType: json['rangeType'],
      resultClob: json['resultClob'],
      panelCode: json['panelCode'],
      panelDescription: json['panelDescription'],
      panelDetail: lx,
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'investigationRefNo': investigationRefNo,
      'investigationType': investigationType,
      'accountNo': accountNo,
      'code': code,
      'description': description,
      'resultValue': resultValue,
      'resultUnit': resultUnit,
      'referenceRange': referenceRange,
      'rangeType': rangeType,
      'resultClob': resultClob,
      'panelCode': panelCode,
      'panelDescription': panelDescription,
      'panelDetail': panelDetail.map((x) => x.toJson()).toList(),
    };
}

class NovaVisitReferralLetter {

  String? referralRefNo;
  String? referralType;
  String? prn;
  String? accountNo;
  String? referralDateTime;
  String? referrerDoctor;
  String? referralDoctor;
  String? referralTitleDept;
  String? referralAddressOrSubject;
  String? referralLetter;

  NovaVisitReferralLetter({
    this.referralRefNo,
    this.referralType,
    this.prn,
    this.accountNo,
    this.referralDateTime,
    this.referrerDoctor,
    this.referralDoctor,
    this.referralTitleDept,
    this.referralAddressOrSubject,
    this.referralLetter,
  });

  factory NovaVisitReferralLetter.fromJson(Map<String, dynamic> json) {
    return NovaVisitReferralLetter(
      referralRefNo: json['referralRefNo'],
      referralType: json['referralType'],
      prn: json['prn'],
      accountNo: json['accountNo'],
      referralDateTime: json['referralDateTime'],
      referrerDoctor: json['referrerDoctor'],
      referralDoctor: json['referralDoctor'],
      referralTitleDept: json['referralTitleDept'],
      referralAddressOrSubject: json['referralAddressOrSubject'],
      referralLetter: json['referralLetter'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'referralRefNo': referralRefNo,
      'referralType': referralType,
      'prn': prn,
      'accountNo': accountNo,
      'referralDateTime': referralDateTime,
      'referrerDoctor': referrerDoctor,
      'referralDoctor': referralDoctor,
      'referralTitleDept': referralTitleDept,
      'referralAddressOrSubject': referralAddressOrSubject,
      'referralLetter': referralLetter,
    };
}

class NovaHealthScreeningRpt {

  String? hsrRefNo;
  String? accountNo;
  String? reportDate;
  String? reportUser;

  NovaHealthScreeningRpt({
    this.hsrRefNo,
    this.accountNo,
    this.reportDate,
    this.reportUser,
  });

  factory NovaHealthScreeningRpt.fromJson(Map<String, dynamic> json) {
    return NovaHealthScreeningRpt(
      hsrRefNo: json['hsrRefNo'],
      accountNo: json['accountNo'],
      reportDate: json['reportDate'],
      reportUser: json['reportUser'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'hsrRefNo': hsrRefNo,
      'accountNo': accountNo,
      'reportDate': reportDate,
      'reportUser': reportUser,
    };
}

class NovaVisitPatientRx {

  String? orderNo;
  String? rxRefNo;
  String? accountNo;
  String? event;
  String? code;
  String? description;
  String? eventDateTime;
  String? quantity;
  String? uom;
  String? instruction;
  String? doctorName;
  String? doctorMCR;

  NovaVisitPatientRx({
    this.orderNo,
    this.rxRefNo,
    this.accountNo,
    this.event,
    this.code,
    this.description,
    this.eventDateTime,
    this.quantity,
    this.uom,
    this.instruction,
    this.doctorName,
    this.doctorMCR,
  });

  factory NovaVisitPatientRx.fromJson(Map<String, dynamic> json) {
    return NovaVisitPatientRx(
      orderNo: json['orderNo'],
      rxRefNo: json['rxRefNo'],
      accountNo: json['accountNo'],
      event: json['event'],
      code: json['code'],
      description: json['description'],
      eventDateTime: json['eventDateTime'],
      quantity: json['quantity'],
      uom: json['uom'],
      instruction: json['instruction'],
      doctorName: json['doctorName'],
      doctorMCR: json['doctorMCR'],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'orderNo': orderNo,
      'rxRefNo': rxRefNo,
      'accountNo': accountNo,
      'event': event,
      'code': code,
      'description': description,
      'eventDateTime': eventDateTime,
      'quantity': quantity,
      'uom': uom,
      'instruction': instruction,
      'doctorName': doctorName,
      'doctorMCR': doctorMCR,
    };
}

class RetPatient {

  String prn;
  String name;

  RetPatient({
    required this.prn,
    required this.name,
  });

  factory RetPatient.fromJson(Map<String, dynamic> json) {
    return RetPatient(
      prn: json['prn'],
      name: json['name'],
    );
  }
}