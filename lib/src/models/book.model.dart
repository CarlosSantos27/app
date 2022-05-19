import 'package:futgolazo/src/models/country.model.dart';
import 'package:futgolazo/src/utils/date_for_human.dart';

import './group_match.model.dart';
import 'package:futgolazo/src/models/match.model.dart';
import 'package:futgolazo/src/enums/book_type.enum.dart';
import 'package:futgolazo/src/enums/coin_type.enum.dart';
import 'package:futgolazo/src/enums/book_status.enum.dart';

class BookModel {
  int id;
  int number;
  bool isClosed;
  bool isCurrent;
  DateTime dateTo;
  DateTime dateFrom;
  String description;
  BookStatusEnum status;
  CoinTypeEnum coinType;
  CountryInfo countryInfo;
  List<GroupMatchModel> groupList;
  DateTime firstMatchTime;

  // TRANSIENT
  BookTypeEnum cardTypeId;
  List<MatchModel> matches;

  DateForHuman dateHuman;

  BookModel.fromJsonMap(Map<String, dynamic> json) {
    this.id = json['id'];
    this.status = json['status'];
    this.number = json['number'];
    this.coinType = json['coinType'];
    this.isClosed = json['isClosed'];
    this.isCurrent = json['isCurrent'];
    this.description = json['description'];
    this.firstMatchTime = json['firstMatchTime'] != null
        ? DateTime.parse(json['firstMatchTime'])
        : null;
    this.countryInfo = json['countryInfo'] != null
        ? CountryInfo.fromJsonMap(json['countryInfo'])
        : null;

    var dateToAux = json['dateTo'];
    if (dateToAux != null && dateToAux != '') {
      this.dateTo = DateTime.parse(dateToAux);
    }

    dateToAux = json['dateFrom'];
    if (dateToAux != null && dateToAux != '') {
      this.dateFrom = DateTime.parse(dateToAux);
    }

    this.groupList = json['groupList'] != null
        ? (json['groupList'] as List)
            .map((i) => GroupMatchModel.fromJsonMap(i))
            .toList()
        : [];

    this.matches = json['matches'] != null
        ? (json['matches'] as List)
            .map((i) => MatchModel.fromJsonMap(i))
            .toList()
        : [];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
      };

  extractMatchesFromGroupList() {
    List<MatchModel> resultMatches = [];
    this.groupList.forEach((item) {
      item.matches.forEach((match) => resultMatches.add(match));
    });
    this.matches = resultMatches;
  }
}
