class HospitalProfile {

  String desc;
  String value;

  HospitalProfile({
    required this.desc,
    required this.value,
  });

  factory HospitalProfile.fromJson(Map<String, dynamic> json) {
    return HospitalProfile(
      desc: json['profileDesc'],
      value: json['profileValue'],
    );
  }
}

class HospitalInfo {

  String contactInfoApptDisplay;
  String contactInfoApptCall;
  String contact24Display;
  String contact24Call;
  String contactTollFreeMalDisplay;
  String contactTollFreeMalCall;
  String contactTollFreeIndDisplay;
  String contactTollFreeIndCall;
  String contactWhatsAppDisplay;
  String contactWhatsAppCall;
  String email;
  String website;
  String reg;
  String addr1;
  String addr2;
  String postcode;
  String state;
  String country;
  String companyName;

  HospitalInfo({
    required this.contactInfoApptDisplay,
    required this.contactInfoApptCall,
    required this.contact24Display,
    required this.contact24Call,
    required this.contactTollFreeMalDisplay,
    required this.contactTollFreeMalCall,
    required this.contactTollFreeIndDisplay,
    required this.contactTollFreeIndCall,
    required this.contactWhatsAppDisplay,
    required this.contactWhatsAppCall,
    required this.email,
    required this.website,
    required this.reg,
    required this.addr1,
    required this.addr2,
    required this.postcode,
    required this.state,
    required this.country,
    required this.companyName,
  });
}