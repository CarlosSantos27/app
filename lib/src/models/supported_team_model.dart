class SupportedTeam {
  int id;
  String logo;
  int country;
  bool active;
  int teamType;
  String petUrl;
  int leagueSerie;
  String description;

  SupportedTeam({
    this.id,
    this.logo,
    this.active,
    this.petUrl,
    this.country,
    this.teamType,
    this.leagueSerie,
    this.description,
  });

  SupportedTeam.fromJsonMap(Map<String,dynamic> json){
    if (json==null) return;
    this.id          = json['id'];
    this.logo        = json['logo'];
    this.active      = json['active'];
    this.petUrl      = json['petUrl'];
    this.country     = json['country'];
    this.teamType    = json['teamType'];
    this.leagueSerie = json['leagueSerie'];
    this.description = json['description'];
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'logo': logo,
      'active': active,
      'petUrl': petUrl,
      'country': country,
      'teamType': teamType,
      'leagueSerie': leagueSerie,
      'description': description
    };
  }

}
