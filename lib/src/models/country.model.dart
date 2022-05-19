class CountryInfo {
  String id;
  String name;
  bool selected;
  String phoneCode;
  String countryCode;

  CountryInfo({
    this.id,
    this.name,
    this.selected,
    this.phoneCode,
    this.countryCode,
  });

  CountryInfo.fromJsonMap(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.selected = json['selected'];
    this.phoneCode = json['phoneCode'];
    this.countryCode = json['countryCode'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "selected": selected,
        "phoneCode": phoneCode,
        "countryCode": countryCode,
      };
}
