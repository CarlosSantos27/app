import 'package:enum_to_string/enum_to_string.dart';
import 'package:futgolazo/src/enums/coin_type.enum.dart';
import 'package:futgolazo/src/models/prognostic_detail.model.dart';

List<PrognosticModel> prognosticsModelFromDynamicList(List<dynamic> entities) {
  List<PrognosticModel> list = [];
  entities.forEach((entity) => list.add(PrognosticModel.fromJson(entity)));
  return list;
}

class PrognosticModel {
  PrognosticModel({
    this.id,
    this.code,
    this.creationDate,
    this.totalHits,
    this.prize,
    this.prognostics,
    this.coinType,
  });

  int id;
  int code;
  DateTime creationDate;
  int totalHits;
  bool prize;
  List<PrognosticDetailModel> prognostics;
  CoinTypeEnum coinType;

  factory PrognosticModel.fromJson(Map<String, dynamic> json) =>
      PrognosticModel(
        id: json["id"],
        code: json["code"],
        creationDate: json["creationDate"] != null
            ? DateTime.parse(json["creationDate"])
            : null,
        totalHits: json["totalHits"],
        prize: json["prize"],
        prognostics: List<PrognosticDetailModel>.from(
            json["prognostics"].map((x) => PrognosticDetailModel.fromJson(x))),
        coinType:
            EnumToString.fromString(CoinTypeEnum.values, json["coinType"]),
      );
}
