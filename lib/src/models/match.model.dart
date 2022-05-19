import 'package:flutter/material.dart';

import 'package:futgolazo/src/utils/utils.dart';
import 'package:futgolazo/src/enums/drag_target_enum.dart';
import 'package:futgolazo/src/enums/match-status.enum.dart';

class MatchModel {
  MatchModel({
    this.id,
    this.local,
    this.date,
    this.showStats,
    this.visitant,
    this.matchType,
    this.localTeamLocal,
    this.visitorTeamLocal,
    this.localPetImgUrl,
    this.status,
    this.localPrimaryColor,
    this.localBadgeImgUrl,
    this.visitantPetImgUrl,
    this.visitantPrimaryColor,
    this.matchResult,
    this.visitantBadgeImgUrl,
    this.localScore,
    this.visitantScore,
    this.hasError,
    this.isLastMatch,
    this.prognostic,
  });

  int id;
  String local;
  DateTime date;
  bool showStats;
  String visitant;
  String matchType;
  bool localTeamLocal;
  bool visitorTeamLocal;
  String localPetImgUrl;
  MatchStatusEnum status;
  Color localPrimaryColor;
  String localBadgeImgUrl;
  String visitantPetImgUrl;
  Color visitantPrimaryColor;
  DragTargetEnum matchResult;
  String visitantBadgeImgUrl;

  int localScore;
  int visitantScore;

  // Transient
  bool hasError;
  bool isLastMatch;
  DragTargetEnum prognostic;

  MatchModel.clone(MatchModel matchModel)
      : this(
          id: matchModel.id,
          local: matchModel.local,
          date: matchModel.date,
          showStats: matchModel.showStats,
          visitant: matchModel.visitant,
          matchType: matchModel.matchType,
          localTeamLocal: matchModel.localTeamLocal,
          visitorTeamLocal: matchModel.visitorTeamLocal,
          localPetImgUrl: matchModel.localPetImgUrl,
          status: matchModel.status,
          localPrimaryColor: matchModel.localPrimaryColor,
          localBadgeImgUrl: matchModel.localBadgeImgUrl,
          visitantPetImgUrl: matchModel.visitantPetImgUrl,
          visitantPrimaryColor: matchModel.visitantPrimaryColor,
          matchResult: matchModel.matchResult,
          visitantBadgeImgUrl: matchModel.visitantBadgeImgUrl,
          localScore: matchModel.localScore,
          visitantScore: matchModel.visitantScore,
          hasError: matchModel.hasError,
          isLastMatch: matchModel.isLastMatch,
          prognostic: matchModel.prognostic,
        );

  MatchModel.fromJsonMap(Map<String, dynamic> json) {
    this.id = json['id'];
    this.local = json['local'];
    // this.status = json['status'];
    this.visitant = json['visitant'];
    this.matchType = json['matchType'];
    this.showStats = json['showStats'];
    this.localScore = json['localScore'];
    this.date = json['date'] != null ? DateTime.parse(json['date']) : null;
    this.visitantScore = json['visitantScore'];
    this.localPetImgUrl = json['localPetImgUrl'];
    this.localTeamLocal = json['localTeamLocal'];
    this.visitorTeamLocal = json['visitorTeamLocal'];
    this.localBadgeImgUrl = json['localBadgeImgUrl'];
    this.visitantPetImgUrl = json['visitantPetImgUrl'];
    this.visitantBadgeImgUrl = json['visitantBadgeImgUrl'];

    String matchResultAux = json['matchResult'];
    this.matchResult = matchResultAux == 'L'
        ? DragTargetEnum.LOCAL
        : matchResultAux == 'V'
            ? DragTargetEnum.VISITANT
            : matchResultAux == 'E' ? DragTargetEnum.DRAW : DragTargetEnum.NONE;

    this.localPrimaryColor =
        colorFromHex(json['localPrimaryColor'] ?? '#FF0000');
    this.visitantPrimaryColor =
        colorFromHex(json['visitantPrimaryColor'] ?? '#FFFF00');
  }

  set setPrognostic(String prognostic) {
    this.prognostic = prognostic == 'L'
        ? DragTargetEnum.LOCAL
        : prognostic == 'V' ? DragTargetEnum.VISITANT : DragTargetEnum.DRAW;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "local": local,
        "visitant": this.visitant,
        "matchType": this.matchType,
        "showStats": this.showStats,
        "localScore": this.localScore,
        "visitantScore": this.visitantScore,
        "localPetImgUrl": this.localPetImgUrl,
        "localTeamLocal": this.localTeamLocal,
        "visitorTeamLocal": this.visitorTeamLocal,
        "localBadgeImgUrl": this.localBadgeImgUrl,
        "visitantPetImgUrl": this.visitantPetImgUrl,
        "visitantBadgeImgUrl": this.visitantBadgeImgUrl,
        "matchResult": this.matchResult == DragTargetEnum.LOCAL
            ? 'L'
            : this.matchResult == DragTargetEnum.VISITANT ? 'V' : 'E'
      };
}
