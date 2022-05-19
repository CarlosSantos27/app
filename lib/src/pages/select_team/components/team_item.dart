import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import '../../../models/team.model.dart';
import '../../../services/pool_services.dart';
import 'package:futgolazo/src/env/env.model.dart';
import '../../../components/custom_scafold/stateless_custom.dart';

class TeamItem extends StateLessCustom {
  final TeamModel teamModel;
  final Function onSelectedTeam;
  final EnvModel env = GetIt.I<PoolServices>().environment.environment;

  TeamItem({@required this.teamModel, @required this.onSelectedTeam});

  @override
  Widget build(BuildContext context) {
    double maxHeight = responsive.hp(10.76);
    return GestureDetector(
      onTap: () {
        GetIt.I<PoolServices>().audioService.playRandomButton();
        onSelectedTeam(teamModel);
      },
      child: Container(
        height: maxHeight,
        padding: EdgeInsets.symmetric(
          vertical: responsive.hp(1.2),
          horizontal: responsive.wp(2),
        ),
        decoration: BoxDecoration(
          color: colorsTheme.getColorPrimary,
          borderRadius: BorderRadius.circular(
            responsive.ip(2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _badgeWidget(
              maxHeight * .70,
            ),
            _teamName(
              maxHeight * .30,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: colorsTheme.getColorOnButton,
            ),
          ],
        ),
      ),
    );
  }

  Widget _teamName(double containerHeight) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth * .9,
              child: Container(
                height: containerHeight,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    teamModel.description,
                    style: fontSize.subtitle1(
                      color: colorsTheme.getColorOnSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _badgeWidget(double containerHeight) {
    String badge = teamModel != null && teamModel.logo != null
        ? teamModel.logo
        : 'FutgolazoEC';
    return Container(
      margin: EdgeInsets.only(
        left: responsive.wp(2),
        right: responsive.wp(4),
      ),
      alignment: Alignment.center,
      height: containerHeight * 2,
      child: Align(
        alignment: Alignment.center,
        child: Image.network(
          '${env.imagePath}team_badges/$badge.png',
          fit: BoxFit.contain,
          height: 60,
        ),
      ),
    );
  }
}
