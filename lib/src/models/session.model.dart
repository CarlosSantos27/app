
class Session {
  String accessToken;
  String refreshToken;

  Session({
    this.accessToken,
    this.refreshToken,
  });

  Session.fromJsonMap(Map<String,dynamic> json){
    this.accessToken  = json['accessToken'];
    this.refreshToken = json['refreshToken'];
  }
}