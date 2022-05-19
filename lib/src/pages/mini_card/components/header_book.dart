import 'package:flutter/material.dart';

import '../../../components/custom_scafold/stateless_custom.dart';

class HeaderBook extends StateLessCustom {
  final double height;
  final String subtitle;
  final Color background;

  HeaderBook({
    this.height,
    this.background,
    @required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? responsive.hp(22),
      width: double.infinity,
      color: background ?? colorsTheme.getColorBackgroundDarkest,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Envía una cartilla',
            style: fontSize
                .headline6(
                  color: colorsTheme.getColorOnBackground,
                )
                .copyWith(
                  fontSize: responsive.ip(
                    1.7,
                  ),
                ),
          ),
          SizedBox(
            height: responsive.hp(1),
          ),
          Text(
            subtitle,
            style: fontSize.headline4(),
          )
        ],
      ),
    );
  }
}
