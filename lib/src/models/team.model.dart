import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:futgolazo/src/utils/utils.dart';

class TeamModel {
  int id;
  String logo;
  int country;
  int teamType;
  int leagueSerie;
  String shortName;
  String description;
  Color primaryColor;

  // Transient
  bool selected;

  TeamModel({
    this.id,
    this.logo,
    this.country,
    this.teamType,
    this.shortName,
    this.leagueSerie,
    this.description,
  });

  TeamModel.fromJsonMap(Map<String, dynamic> json) {
    selected = false;
    this.id = json['id'];
    this.logo = json['logo'];
    this.country = json['country'];
    this.teamType = json['teamType'];
    this.shortName = json['shortName'];
    this.leagueSerie = json['leagueSerie'];
    this.description = json['description'];
    this.primaryColor = colorFromHex(json['primaryColor'] ?? '#FF0000');
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "country": country,
        "teamType": teamType,
        "shortName": shortName,
        "leagueSerie": leagueSerie,
        "description": description,
      };
}
