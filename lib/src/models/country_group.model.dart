import 'package:futgolazo/src/models/team.model.dart';

class CountryGroupModel {
  String id;
  String name;
  bool selected;
  List<TeamModel> teamList;

  CountryGroupModel({
    this.id,
    this.name,
    this.selected,
    this.teamList,
  });

  CountryGroupModel.fromJsonMap(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.selected = json['selected'];

    this.teamList = json['teamList'] != null
        ? (json['teamList'] as List)
            .map((i) => TeamModel.fromJsonMap(i))
            .toList()
        : [];
  }
}
