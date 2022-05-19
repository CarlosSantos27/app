import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/components/tearms_conditions/tearms_conditions.dart';

class SimpleSignin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TermsConditionsScreen(onEnterToApp: _enteredAsIncognito),
    );
  }

  void _enteredAsIncognito() {
    GetIt.I<PoolServices>().sharedPrefsService.acceptTermsAndConditions();
    GetIt.I<PoolServices>().dataService.playAsGuest();
    Get.toNamed(NavigationRoute.HOME);
  }
}
