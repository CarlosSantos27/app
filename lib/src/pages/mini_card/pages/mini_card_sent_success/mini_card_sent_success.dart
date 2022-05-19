import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/utils/date_for_human.dart';
import 'package:futgolazo/src/components/widget/text_stroke.dart';
import 'package:futgolazo/src/bloc/mini_card/mini_card_bloc.dart';
import 'package:futgolazo/src/components/widget/button_shadow_rounded.dart';
import 'package:futgolazo/src/pages/mini_card/components/book_card_item.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';
import 'package:futgolazo/src/components/futgolazo_scaffold/futgolazo_scaffold.dart';

class MiniCardSentSuccess extends StateLessCustom {
  final MiniCardBloc _miniCardBloc;
  MiniCardSentSuccess() : _miniCardBloc = MiniCardBloc();

  @override
  Widget build(BuildContext context) {
    return _mainContainer();
  }

  Widget _mainContainer() {
    return FutgolazoScaffold(
      withBackButton: false,
      body: Container(
        height: responsive.hp(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _bodyWidget(),
            SizedBox(
              height: responsive.hp(4),
            ),
            _footerContainer(),
          ],
        ),
      ),
    );
  }

  Widget _headerContainer() {
    return Container(
      width: responsive.wp(60),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: responsive.hp(1),
        ),
        child: Text(
          'Tu Mini Caritlla se envió con éxito',
          style: fontSize.headline4(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    return Expanded(
      child: Container(
        width: responsive.wp(90),
        child: Column(
          children: [
            _headerContainer(),
            SizedBox(
              height: responsive.hp(2),
            ),
            _bodyContainer(),
            SizedBox(
              height: responsive.hp(2),
            ),
            _buttonPlayAgain(),
          ],
        ),
      ),
    );
  }

  Widget _bodyContainer() {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/backgrounds/gold_frame.png',
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: responsive.wp(50),
                  child: Text(
                    'Asegura tu victoria, todavía puedes enviar otra Mini Cartilla hasta',
                    style: fontSize.headline6(),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: responsive.hp(4),
                ),
                RemainigRealTime(
                  dateHuman: _miniCardBloc.currentMiniCard.dateHuman,
                  child: (BuildContext context, DateForHuman snapshot) {
                    return TextStroke(
                      '${snapshot.remaining}',
                      textAlign: TextAlign.center,
                      style: fontSize.headline2().copyWith(
                            fontFamily: 'TitanOne',
                          ),
                      strokeWidth: 10.0,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonPlayAgain() {
    return ButtonShadowRounded(
      width: responsive.wp(90),
      child: Text(
        'Jugar otra',
        style: fontSize.headline4(),
      ),
      onPressed: () {
        _miniCardBloc.restarMinicard();
        Get.offNamed(NavigationRoute.MINI_CARD);
      },
    );
  }

  Widget _footerContainer() {
    return Container(
      height: responsive.hp(10),
      color: colorsTheme.getColorBackgroundVariant,
      child: Center(
        child: GestureDetector(
          child: Text(
            "No, gracias",
            style: fontSize
                .headline6(
                  color: colorsTheme.getColorBackground,
                )
                .copyWith(
                  decoration: TextDecoration.underline,
                ),
          ),
          onTap: () => Get.offAllNamed(NavigationRoute.HOME),
        ),
      ),
    );
  }
}
