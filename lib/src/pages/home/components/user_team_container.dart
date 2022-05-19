import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/models/user.model.dart';
import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/components/widget/rive_button.dart';
import 'package:futgolazo/src/pages/home/components/image_pet.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';
import 'package:futgolazo/src/components/colored_irregular_container/colored_irregular_container.dart';

class UserTeamContainer extends StateLessCustom {
  final UserModel user;

  UserTeamContainer({this.user});

  @override
  Widget build(BuildContext context) {
    return _teamArea(user);
  }

  Widget _teamArea(UserModel user) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _teamBackground(
                constraints.maxHeight,
                user,
              ),
              _userNameText(
                user.firstName + ' ' + user.lastName,
                constraints,
              ),
              _playButton(constraints.maxWidth),
            ],
          );
        },
      ),
    );
  }

  Widget _userNameText(String textName, BoxConstraints constraints) {
    return Positioned(
      top: constraints.maxHeight * .07,
      left: constraints.maxWidth * .06,
      child: Text(
        textName,
        style: fontSize.headline6(
          color: colorsTheme.getColorSurface,
        ),
      ),
    );
  }

  Widget _teamBackground(double maxHeight, UserModel user) {
    String logo = user.supportedTeam.logo;
    Color color = user.supportedTeam.primaryColor;
    return Container(
      height: maxHeight,
      child: ColoredIrregularContianer(
        backgroundColor: color,
        child: Align(
          alignment: Alignment(.10, .1),
          child: Container(
            height: maxHeight * .8,
            child: ImagePet(
              supportedTeam: logo,
            ),
          ),
        ),
      ),
    );
  }

  Widget _playButton(double maxWidth) {
    return Positioned(
      bottom: 0,
      left: maxWidth * .11,
      child: RiveButton(
        onTapButton: () {
          Get.toNamed(NavigationRoute.GAME_MENU);
        },
        responsive: responsive,
        width: maxWidth * .8,
        buttonText: 'Jugar',
      ),
    );
  }
}
