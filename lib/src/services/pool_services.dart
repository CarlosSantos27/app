import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'data_service.dart';
import 'auth_services.dart';
import 'loading_service.dart';
import '../env/env.router.dart';
import 'shared_preferencess_service.dart';
import 'package:futgolazo/src/services/audio_service.dart';
import 'package:futgolazo/src/themes/futgolazo_theme.dart';
import 'package:futgolazo/src/networking/api_provider.dart';
import 'package:futgolazo/src/services/google_analytics_services.dart';
import 'package:futgolazo/src/push_notification/push_notification_provider.dart';

/// Service container
class PoolServices {
  final ApiProvider restApi;
  final DataService dataService;
  final AuthService authService;
  final AudioService audioService;
  final EnvironmentConfig environment;
  final LoadingService loadingService;
  final FutgolazoMainTheme futgolazoMainTheme;
  final SharedPreferencesService sharedPrefsService;
  final GoogleAnalyticsServices googleAnalyticsServices;
  final PushNotificationProvider pushNotificationProvider;

  PoolServices({
    this.restApi,
    this.environment,
    this.dataService,
    this.authService,
    this.audioService,
    this.loadingService,
    this.sharedPrefsService,
    this.futgolazoMainTheme,
    this.googleAnalyticsServices,
    this.pushNotificationProvider,
  });

  static Future<PoolServices> initialize() async {
    final _futgolazoMainTheme = FutgolazoMainTheme();

    final sharedPrefs = await SharedPreferences.getInstance();
    final sharedPrefsService = SharedPreferencesService(sharedPrefs);

    final _provider = ApiProvider();

    final _audioService = AudioService();
    _audioService.initState(sharedPrefsService);

    final loadingService = LoadingService();

    final environment = EnvironmentConfig();
    
    final pushNotification = new PushNotificationProvider();
    // await pushNotification.initPushNotification();

    final dataService = DataService(sharedPrefsService);
    dataService.initialize();

    final authService = AuthService(sharedPrefsService, dataService, _provider);

    //GOOGLE ANALYTICS
    final googleAnalyticsService = new GoogleAnalyticsServices();

    _provider.init(authService, environment);

    return PoolServices(
      restApi: _provider,
      environment: environment,
      dataService: dataService,
      authService: authService,
      audioService: _audioService,
      loadingService: loadingService,
      sharedPrefsService: sharedPrefsService,
      futgolazoMainTheme: _futgolazoMainTheme,
      pushNotificationProvider: pushNotification,
      googleAnalyticsServices: googleAnalyticsService,
    );
  }

  static PoolServices of(BuildContext context) {
    final provider = context
        .getElementForInheritedWidgetOfExactType<ServicesProvider>()
        .widget as ServicesProvider;
    return provider.services;
  }
}

class ServicesProvider extends InheritedWidget {
  final PoolServices services;

  ServicesProvider({Key key, this.services, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(ServicesProvider old) {
    if (services != old.services) {
      throw Exception('Services must be constant!');
    }
    return false;
  }
}
