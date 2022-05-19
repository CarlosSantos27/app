class DateRangeMiniCardModel {
  int year;
  int month;
  String description;

  DateRangeMiniCardModel.fromJsonMap(Map<String, dynamic> json) {
    this.year = json['year'];
    this.month = json['month'];
    this.description = json['description'];
  }
}
