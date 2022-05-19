import 'dart:convert';
import 'package:futgolazo/src/models/user.model.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import 'data_service.dart';
import './pool_services.dart';
import 'external_auth_services.dart';
import '../networking/api_provider.dart';
import './shared_preferencess_service.dart';
import '../networking/generic_response.dart';
import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/models/register_user.dart';
import 'package:futgolazo/src/models/session.model.dart';
import 'package:futgolazo/src/enums/origin_type.enum.dart';

class AuthService {
  PublishSubject<bool> _isLoggedIn$ = PublishSubject<bool>();

  final ApiProvider _provider;
  final DataService _dataService;
  final SharedPreferencesService _sharedPrefs;
  final ExternalAuthService _externalAuthService;

  AuthService(this._sharedPrefs, this._dataService, this._provider)
      : _externalAuthService = ExternalAuthService();

  Stream<bool> get isLoggedIn$ => _isLoggedIn$;

  /*
	 * Permite autenticarse al usuario
	 * @param loginParams  Datos de autenticación
	 * @return Respuesta http
	 */
  Future<GenericResponse> login(Map<String, dynamic> userMap) async {
    // Metodo para verificar si el usuario en modo incognito escogio un equipo
    _setTeamIfWasSelected(userMap);

    _provider.retry = false;

    final genericResponse =
        await _provider.post("user/login", jsonEncode(userMap));
    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      final Map<String, dynamic> response = genericResponse.data;
      if (response != null && response.isNotEmpty) {
        logout();
        await _setUserDataInServices(response);
        await _setTriviaPassIfUserWasGuest();
        _isLoggedIn$.sink.add(true);
      }
    }
    return genericResponse;
  }

  ///#### Verificar correo de usuario
  ///
  ///Param
  ///- [email] _Correo a verificar_
  ///
  Future<GenericResponse> validateEmailLogin(String email) async {
    _provider.retry = false;
    final genericResponse = await _provider.get("/validate-email?email=$email");
    return genericResponse;
  }

  /*
	 * Permite registrarsee a un usuario
	 * @param loginParams  Datos de autenticación
	 * @return Respuesta http
	 */
  Future<GenericResponse> register(RegisterUser user) async {
    Map<String, dynamic> userMap = user.toJson();
    // Metodo para verificar si el usuario en modo incognito escogio un equipo
    _setTeamIfWasSelected(userMap);

    final genericResponse = await _provider.post("user", jsonEncode(userMap));
    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      final Map<String, dynamic> response = genericResponse.data;
      if (response != null && response.isNotEmpty) {
        logout();
        await _setUserDataInServices(response);
        await _setTriviaPassIfUserWasGuest();
        _isLoggedIn$.sink.add(true);
      }
    }
    return genericResponse;
  }

  /*
	 * Permite autenticarse con un usuario de una red social o si no existe registrarse
	 * @param loginParams  Datos de autenticación
	 * @return Respuesta http
	 */
  Future<GenericResponse> loginRegister(Map<String, dynamic> userMap) async {
    // Metodo para verificar si el usuario en modo incognito escogio un equipo
    _setTeamIfWasSelected(userMap);

    final genericResponse =
        await _provider.post("user/sign-in", jsonEncode(userMap));
    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      final Map<String, dynamic> response = genericResponse.data;
      logout();
      response['email'] = userMap["email"];
      if (response != null && response.isNotEmpty) {
        await _setUserDataInServices(response);
        await _setTriviaPassIfUserWasGuest();
        _isLoggedIn$.sink.add(true);
      }
    }
    return genericResponse;
  }

  /*
	 * Permite a los usuarios registrados con redes sociales puedan acceptar terminos y condiciones
	 * @return Respuesta http
	 */
  Future<GenericResponse> registerAcceptTermsConditions() async {
    final acceptTermsObj = {
      "acceptTerms": true,
    };
    final gResp =
        await _provider.post("user/update", jsonEncode(acceptTermsObj));
    if (gResp.status == GenericResponseStatus.COMPLETED) {
      _sharedPrefs.acceptTermsAndConditions();
    }
    return gResp;
  }

  /*
	 * Permite autenticarse al usuario cuando su token a fenecido
	 * @return Respuesta http
	 */
  Future<bool> tryAgain() async {
    String refreshToken = _sharedPrefs.getRefreshToken();

    final genericResponse = await _provider.post(
        'user/access', jsonEncode({'refreshToken': refreshToken}));
    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      final Map<String, dynamic> response = genericResponse.data;

      if (response != null && response.isNotEmpty) {
        await _sharedPrefs.setAccentToken(response['accessToken']);
        _isLoggedIn$.sink.add(true);
      }
      return response != null && response.isNotEmpty;
    } else {
      return false;
    }
  }

  /*
	 * Trae información del usuario 
	 * @return Respuesta http
	 */
  Future<bool> getLastUserInfo() async {
    final genericResponse = await _provider.get('user-data');
    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      final Map<String, dynamic> response = genericResponse.data;
      if (response != null && response.isNotEmpty) {
        await _setUserDataInServices(response);
      }
      return response != null && response.isNotEmpty;
    } else {
      return false;
    }
  }

  /*
	* Servicio de envio de otp
	*/
  Future<GenericResponse> sendOTP(dynamic data) async {
    final genericResponse = await _provider.post("sms/otp", data);
    return genericResponse;
  }

  /*
	 * Verifica la cuenta mediante otp
	 * @return Respuesta http
	 */
  Future<GenericResponse> verifyOTPAccount(dynamic data) async {
    final genericResponse = await _provider.put("sms/verifications", data);
    return genericResponse;
  }

  String getAutToken() {
    return _sharedPrefs.getAccentToken();
  }

  void logout() {
    _dataService.clear();
    _sharedPrefs.clear();
    _externalAuthService.logoutGoogle();
    _isLoggedIn$.sink.add(false);
  }

  String getInitialRoute() {
    String result = NavigationRoute.HOME;

    bool firstTimeInApp = _sharedPrefs.geIsFirstTimeInApp();

    if (firstTimeInApp) {
      result = NavigationRoute.INTRO;
    } else {
      if (!_sharedPrefs.getIfAcceptTermsAndConditions()) {
        // result = NavigationRoute.ACCEPT_REQUIREMENTS;
        result = NavigationRoute.INTRO;
      } else if (_sharedPrefs.getHasHadLoggin()) {
        result = NavigationRoute.LOADING;
      } else {
        bool userIsGuest = _sharedPrefs.getUserIsGuest();
        if (userIsGuest) {
          var user =
              UserModel.fromJsonMap(json.decode(this._sharedPrefs.userData));
          user.isGuestUser = true;
          this._dataService.setUserData(user);
        } else {
          result = NavigationRoute.INTRO;
        }
      }
    }
    return result;
  }

  Future _setUserDataInServices(Map<String, dynamic> resultMap) async {
    if (resultMap.keys.contains('session')) {
      Session session = Session.fromJsonMap(resultMap['session']);
      await this
          ._sharedPrefs
          .setAuthToken(session.accessToken, session.refreshToken);
    }
    UserModel user = UserModel.fromJsonMap(resultMap);
    await GetIt.I<PoolServices>()
        .pushNotificationProvider
        .configTopic(user.allowPushNotification);
    GetIt.I<PoolServices>().sharedPrefsService?.allowNotification =
        user.allowPushNotification;
    //Sets the user data
    this._dataService.setUserData(user);
    this._sharedPrefs.userData = jsonEncode(user.toJson());
    this._sharedPrefs.userHasVisitedTheApp();
    this._sharedPrefs.userHasHadLoggin();
    if (user != null && user.acceptTerms) {
      this._sharedPrefs.acceptTermsAndConditions();
    }
  }

  dispose() {
    _isLoggedIn$.close();
  }

  Future<void> _setTriviaPassIfUserWasGuest() async {
    bool userIsGuest = _sharedPrefs.getUserIsGuest();
    if (userIsGuest) {
      int triviaIdIfUserWonTrivia = _sharedPrefs.getIfGuestUserWonTrivia();
      if (triviaIdIfUserWonTrivia > 0) {
        final genericResponse = await _provider.put(
          "save-won-trivia",
          jsonEncode({"triviaId": triviaIdIfUserWonTrivia}),
        );
        if (genericResponse != null &&
            genericResponse.status == GenericResponseStatus.COMPLETED) {
          _sharedPrefs.setUserIsGuest(userIsGuest: false);
          _sharedPrefs.guestUserHasWonTrivia(-1);
        }
      }
    }
  }

  Future<GenericResponse> signInWithGoogle() async {
    GetIt.I<PoolServices>().loadingService.showLoadingScreen();
    var genericResponse = await _externalAuthService.signInWithGoogle();

    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      final data = genericResponse.data;
      data['firebaseToken'] =
          GetIt.I<PoolServices>().pushNotificationProvider.tokenFCM;
      data['acceptTerms'] = GetIt.I<PoolServices>()
          .sharedPrefsService
          .getIfAcceptTermsAndConditions();
      genericResponse = await this.loginRegister(data);
    }
    GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
    return genericResponse;
  }

  Future<GenericResponse> signWithFacebook() async {
    GetIt.I<PoolServices>().loadingService.showLoadingScreen();
    var genericResponse = await _externalAuthService.signWithFacebook();

    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      final loginObject = {
        "origin": OriginTypeEnum.FACEBOOK.index,
        "email": genericResponse.data['email'],
        "firstName": genericResponse.data['first_name'],
        "lastName": genericResponse.data['last_name'],
        "idToken": genericResponse.data['access_token'],
        "password": genericResponse.data['access_token'],
        "firebaseToken":
            GetIt.I<PoolServices>().pushNotificationProvider.tokenFCM,
        "acceptTerms": GetIt.I<PoolServices>()
            .sharedPrefsService
            .getIfAcceptTermsAndConditions(),
      };
      genericResponse = await this.loginRegister(loginObject);
    }
    GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
    return genericResponse;
  }

  Future<GenericResponse> signWithAppleId() async {
    GetIt.I<PoolServices>().loadingService.showLoadingScreen();
    var genericResponse = await _externalAuthService.siginWithAppleId();

    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      final loginObject = {
        "origin": OriginTypeEnum.APPLE.index,
        "email": genericResponse.data.credential.email,
        "firstName": genericResponse.data.credential.fullName.givenName,
        "lastName": genericResponse.data.credential.fullName.familyName,
        "idToken": genericResponse.data.credential.identityToken,
        "password": genericResponse.data.credential.identityToken,
        "firebaseToken":
            GetIt.I<PoolServices>().pushNotificationProvider.tokenFCM,
        "acceptTerms": GetIt.I<PoolServices>()
            .sharedPrefsService
            .getIfAcceptTermsAndConditions(),
      };
      genericResponse = await this.loginRegister(loginObject);
    }
    GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
    return genericResponse;
  }

  /*
   * Proceso para enviar al mail una nueva contraseña 
   */
  Future<GenericResponse> restorePassword(String email) async {
    final param = jsonEncode({'email': email});

    final genericResponse = await _provider.post('user/recover', param);
    return genericResponse;
  }

  /*
   * Proceso para cambiar la contraseña
   */
  Future<GenericResponse> changePassword(
      String email, String password, String newPassword) async {
    final param = jsonEncode(
        {'email': email, 'password': password, 'newPassword': newPassword});
    final genericResponse = await _provider.post('user/changepassword', param);
    return genericResponse;
  }

  /*
   * Metodo que permite agregar un equipo seleccionado en modo incognito y agreparlo al mapa de registro o logeo
   */
  void _setTeamIfWasSelected(Map<String, dynamic> userMap) {
    final int teamId = _sharedPrefs.getGuestUserTeam();
    if (teamId > 0) {
      userMap.putIfAbsent('supportedTeamId', () => teamId);
      _sharedPrefs.setGuestUserTeam(-1);
    }
  }
}
