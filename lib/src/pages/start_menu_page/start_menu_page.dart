import 'dart:math';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import '../../routes/routes.dart';
import '../../services/pool_services.dart';
import '../../components/widget/rive_button.dart';
import '../../pages/home/components/image_pet.dart';
import '../../components/widget/halo_component.dart';
import '../../components/widget/button_shadow_rounded.dart';
import '../../components/custom_scafold/stateless_custom.dart';
import '../../components/custom_scafold/statefull_custom.dart';

class StartMenuPage extends StateFullCustom {
  @override
  _StartMenuPageState createState() => _StartMenuPageState();
}

class _StartMenuPageState extends State<StartMenuPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutgolazoScaffold(
      withBackButton: true,
      backgroundColor: widget.colorsTheme.getColorBackground,
      body: _buildContent(),
    );
  }

  _buildContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        widget.responsive.ip(4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: widget.responsive.hp(4)),
          _buildTitle(),
          SizedBox(height: widget.responsive.hp(4)),
          _buildSelectedTeam(),
          SizedBox(height: widget.responsive.hp(3)),
          _buildLoginButton(),
          SizedBox(height: widget.responsive.hp(3)),
          _buildSingupButton(),
          SizedBox(height: widget.responsive.hp(3)),
          _buildIncognitoButton(),
        ],
      ),
    );
  }

  _buildTitle() {
    return Container(
      width: widget.responsive.wp(80),
      child: Text(
        '¡Todo listo! Crea tu usuario y comienza a jugar',
        style: widget.textTheme.headline5.copyWith(
          color: widget.colorsTheme.getColorOnButton,
          fontStyle: FontStyle.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  _buildSelectedTeam() {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              HaloWidget(),
              StreamBuilder(
                stream: GetIt.I<PoolServices>().dataService.user$,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: constraints.maxHeight * .96,
                      child: ImagePet(
                        supportedTeam: snapshot.data.supportedTeam?.logo,
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  _buildLoginButton() {
    return RiveButton(
      onTapButton: () => Get.toNamed(NavigationRoute.SIGNIN),
      responsive: widget.responsive,
      width: widget.responsive.wp(82.2),
      buttonText: 'iniciar sesión',
    );
  }

  _buildSingupButton() {
    return _buildBlueButton(
      'Registrarse',
      () => Get.toNamed(NavigationRoute.SIGNUP),
      style: widget.textTheme.subtitle1.copyWith(
        fontSize: max(widget.responsive.ip(2), 20.0),
        color: widget.colorsTheme.getColorOnSecondary,
      ),
    );
  }

  _buildIncognitoButton() {
    return _buildBlueButton(
      'Lo haré más tarde',
      () => Get.toNamed(NavigationRoute.HOME),
      style: widget.textTheme.subtitle2.copyWith(
        color: widget.colorsTheme.getColorOnSecondary,
      ),
    );
  }

  _buildBlueButton(String buttonText, Function callback, {TextStyle style}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ButtonShadowRounded(
          width: constraints.maxWidth,
          child: Text(
            buttonText,
            style: style,
          ),
          onPressed: callback,
        );
      },
    );
  }
}
