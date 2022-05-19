import 'dart:convert';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:http/http.dart' as http;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:futgolazo/src/enums/origin_type.enum.dart';
import 'package:futgolazo/src/networking/generic_response.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class ExternalAuthService {
  ExternalAuthService();

  Future<GenericResponse> signInWithGoogle() async {
    GenericResponse genericResponse;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount googleSignInAccount;
    try {
      googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final response = await http.get(
          'https://people.googleapis.com/v1/people/${googleSignInAccount.id}?personFields=names',
          headers: await googleSignInAccount.authHeaders,
        );

        final profile = json.decode(response.body);
        profile['idToken'] = googleSignInAuthentication.idToken;
        profile['origin'] = OriginTypeEnum.GOOGLE;

        final dataProfile = {
          "email": googleSignInAccount.email,
          "origin": OriginTypeEnum.GOOGLE.index,
          "password": googleSignInAuthentication.accessToken,
          "firstName": profile['names'][0]['givenName'],
          "lastName": profile['names'][0]['familyName'],
          "idToken": googleSignInAuthentication.idToken,
        };
        genericResponse = GenericResponse.completed(dataProfile);
      } else {
        genericResponse = GenericResponse.error('cancelledByUser', 1);
      }
    } catch (error) {
      print('on error custom $error');
      genericResponse = GenericResponse.error('Error: ${error.toString()}', 1);
    }

    return genericResponse;
  }

  Future<GenericResponse> signWithFacebook() async {
    GenericResponse genericResponse;
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,short_name,email&access_token=$token');
        final profile = json.decode(graphResponse.body);
        profile['access_token'] = token;
        genericResponse = GenericResponse.completed(profile);
        break;
      case FacebookLoginStatus.cancelledByUser:
        genericResponse = GenericResponse.error('cancelledByUser', 0);
        break;
      case FacebookLoginStatus.error:
        genericResponse =
            GenericResponse.error('Facebook error ${result.errorMessage}', 2);
        break;
    }
    return genericResponse;
  }

  Future<GenericResponse<AuthorizationResult>> siginWithAppleId() async {
    GenericResponse<AuthorizationResult> genericResponse;
    if (await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.cancelled:
          throw GenericResponse.error('Cancelado por el usuario', 3);
          break;
        case AuthorizationStatus.error:
          throw GenericResponse.error(
              'Apple error ${result.error.localizedDescription}', 3);
          break;
        case AuthorizationStatus.authorized:
          genericResponse = GenericResponse.completed(result);
          break;
        default:
          genericResponse = GenericResponse.error('Estado no reconocido', 3);
          break;
      }
    } else {
      genericResponse = GenericResponse.error(
          'El registro con Apple no se encuentra disponible', 3);
    }
    return genericResponse;
  }

  Future<bool> logoutGoogle() async {
    try {
      final facebookLogin = FacebookLogin();
      await facebookLogin.logOut();
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
