import 'dart:async';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:get_it/get_it.dart';

import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/models/team.model.dart';
import 'package:futgolazo/src/bloc/base/base_bloc.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/models/country_group.model.dart';
import 'package:futgolazo/src/networking/generic_response.dart';
import 'package:futgolazo/src/repositories/user.repository.dart';

class UserTeamBloc extends BaseBloc {
  final _teamList$ = PublishSubject<List<TeamModel>>();
  final _countriesStream$ = PublishSubject<List<CountryGroupModel>>();

  UserRepository _userRepository;
  CountryGroupModel _selectedCountry;
  List<CountryGroupModel> _allTeamList;

  UserTeamBloc() {
    _userRepository = UserRepository();
    _initBlock();
  }

  CountryGroupModel get selectedCountry => _selectedCountry;
  Stream<List<TeamModel>> get teamsStream => _teamList$.stream;
  Stream<List<CountryGroupModel>> get countriesStream =>
      _countriesStream$.stream;

  @override
  void dispose() {
    _teamList$.close();
    _countriesStream$.close();
  }

  void setCountryGroup(CountryGroupModel country) {
    for (var i = 0; i < _allTeamList.length; i++) {
      if (_allTeamList[i].id == country.id) {
        _allTeamList[i].selected = true;
      } else {
        _allTeamList[i].selected = false;
      }
    }
    _setCountryGroup(country);
    _countriesStream$.add(_allTeamList);
  }

  void saveSalectedTeam(TeamModel setectedTeam) async {
    final int selectedTeamId = setectedTeam?.id ?? 0;

    if (selectedTeamId > 0) {
      final user = GetIt.I<PoolServices>().dataService.user;
      if (user == null) {
        Get.toNamed(NavigationRoute.HOME);
      } else if (user.isGuestUser) {
        GetIt.I<PoolServices>()
            .sharedPrefsService
            .setGuestUserTeam(selectedTeamId);
        user.supportedTeam = setectedTeam;
        GetIt.I<PoolServices>().dataService.setUserData(user);
        Get.toNamed(NavigationRoute.START_MENU);
      } else {
        GenericResponse resp =
            await _userRepository.saveSelectedTeam(selectedTeamId);
        if (resp.status == GenericResponseStatus.COMPLETED) {
          user.supportedTeam = setectedTeam;
          GetIt.I<PoolServices>().dataService.setUserData(user);
          Get.back();
        }
      }
    }
  }

  void _initBlock() async {
    GetIt.I<PoolServices>().loadingService.showLoadingScreen();
    try {
      _allTeamList = await _userRepository.getCountryTeams();
      _setTeamsFromGroups(_allTeamList);
    } catch (e) {
      _teamList$.addError(e.toString());
    }
    GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
  }

  void _setTeamsFromGroups(List<CountryGroupModel> groupTeams) {
    CountryGroupModel country;
    for (var i = 0; i < groupTeams.length; i++) {
      if (groupTeams[i].selected) {
        country = groupTeams[i];
        break;
      }
    }
    _setCountryGroup(country);
    _countriesStream$.add(groupTeams);
  }

  void _setCountryGroup(CountryGroupModel country) {
    _selectedCountry = country;
    _teamList$.add(country.teamList);
  }
}
