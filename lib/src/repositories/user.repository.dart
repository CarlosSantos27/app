import 'dart:convert';
import 'package:get_it/get_it.dart';

import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/networking/api_provider.dart';
import 'package:futgolazo/src/models/country_group.model.dart';
import 'package:futgolazo/src/networking/generic_response.dart';
import 'package:futgolazo/src/models/user_coins_balance.model.dart';

class UserRepository {
  ApiProvider _provider;

  UserRepository() {
    _provider = GetIt.I<PoolServices>().restApi;
  }

  Future<bool> phoneIsValid(String phone, String countryCode) async {
    bool result = false;
    final genericResponse = await _provider.get(
        '/phone-number-validation?phoneNumber=$phone&countryCode=$countryCode');
    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      result = genericResponse.data.toString().toLowerCase() == 'true';
    }
    return result;
  }

  Future<UserCoinsBalanceModel> getUserBalance() async {
    UserCoinsBalanceModel result;
    final genericResponse = await _provider.get('/player/balance');
    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      result = UserCoinsBalanceModel.fromJsonMap(genericResponse.data);
    }
    return result;
  }

  Future<List<CountryGroupModel>> getCountryTeams() async {
    List<CountryGroupModel> result = [];
    final genericResponse = await _provider.get('/teams-by-country-list');
    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      genericResponse.data.forEach((item) {
        result.add(CountryGroupModel.fromJsonMap(item));
      });
    } else if (genericResponse.errorStatus == 0) {
      throw ('Tenemos inconvenientes revisa tu conexión a Internet');
    }
    return result;
  }

  Future<GenericResponse> getRaking({
    int pageNumber = 1,
    int pageSize = 30,
  }) async {
    final genericResponse = await _provider.get(
        '/users-feature-ranking?featureName=competicion trivia futgolazo&featureRecordId=3&pageNumber=$pageNumber&pageSize=$pageSize');
    return genericResponse;
  }

  Future<GenericResponse> getGuestRaking({
    int pageNumber = 1,
    int pageSize = 30,
  }) async {
    final genericResponse = await _provider.get(
        '/users-general-ranking?featureName=competicion trivia futgolazo&featureRecordId=3&pageNumber=$pageNumber&pageSize=$pageSize');
    return genericResponse;
  }

  Future<GenericResponse> saveSelectedTeam(int teamId) async {
    var params = {'supportedTeamId': teamId};
    final genericResponse =
        await _provider.post('/user/update', jsonEncode(params));

    return genericResponse;
  }

  Future<GenericResponse> getUserProfile(String email) async {
    return await _provider.post('user/profile', jsonEncode({"email": email}));
  }

  Future<GenericResponse> allowNotification(bool status) async {
    return await _provider.put(
        'update-notifications-permission?allowPushNotification=$status',
        jsonEncode({"allowPushNotification": status}));
  }
}
