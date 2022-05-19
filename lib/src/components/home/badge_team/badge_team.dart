import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/utils/responsive.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/components/jump_animation/jump_animation.dart';

class BadgeTeam extends StatelessWidget {
  final bool startAnimation;
  final String teamBadgeName;
  final double heightComponent;
  final Responsive _responsive =
      GetIt.I<PoolServices>().futgolazoMainTheme.getResponsive;

  BadgeTeam(
    this.teamBadgeName, {
    this.startAnimation,
    this.heightComponent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GetIt.I<PoolServices>().audioService.playRandomButton();
        _gotoRoute(NavigationRoute.USER_TEAM);
      },
      child: JumpAnimation(
        animateWidget: startAnimation ?? false,
        child: Container(
          height:
              heightComponent != null ? heightComponent : _responsive.hp(5.5),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Image.asset(
                'assets/backgrounds/badge/marco-escudos.png',
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
              FractionallySizedBox(
                heightFactor: .8,
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/backgrounds/badge/futgolazo.png',
                  image:
                      'https://futgolazo.com.ec/assets/team_badges/$teamBadgeName.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _gotoRoute(String navigationRoute) {
    Get.toNamed(navigationRoute);
  }
}
