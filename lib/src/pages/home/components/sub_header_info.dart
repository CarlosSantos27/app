import 'package:flutter/material.dart';

import 'package:futgolazo/src/models/user.model.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';
import 'package:futgolazo/src/components/container_default/contain_default.dart';

class SubHeadrInfo extends StateLessCustom {
  final UserModel user;

  SubHeadrInfo({this.user});

  @override
  Widget build(BuildContext context) {
    return _subHeaderBar();
  }

  Widget _subHeaderBar() {
    return Container(
      height: responsive.hp(12.4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getInfoContainer(
            'Ganancia',
            '${user.currentUSDBalance.floor()}\$',
          ),
          SizedBox(
            width: responsive.wp(5),
          ),
          _getInfoContainer(
            'Ranking',
            user.ranking.toString(),
          ),
        ],
      ),
    );
  }

  Widget _getInfoContainer(String title, String value) {
    return Expanded(
      child: ContainerDefault(
        padding: EdgeInsets.all(
          responsive.ip(.8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: fontSize.headline6(
                color: colorsTheme.getColorOnSecondary,
              ),
            ),
            Text(
              value,
              style: fontSize
                  .headline3(
                    color: colorsTheme.getColorOnButton,
                  )
                  .copyWith(
                    fontFamily: 'TitanOne',
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
