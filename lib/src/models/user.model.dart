import 'package:futgolazo/src/models/trivia_profile_info.model.dart';

import 'team.model.dart';
import 'country.model.dart';

class UserModel {
  int type;
  int score;
  String url;
  int origin;
  int ranking;
  String phone;
  String email;
  int goldCoins;
  String password;
  String lastName;
  bool isVerified;
  bool acceptTerms;
  String firstName;
  String birthDate;
  bool dataUpdated;
  int diamondCoins;
  int tutorialStep;
  int diamondScore;
  bool facebookUser;
  int sharesBalance;
  String creationDate;
  TeamModel supportedTeam;
  bool isProfileFulfilled;
  CountryInfo countryInfo;
  double currentUSDBalance;
  TriviaProfileInfo trivia;
  bool areaDeportivaTeamUser;
  bool allowPushNotification;
  bool allowEmailNotifications;

  //TRANSIENT PROPERTIES
  bool isGuestUser;

  UserModel({
    this.url,
    this.type,
    this.score,
    this.phone,
    this.email,
    this.origin,
    this.ranking,
    this.lastName,
    this.password,
    this.goldCoins,
    this.birthDate,
    this.firstName,
    this.isVerified,
    this.acceptTerms,
    this.countryInfo,
    this.dataUpdated,
    this.facebookUser,
    this.diamondCoins,
    this.tutorialStep,
    this.diamondScore,
    this.creationDate,
    this.sharesBalance,
    this.supportedTeam,
    this.currentUSDBalance,
    this.isProfileFulfilled,
    this.allowPushNotification,
    this.areaDeportivaTeamUser,
    this.allowEmailNotifications,
  });

  UserModel.guest() {
    this.ranking = 0;
    this.goldCoins = 0;
    this.diamondCoins = 0;
    this.isVerified = false;
    this.isGuestUser = true;
    this.acceptTerms = false;
    this.firstName = 'Usuario';
    this.lastName = 'invitado';
    this.currentUSDBalance = 0.0;
    this.supportedTeam = TeamModel(
      logo: 'Futgolazo',
      description: 'Futgolazo',
    );
  }

  UserModel.fromJsonMap(Map<String, dynamic> json) {
    this.url = json['url'];
    this.type = json['type'];
    this.score = json['score'];
    this.email = json['email'];
    this.phone = json['phone'];
    this.origin = json['origin'];
    this.password = json['password'];
    this.lastName = json['lastName'];
    this.firstName = json['firstName'];
    this.goldCoins = json['goldCoins'];
    this.birthDate = json['birthDate'];
    this.ranking = json['ranking'] ?? 0;
    this.isVerified = json['isVerified'];
    this.dataUpdated = json['dataUpdated'];
    this.acceptTerms = json['acceptTerms'];
    this.tutorialStep = json['tutorialStep'];
    this.diamondScore = json['diamondScore'];
    this.facebookUser = json['facebookUser'];
    this.creationDate = json['creationDate'];
    this.sharesBalance = json['sharesBalance'];
    this.diamondCoins = json['diamondCoins'] ?? 0;
    this.isProfileFulfilled = json['isProfileFulfilled'];
    this.currentUSDBalance = json['currentUSDBalance'] ?? 0.0;
    this.areaDeportivaTeamUser = json['areaDeportivaTeamUser'];
    this.trivia = TriviaProfileInfo.fromJsonMap(json['trivia']);
    this.allowEmailNotifications = json['allowEmailNotifications'];
    this.allowPushNotification = json['allowPushNotification'] ?? true;

    this.countryInfo =
        json.containsKey('countryInfo') && json['countryInfo'] != null
            ? CountryInfo?.fromJsonMap(json['countryInfo'])
            : null;
    this.supportedTeam =
        json.containsKey('supportedTeam') && json['supportedTeam'] != null
            ? TeamModel?.fromJsonMap(json['supportedTeam'])
            : TeamModel(
                logo: 'Futgolazo',
                description: 'Futgolazo',
              );

    this.isGuestUser =
        json['isGuestUser'] != null ? json['isGuestUser'] : false;
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "diamondCoins": diamondCoins,
        "goldCoins": goldCoins,
        "type": type,
        "url": url,
        "firstName": firstName,
        "lastName": lastName,
        "ranking": ranking,
        "birthDate": birthDate,
        "phone": phone,
        "origin": origin,
        "tutorialStep": tutorialStep,
        "score": score,
        "diamondScore": diamondScore,
        "isProfileFulfilled": isProfileFulfilled,
        "sharesBalance": sharesBalance,
        "isVerified": isVerified,
        "acceptTerms": acceptTerms,
        "allowEmailNotifications": allowEmailNotifications,
        "dataUpdated": dataUpdated,
        "facebookUser": facebookUser,
        "areaDeportivaTeamUser": areaDeportivaTeamUser,
        "countryInfo": countryInfo?.toJson(),
        "supportedTeam": supportedTeam?.toJson()
      };
}
