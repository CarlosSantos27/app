import 'package:futgolazo/src/utils/date_for_human.dart';

class ResumeBookModel {
  int cardId;
  int cardCount;
  int cardTypeId;
  bool available;
  String countryCode;
  double prizeAmount;
  DateTime endDateTime;
  String cardDescription;

  DateForHuman dateHuman;

  ResumeBookModel({
    this.cardId,
    this.available,
    this.cardCount,
    this.cardTypeId,
    this.prizeAmount,
    this.endDateTime,
    this.countryCode,
    this.cardDescription,
  });

  factory ResumeBookModel.fromJson(Map<String, dynamic> json) =>
      ResumeBookModel(
        cardId: json['cardId'],
        available: json['available'] ?? false,
        cardCount: json['cardCount'] ?? 0,
        cardTypeId: json['cardTypeId'],
        prizeAmount: json['prizeAmount'] != null
            ? double.parse(json['prizeAmount'].toString())
            : 0.0,
        endDateTime: json['endDateTime'] != null
            ? DateTime.parse(json['endDateTime'].toString())
            : null,
        countryCode: json['countryCode'],
        cardDescription: json['cardDescription'],
      );
}
