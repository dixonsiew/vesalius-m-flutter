class Country {

  String countryCode;
  String countryName;
  String? telCode;

  Country({
    required this.countryCode,
    required this.countryName,
    this.telCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      countryCode: json['countryCode'],
      countryName: json['countryName'],
      telCode: json['telCode'],
    );
  }
}

class CountryTel {

  String countryName;
  String? telCode;

  CountryTel({
    required this.countryName,
    this.telCode,
  });

  factory CountryTel.fromJson(Map<String, dynamic> json) {
    return CountryTel(
      countryName: json['countryName'],
      telCode: json['telCode'],
    );
  }
}