class PrognosticDetailModel {
  PrognosticDetailModel({
    this.prognosticValue,
    this.cardDetailValue,
    this.hit,
  });

  String prognosticValue;
  int cardDetailValue;
  bool hit;

  factory PrognosticDetailModel.fromJson(Map<String, dynamic> json) =>
      PrognosticDetailModel(
        prognosticValue: json["prognosticValue"],
        cardDetailValue: json["cardDetailValue"],
        hit: json["hit"],
      );
}
