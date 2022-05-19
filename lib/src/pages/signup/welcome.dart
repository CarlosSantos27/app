import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/models/user.model.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/bloc/mini_card/mini_card_bloc.dart';
import 'package:futgolazo/src/components/widget/rive_button.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';
import 'package:futgolazo/src/components/widget/irregular_rounded_container.dart';

class WelcomePage extends StateLessCustom {
  final UserModel user = GetIt.I<PoolServices>().dataService.user;

  @override
  Widget build(BuildContext context) {
    return FutgolazoScaffold(
      backgroundColor: colorsTheme.getColorBackground,
      body: _buildContent(),
    );
  }

  _buildContent() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTitle(),
          SizedBox(height: responsive.hp(8.0)),
          _buildGiftCard(),
          SizedBox(height: responsive.hp(8.0)),
          _buildButton(),
        ],
      ),
    );
  }

  _buildTitle() {
    TextStyle style = textTheme.headline4.copyWith(
      color: colorsTheme.getColorOnButton,
      fontStyle: FontStyle.normal,
    );
    return Container(
      width: responsive.wp(82.2),
      child: Column(
        children: [
          Text(
            'Bienvenido, ${user.firstName}',
            style: style,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          Text(
            '¡Ya tienes cuenta!',
            style: style,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  _buildGiftCard() {
    return SizedBox(
      width: responsive.wp(80.0),
      height: responsive.hp(42.8),
      child: IrregularRoundedContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: responsive.wp(50.0),
              child: Text(
                'Recibiste tu primer regalo',
                style: fontSize
                    .headline5()
                    .copyWith(color: colorsTheme.getColorOnSecondary),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: responsive.hp(3.0),
            ),
            _buildGiftCoins(),
          ],
        ),
      ),
    );
  }

  Widget _buildGiftCoins() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${user.goldCoins}',
          style: fontSize.headline1().copyWith(
                fontFamily: "TitanOne",
                fontSize: responsive.ip(9.0),
                color: colorsTheme.getColorOnSecondary,
              ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(1.2),
          ),
          child: _buildCoinIcon(),
        )
      ],
    );
  }

  _buildCoinIcon() {
    return SizedBox(
      width: responsive.wp(25.0),
      child: Image.asset(
        'assets/common/balon_oro.png',
        fit: BoxFit.contain,
      ),
    );
  }

  _buildButton() {
    return RiveButton(
      onTapButton: () {
        bool bookSent = GetIt.I<PoolServices>()
            .sharedPrefsService
            .checkIfUserHasBookStoraged();

        if (bookSent) {
          MiniCardBloc cardBloc = MiniCardBloc();
          cardBloc.setCurrentBookByStorage();
          Get.offNamed(NavigationRoute.MINI_CARD_PAY);
        } else {
          Get.offNamed(NavigationRoute.HOME);
        }
      },
      responsive: responsive,
      width: responsive.wp(82.2),
      buttonText: '¡gracias!',
    );
  }
}
