import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/components/tearms_conditions/tearms_conditions.dart';

class AcceptRequiriments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TermsConditionsScreen(
        onEnterToApp: _enteredToApp,
      ),
    );
  }

  void _enteredToApp() async {
    await GetIt.I<PoolServices>().authService.registerAcceptTermsConditions();
    Get.offAllNamed(NavigationRoute.HOME);
    // Get.toNamed(NavigationRoute.HOME);
  }
}
