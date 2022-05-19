import 'package:flutter/material.dart';

import './country.model.dart';

class RegisterUser {
  int teamId;
  final int origin;
  final String email;
  final String phone;
  final bool adult;
  final String password;
  final String lastName;
  final String username;
  final String firstName;
  final bool acceptTerms;
  final String repeatpass;
  final String firebaseToken;
  final String promotionalCode;
  final CountryInfo countryInfo;
  final bool allowEmailNotifications;

  RegisterUser({
    this.teamId,
    this.origin = 1,
    @required this.adult,
    @required this.phone,
    @required this.email,
    @required this.username,
    @required this.password,
    @required this.lastName,
    @required this.firstName,
    @required this.repeatpass,
    @required this.countryInfo,
    @required this.acceptTerms,
    @required this.firebaseToken,
    @required this.promotionalCode,
    @required this.allowEmailNotifications,
  });

  Map<String, dynamic> toJson() => {
        "adult":adult,
        "phone": phone,
        "email": email,
        "origin": origin,
        "teamId": teamId,
        "username":username,
        "password": password,
        "lastName": lastName,
        "firstName": firstName,
        "repeatpass": repeatpass,
        "acceptTerms": acceptTerms,
        "firebaseToken": firebaseToken,
        "promotionalCode": promotionalCode,
        "countryInfo": countryInfo.toJson(),
        "allowEmailNotifications":allowEmailNotifications
      };
}
