import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:load/load.dart';
import 'package:get_it/get_it.dart';

import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/components/custom_alert/custom_alert.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final services = await PoolServices.initialize();
  _setupLocator(services);
  runApp(ServicesProvider(
    services: services,
    child: MyApp(),
  ));
}

void _setupLocator(PoolServices poolServices) {
  GetIt.instance.registerSingleton(poolServices);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription errorMsg$;
  StreamSubscription logInSubscription$;
  StreamSubscription loadindSubscription$;

  @override
  void initState() {
    // Loading Stream Hola
    loadindSubscription$ = PoolServices.of(context)
        .loadingService
        .showLoading$
        .listen((bool showLoading) {
      if (showLoading) {
        showCustomLoadingWidget(
          _loadingCustom(),
          tapDismiss: false,
        );
      } else {
        hideLoadingDialog();
      }
    });

    errorMsg$ = GetIt.I<PoolServices>()
        .loadingService
        .showErrorMesagge$
        .listen((String errorMessage) {
      this._showErrorSnackBar(errorMessage);
    });
    super.initState();
  }

  @override
  void dispose() {
    loadindSubscription$.cancel();
    logInSubscription$.cancel();
    errorMsg$.cancel();
    super.dispose();
  }

  Widget _loadingCustom() {
    final responsive = GetIt.I<PoolServices>().futgolazoMainTheme.getResponsive;
    return Container(
      color: GetIt.I<PoolServices>()
          .futgolazoMainTheme
          .getColorsTheme
          .getColorBackground
          .withOpacity(.70),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          // color: Colors.yellow,
          width: responsive.hp(25),
          height: responsive.hp(25),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FlareActor.asset(
              AssetFlare(
                bundle: rootBundle,
                name: 'assets/animations/LoadingFGZ.flr',
              ),
              animation: 'Untitled',
            ),
          ),
        ),
      ),
    );
  }

  void _startFutgolazoTheme() async {
    await PoolServices.of(context).futgolazoMainTheme.initialize();
  }

  void _showErrorSnackBar(String errorMesagge) {
    var theme = GetIt.I<PoolServices>().futgolazoMainTheme;

    Get.snackbar(
      '',
      '',
      barBlur: 1.5,
      borderRadius: 0,
      isDismissible: true,
      duration: Duration(
        milliseconds: 5000,
      ),
      titleText: CustomAlert(
        errorMesagge,
      ),
      margin: EdgeInsets.zero,
      padding: EdgeInsets.only(top: theme.getResponsive.hp(2.5)),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.transparent,
    );
  }

  String _getRouteDependingOnSP(BuildContext context) {
    final services = PoolServices.of(context);
    return services.authService.getInitialRoute();
  }

  @override
  Widget build(BuildContext context) {
    _startFutgolazoTheme();
    return GetMaterialApp(
      title: 'Futgolazo',
      theme: GetIt.I<PoolServices>().futgolazoMainTheme.getTheme,
      initialRoute: _getRouteDependingOnSP(context),
      onGenerateRoute: RouteGenerator.generateRoutes,
      builder: (context, widget) {
        return LoadingProvider(
          child: widget,
        );
      },
    );
  }
}
