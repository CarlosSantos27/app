import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../services/pool_services.dart';

class ButtonTextRedirect extends StatelessWidget {
  final _futgolazoMainTheme = GetIt.I<PoolServices>().futgolazoMainTheme;

  final String routeRedirect;
  final String textButton;
  final String labelButton;
  final bool pushedRoute;

  ButtonTextRedirect({
    @required this.routeRedirect,
    @required this.textButton,
    this.labelButton = '',
    this.pushedRoute = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '$labelButton  ',
        children: [
          TextSpan(
            text: textButton,
            style: _futgolazoMainTheme.getFontSize
                .headline5(
                  color: _futgolazoMainTheme.getColorsTheme.getColorSecondary,
                )
                .copyWith(
                  decoration: TextDecoration.underline,
                ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _gotoRoute(routeRedirect),
          )
        ],
      ),
    );
  }

  void _gotoRoute(String navigationRoute) {
    if (pushedRoute) {
      Get.toNamed(navigationRoute);
    }else{
      Get.offNamed(navigationRoute);
    }
  }
}
