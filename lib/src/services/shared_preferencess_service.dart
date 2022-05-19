import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences prefs;

  // KEYS
  final String _userData = "userData";
  final String _userIsGuest = "userIsGuest";
  final String _accessToken = "accessToken";
  final String _refreshToken = "refreshToken";
  final String _hasHadLoggin = "hasHadLoggin";
  final String _guestUserTeam = "guestUserTeam";
  final String _activateSounds = 'activateSounds';
  final String _hasHadRegister = "hasHadRegister";
  final String _showCoinsPopup = "showCoinsPopup";
  final String _allowNotification = 'allowNotification';
  final String _isFirstTimeInApp = "isFirstTimeInApp";
  final String _guestUserWonTrivia = "guestUserWonTrivia";
  final String _persisBookUntilRegister = 'persisBookUntilRegister';
  final String _acceptTermsAndConditions = "acceptTermsAndConditions";
  final String _getLastQuestionPlayedGuest = "getLastQuestionPlayedGuest";

  SharedPreferencesService(this.prefs);

  /// ------------------------------------------------------------
  /// Method that returns the Auth Token
  /// ------------------------------------------------------------
  String getAccentToken() {
    return prefs.getString(_accessToken) ?? '';
  }

  /// ------------------------------------------------------------
  /// Method that returns if Refresh Token
  /// ------------------------------------------------------------
  String getRefreshToken() {
    return prefs.getString(_refreshToken) ?? '';
  }

  /// ----------------------------------------------------------
  /// Method that removes the previous auth Token and assign a new one
  /// ----------------------------------------------------------
  Future<bool> setAuthToken(String accessToken, String refreshToken) async {
    await prefs.setString(_refreshToken, refreshToken);
    return prefs.setString(_accessToken, accessToken);
  }

  /// ----------------------------------------------------------
  /// Method that removes the previous auth Token and assign a new one
  /// ----------------------------------------------------------
  Future<bool> setAccentToken(String accessToken) async {
    return await prefs.setString(_accessToken, accessToken);
  }

  /// ------------------------------------------------------------
  /// Method that returns if the guest user has accepted terms and conditions
  /// ------------------------------------------------------------
  bool getIfAcceptTermsAndConditions() {
    return prefs.getBool(_acceptTermsAndConditions) ?? false;
  }

  /// ----------------------------------------------------------
  /// Method that saves that guest user  has accepted terms and conditions
  /// ----------------------------------------------------------
  Future<bool> acceptTermsAndConditions() async {
    return prefs.setBool(_acceptTermsAndConditions, true);
  }

  /// ------------------------------------------------------------
  /// Method that returns if the guest user  has won the first trivia
  /// ------------------------------------------------------------
  int getIfGuestUserWonTrivia() {
    return prefs.getInt(_guestUserWonTrivia) ?? -1;
  }

  /// ----------------------------------------------------------
  /// Method that saves that guest user  has won the first trivia
  /// ----------------------------------------------------------
  Future<bool> guestUserHasWonTrivia(int triviaId) async {
    return prefs.setInt(_guestUserWonTrivia, triviaId);
  }

  /// ------------------------------------------------------------
  /// Method that returns question number of a guest user
  /// ------------------------------------------------------------
  int getLastQuestionPlayedGuest() {
    return prefs.getInt(_getLastQuestionPlayedGuest) ?? 1;
  }

  /// ----------------------------------------------------------
  /// Method that saves the current question number of a guest user
  /// ----------------------------------------------------------
  Future<bool> setLastQuestionPlayedGuest(int currentQuestionNumber) async {
    return prefs.setInt(_getLastQuestionPlayedGuest, currentQuestionNumber);
  }

  /// ------------------------------------------------------------
  /// Method that returns if the user is for the firts time in the app
  /// ------------------------------------------------------------
  bool geIsFirstTimeInApp() {
    return prefs.getBool(_isFirstTimeInApp) ?? true;
  }

  /// ----------------------------------------------------------
  /// Method that saves that user has had visited the app before
  /// ----------------------------------------------------------
  Future<bool> userHasVisitedTheApp() async {
    return prefs.setBool(_isFirstTimeInApp, false);
  }

  /// ------------------------------------------------------------
  /// Method that returns if the user is a guest
  /// ------------------------------------------------------------
  bool getUserIsGuest() {
    return prefs.getBool(_userIsGuest) ?? false;
  }

  /// ----------------------------------------------------------
  /// Method that saves if user is a guest
  /// ----------------------------------------------------------
  Future<bool> setUserIsGuest({bool userIsGuest = true}) async {
    return prefs.setBool(_userIsGuest, userIsGuest);
  }

  /// ------------------------------------------------------------
  /// Method that returns if the user has logged in
  /// ------------------------------------------------------------
  bool getHasHadLoggin() {
    return prefs.getBool(_hasHadLoggin) ?? false;
  }

  /// ----------------------------------------------------------
  /// Method that saves that user has had visited the app before
  /// ----------------------------------------------------------
  Future<bool> userHasHadLoggin() async {
    return prefs.setBool(_hasHadLoggin, true);
  }

  /// ------------------------------------------------------------
  /// Method that returns if the user has had register
  /// ------------------------------------------------------------
  bool getHasHadRegister() {
    return prefs.getBool(_hasHadRegister) ?? false;
  }

  /// ----------------------------------------------------------
  /// Method that saves that user has had visited the app before
  /// ----------------------------------------------------------
  Future<bool> userHasHadRegister() async {
    return prefs.setBool(_hasHadRegister, true);
  }

  /// ----------------------------------------------------------
  /// Method that saves the data user
  /// ----------------------------------------------------------
  set userData(String user) => prefs.setString(_userData, user);

  /// ----------------------------------------------------------
  /// Method that returns the data user
  /// ----------------------------------------------------------
  String get userData => prefs.getString(_userData) ?? '';

  /// ----------------------------------------------------------
  /// Method that returns the satus sound
  /// ----------------------------------------------------------
  bool get statusSound => prefs.getBool(_activateSounds) ?? true;

  /// ----------------------------------------------------------
  /// Method that saves the data user
  /// ----------------------------------------------------------
  set statusSound(bool status) => prefs.setBool(_activateSounds, status);

  /// ----------------------------------------------------------
  /// Method that returns the satus sound
  /// ----------------------------------------------------------
  bool get allowNotification => prefs.getBool(_allowNotification) ?? true;

  /// ----------------------------------------------------------
  /// Method that saves the data user
  /// ----------------------------------------------------------
  set allowNotification(bool status) =>
      prefs.setBool(_allowNotification, status);

  /// ------------------------------------------------------------
  /// Method that returns the selected team of a guest user
  /// ------------------------------------------------------------
  int getGuestUserTeam() {
    return prefs.getInt(_guestUserTeam) ?? -1;
  }

  /// ----------------------------------------------------------
  /// Method that saves the selected team of a guest user
  /// ----------------------------------------------------------
  Future<bool> setGuestUserTeam(int teamId) async {
    return prefs.setInt(_guestUserTeam, teamId);
  }

  /// ----------------------------------------------------------
  /// Method that allows to show o hide popup of information of the coins
  /// ----------------------------------------------------------
  Future<bool> setShowCoinsPopup(bool showCoinsPopup) async {
    return await prefs.setBool(_showCoinsPopup, showCoinsPopup);
  }

  /// ------------------------------------------------------------
  /// Method that returns if the guest user has accepted terms and conditions
  /// ------------------------------------------------------------
  bool getShowCoinsPopup() {
    return prefs.getBool(_showCoinsPopup) ?? true;
  }

  /// ------------------------------------------------------------
  /// Method that returns A String of a Book Model ready to be send when the user could have login session
  /// ------------------------------------------------------------
  String getBookIfUserHasNotRegister() {
    return prefs.getString(_persisBookUntilRegister) ?? '';
  }

  /// ------------------------------------------------------------
  /// Method that returns a boolean if there is a card storaged
  /// ------------------------------------------------------------
  bool checkIfUserHasBookStoraged() {
    String userBook = prefs.getString(_persisBookUntilRegister);
    return userBook != null && userBook.isNotEmpty;
  }

  /// ----------------------------------------------------------
  /// Method that removes the previous auth Token and assign a new one
  /// ----------------------------------------------------------
  Future<bool> saveBookUntilUserLogin(String bookModel) async {
    return prefs.setString(_persisBookUntilRegister, bookModel);
  }

  /// ----------------------------------------------------------
  /// Method that removes a stored Card becouse a user was a Guest
  /// ----------------------------------------------------------
  void removeBookUntilUserLogin() async {
    if (prefs.containsKey(_persisBookUntilRegister))
      prefs.remove(_persisBookUntilRegister);
  }

  void clear() {
    prefs.remove(_accessToken);
    prefs.remove(_userData);
    prefs.remove(_hasHadLoggin);
    prefs.remove(_userIsGuest);
    prefs.remove(_refreshToken);
    prefs.remove(_acceptTermsAndConditions);
  }

  void dispose() {
    prefs.remove(_accessToken);
  }
}
