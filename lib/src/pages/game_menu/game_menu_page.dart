import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/components/home/header/header_bar.dart';
import 'package:futgolazo/src/components/jump_animation/jump_animation.dart';
import 'package:futgolazo/src/components/futgolazo_scaffold/back_button.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';

class GameMenuPage extends StateLessCustom {
  GameMenuPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(responsive.hp(22.3)),
        child: _buildAppBar(),
      ),
      body: _buildContent(),
    );
  }

  _buildAppBar() {
    return AppBar(
      centerTitle: true,
      leading: BackButtonWidget(),
      backgroundColor: colorsTheme.getColorPrimary,
      flexibleSpace: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: responsive.hp(1.0)),
              child: HeaderBar(),
            ),
          )
        ],
      ),
    );
  }

  _buildContent() {
    return Center(
      child: _buildMiniCartillaOption(onTap: () {
        Get.toNamed(NavigationRoute.MINI_CARD_LIST);
      }),
    );
  }

  _buildMiniCartillaOption({Function onTap}) {
    return JumpAnimation(
      child: InkWell(
        onTap: onTap,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Container(
          width: responsive.wp(70.0),
          height: responsive.wp(70.0),
          decoration: BoxDecoration(
              color: colorsTheme.getColorPrimary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.5),
                  spreadRadius: 8,
                  blurRadius: 5,
                  offset: Offset(1, 1),
                ),
              ]),
          child: Center(
            child: Container(
              width: responsive.wp(63.0),
              height: responsive.wp(63.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: <Color>[
                  colorsTheme.getColorOnSurface,
                  Colors.black.withOpacity(0.5),
                ], stops: [
                  0.5,
                  1.0
                ], radius: 0.6),
              ),
              child: _buildImageBackground(),
            ),
          ),
        ),
      ),
    );
  }

  _buildImageBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(500.0),
          child: SvgPicture.asset(
            'assets/backgrounds/bgMascotasMultiply.svg',
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.multiply,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(500.0),
          child: Center(
            child: SizedBox(
              width: responsive.wp(50.0),
              child: Image(
                image: AssetImage('assets/common/logo_mini_cartilla.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        )
      ],
    );
  }
}
