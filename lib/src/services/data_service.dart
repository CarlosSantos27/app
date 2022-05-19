import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';

import '../models/user.model.dart';
import '../models/user_coins_balance.model.dart';
import '../services/shared_preferencess_service.dart';

class DataService {
  final _user$ = BehaviorSubject<UserModel>();
  final SharedPreferencesService _prefs;

  DataService(this._prefs);

  UserModel get user => _user$.value;
  Stream<UserModel> get user$ => _user$.stream;

  final _settings$ = BehaviorSubject<bool>();
  Stream<bool> get settings$ => _settings$.stream;
  Function(bool) get settings => _settings$.add;
  bool get settingsStatus => _settings$.value;

  void initialize() {
    settings(false);
    if (this._prefs.getHasHadLoggin()) {
      this.setUserData(UserModel.fromJsonMap(jsonDecode(this._prefs.userData)));
    }
  }

  void changePlayerByBalance(UserCoinsBalanceModel balance) {
    if (balance.goldCoins != null) {
      _user$.value.goldCoins = balance.goldCoins;
    }

    if (balance.diamondCoins != null) {
      _user$.value.diamondCoins = balance.diamondCoins;
    }
    _user$.add(_user$.value);
  }

  void changePlayerByCoins({int goldCoins = -1, int diamondCoins = -1}) {
    bool thereIsAChange = false;
    if (goldCoins != null && goldCoins >= 0) {
      thereIsAChange = true;
      _user$.value.goldCoins = goldCoins;
    }
    if (diamondCoins != null && diamondCoins >= 0) {
      thereIsAChange = true;
      _user$.value.diamondCoins = diamondCoins;
    }
    if (thereIsAChange) _user$.add(_user$.value);
  }

  void playAsGuest() {
    _prefs.setUserIsGuest();
    _prefs.userHasVisitedTheApp();
    var guestUser = UserModel.guest();
    this.setUserData(guestUser);
    _prefs.userData = jsonEncode(guestUser.toJson());
  }

  bool get isGuestUser {
    return _user$.value.isGuestUser;
  }

  void clear() {
    _user$.sink.add(null);
  }

  void dispose() {
    _user$.close();
    _settings$.close();
  }

  void setUserData(UserModel user) {
    _user$.add(user);
  }
}
