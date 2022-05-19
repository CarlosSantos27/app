import 'dart:collection';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../env/env.router.dart';

import 'generic_response.dart';
import '../routes/routes.dart';
import '../services/pool_services.dart';
import '../services/auth_services.dart';

class ApiProvider {
  AuthService authService;
  String _baseUrl;
  final _secondsDurationTimeOut = 12;
  bool _retry = true;

  set retry(bool value) {
    _retry = value;
  }

  String get url => _baseUrl;

  init(AuthService authService, EnvironmentConfig env) {
    this.authService = authService;
    this._baseUrl = env.environment.apiPath;
  }

  Future<GenericResponse> get<T>(String url) async {
    GenericResponse result;
    try {
      Map<String, String> _headers = {
        "Content-Type": "application/json",
      };

      if (authService.getAutToken().isNotEmpty) {
        _headers.putIfAbsent("Authorization", () => authService.getAutToken());
      }
      final response = await http
          .get(_baseUrl + url, headers: _headers)
          .timeout(Duration(seconds: _secondsDurationTimeOut));
      result = await _buildResponse(response);
    } on TimeoutException {
      result = GenericResponse.error('No Internet connection', 0);
    } on SocketException {
      result = GenericResponse.error('No Internet connection', 0);
    }
    return result;
  }

  Future<GenericResponse> post(String url, dynamic data,
      {Map<String, String> headers}) async {
    GenericResponse result;
    try {
      Map<String, String> _headers = headers ?? new HashMap();
      _headers.putIfAbsent("Content-Type", () => "application/json");

      if (authService.getAutToken().isNotEmpty) {
        _headers.putIfAbsent("Authorization", () => authService.getAutToken());
      }

      print("token"+authService.getAutToken());

      var response = await http
          .post(_baseUrl + url, body: data, headers: _headers)
          .timeout(Duration(seconds: _secondsDurationTimeOut));
      result = await _buildResponse(response, data);
    } on TimeoutException {
      result = GenericResponse.error('No Internet connection', 0);
    } catch (error) {
      print('POST error: $error');
      result = GenericResponse.error('No Internet connection', 0);
    }
    return result;
  }

  Future<GenericResponse> put(String url, dynamic data) async {
    GenericResponse result;
    try {
      Map<String, String> _headers = {
        "Content-Type": "application/json",
      };

      if (authService.getAutToken().isNotEmpty) {
        _headers.putIfAbsent("Authorization", () => authService.getAutToken());
      }

      var response = await http
          .put(_baseUrl + url, body: data, headers: _headers)
          .timeout(Duration(seconds: _secondsDurationTimeOut));
      result = await _buildResponse(response, data);
    } on TimeoutException {
      result = GenericResponse.error('No Internet connection', 0);
    } catch (error) {
      print('Put error: $error');
      result = GenericResponse.error('No Internet connection', 0);
    }
    return result;
  }

  Future<GenericResponse> delete(String url, dynamic data) async {
    GenericResponse result;
    try {
      Map<String, String> _headers = {
        "Content-Type": "application/json",
      };

      if (authService.getAutToken().isNotEmpty) {
        _headers.putIfAbsent("Authorization", () => authService.getAutToken());
      }

      var response = await http
          .delete(_baseUrl + url, headers: _headers)
          .timeout(Duration(seconds: _secondsDurationTimeOut));
      result = await _buildResponse(response, data);
    } on TimeoutException {
      result = GenericResponse.error('No Internet connection', 0);
    } catch (error) {
      print('Delete error: $error');
      result = GenericResponse.error('No Internet connection', 0);
    }
    return result;
  }

  Future<GenericResponse> _buildResponse<T>(http.Response response,
      [dynamic params]) async {
    GenericResponse result;
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson =
            _getMapValue(response.body, bodyBytes: response.bodyBytes) ??
                response.body;
        result = GenericResponse<T>.completed(responseJson);
        break;
      case 400:
        result = GenericResponse<T>.error(
          response.body.toString(),
          response.statusCode,
        );
        break;
      case 401:
        try {
          bool isLoggedIn = _retry ? await authService.tryAgain() : false;
          if (isLoggedIn) {
            String url = response.request.url.path.replaceAll('/api/', '');
            switch (response.request.method) {
              case 'GET':
                return await get(url);
              case 'POST':
                return await post(url, params);
              case 'PUT':
                return await put(url, params);
              case 'DELETE':
                return await delete(url, params);
            }
          } else {
            result = GenericResponse<T>.error(
                response.body.toString(), response.statusCode);
          }
        } on HttpException catch (e) {
          result = GenericResponse.error(
              'No Internet connection ${e.message} ${e.uri}', 0);
        }
        break;
      case 403:
        print('RefresToken caducado');
        authService.logout();
        Get.offAllNamed(NavigationRoute.SIGNIN);
        GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
        break;
      case 426:
        print('Session abierta en otro dispositivo');
        authService.logout();
        Get.offAllNamed(NavigationRoute.SIGNIN);
        GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
        break;
      default:
        result = GenericResponse<T>.error(
            response.body.toString(), response.statusCode);
        break;
    }
    return result;
  }

  dynamic _getMapValue(String resource, {List<int> bodyBytes}) {
    if (resource.contains('{', 0)) {
      dynamic response =
          json.decode(bodyBytes != null ? utf8.decode(bodyBytes) : resource);
      return response;
    }
    return null;
  }
}
