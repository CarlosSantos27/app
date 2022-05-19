import 'dart:async';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/bloc/base/base_bloc.dart';
import 'package:futgolazo/src/services/pool_services.dart';

class LoadingBloc extends BaseBloc {
  Stream<bool> _authService$;

  StreamSubscription _subscription;

  LoadingBloc() {
    _authService$ =
        GetIt.I<PoolServices>().authService.getLastUserInfo().asStream();

    _subscription =
        _authService$.listen((data) => _setInfoUserAndChangeRoute(data));
  }

  @override
  void dispose() {
    _subscription.cancel();
  }

  void _setInfoUserAndChangeRoute(bool thereIsUserData) {
    final user = GetIt.I<PoolServices>().dataService.user;

    if (!user.isVerified) {
      GetIt.I<PoolServices>()
          .loadingService
          .showErrorSnackbar('Tu cuenta no está verificada');
      Get.offAllNamed(NavigationRoute.SIGNUP, arguments: {"page": 3});
      return;
    }
    Get.offNamed(NavigationRoute.HOME);
  }
}
