import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
import '../../../utils/responsive.dart';
import '../../../models/user.model.dart';
import '../../../services/pool_services.dart';
import '../../../themes/futgolazo_theme.dart';
import '../../../components/home/badge_team/badge_team.dart';
import 'package:futgolazo/src/components/widget/rounded_container_three_linear.dart';

class SubHeaderBar extends StatelessWidget {
  final UserModel user;
  final bool disableNavigate;
  final FutgolazoMainTheme _futgolazoMainTheme =
      GetIt.I<PoolServices>().futgolazoMainTheme;
  final Responsive _responsive =
      GetIt.I<PoolServices>().futgolazoMainTheme.getResponsive;

  SubHeaderBar({this.user, this.disableNavigate = false}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _futgolazoMainTheme.getColorsTheme.getColorBackground,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _responsive.wp(3),
        ),
        child: Container(
          height: _futgolazoMainTheme.getResponsive.hp(7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _userNameContainer(),
              BadgeTeam(
                user.supportedTeam?.logo ?? 'futgolazo',
                startAnimation:
                    user.supportedTeam == null || user.supportedTeam.id == null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userNameContainer() {
    return RoundedContainerThreeLinear(
      borderColor: _futgolazoMainTheme.getColorsTheme.getColorSurface,
      colors: [
        _futgolazoMainTheme.getColorsTheme.getColorOnButton,
        _futgolazoMainTheme.getColorsTheme.getColorButton,
        _futgolazoMainTheme.getColorsTheme.getColorButtonVariant,
      ],
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(
                  Icons.person_outline,
                  color: _futgolazoMainTheme.getColorsTheme.getColorSurface,
                ),
                SizedBox(
                  width: _futgolazoMainTheme.getResponsive.wp(3),
                ),
                Text(
                  '${onlyOneName(user.firstName)} ${onlyOneName(user.lastName)}',
                  style: _futgolazoMainTheme.getFontSize.button(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
