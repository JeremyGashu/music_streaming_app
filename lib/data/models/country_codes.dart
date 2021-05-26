class CountryCode {
  String name;
  String dialCode;

  CountryCode({this.name, this.dialCode});

  factory CountryCode.fromJson(Map<String, dynamic> json) {
    return CountryCode(name: json['name'], dialCode: json['dial_code']);
  }
}
