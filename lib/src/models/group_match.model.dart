import './match.model.dart';

class GroupMatchModel {
  int id;
  String description;
  List<MatchModel> matches;

  GroupMatchModel.fromJsonMap(Map<String, dynamic> json) {
    this.id = json['id'];
    this.description = json['description'];

    this.matches = json['matches'] != null
        ? (json['matches'] as List)
            .map((i) => MatchModel.fromJsonMap(i))
            .toList()
        : [];
  }
}
