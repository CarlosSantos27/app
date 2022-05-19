import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import '../../../routes/routes.dart';
import '../../../utils/responsive.dart';
import '../../../models/user.model.dart';
import '../../../enums/coin_type.enum.dart';
import '../../../services/pool_services.dart';
import '../../../dialog/coins/coins_info_dialog.dart';
import '../../../components/coin_indicator/coin_indicator.dart';
import '../../../components/custom_scafold/statefull_custom.dart';

class HeaderBar extends StateFullCustom {
  @override
  _HeaderBarState createState() => _HeaderBarState();
}

class _HeaderBarState extends State<HeaderBar>
    with SingleTickerProviderStateMixin {
  UserModel _user;
  Responsive _responsive;
  StreamSubscription<UserModel> _user$;

  StreamSubscription<bool> settings$;
  int maxLenght = 2;

  @override
  void initState() {
    super.initState();

    this._user$ =
        GetIt.I<PoolServices>().dataService.user$.listen((UserModel user) {
      setState(() {
        this._user = user;
        maxLenght = max(user.diamondCoins.toString().length,
            user.goldCoins.toString().length);
        print('ob');
      });
    });

    _responsive = GetIt.I<PoolServices>().futgolazoMainTheme.getResponsive;
  }

  @override
  void dispose() {
    _user$.cancel();
    settings$?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _responsive.hp(11),
      child: Container(
        color: widget.colorsTheme.getColorPrimary,
        child: _coinsIndicatorContainer(_user),
      ),
    );
  }

  Widget _coinsIndicatorContainer(UserModel user) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            left: _responsive.hp(3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CoinIndicator(
                maxLength: maxLenght,
                coinNumber: user?.goldCoins ?? 0,
                type: CoinTypeEnum.GOLD_COIN,
                onSelectedCoinIndicator: () =>
                    _showCoinsInstructions(CoinTypeEnum.DIAMOND_COIN),
              ),
              SizedBox(
                width: _responsive.wp(10),
              ),
              CoinIndicator(
                maxLength: maxLenght,
                coinNumber: user?.diamondCoins ?? 0,
                type: CoinTypeEnum.DIAMOND_COIN,
                onSelectedCoinIndicator: () =>
                    _showCoinsInstructions(CoinTypeEnum.GOLD_COIN),
              ),
            ],
          ),
        ),
        _buildIconSettings(),
      ],
    );
  }

  Container _buildIconSettings() {
    return Container(
      child: IconButton(
        icon: Icon(Icons.settings),
        color: widget.colorsTheme.getColorSurface,
        iconSize: widget.fontSize.headline3().fontSize,
        onPressed: () {
          Get.toNamed(NavigationRoute.SETTINGS);
        },
      ),
    );
  }

  void _showCoinsInstructions(CoinTypeEnum coinTypeEnum) {
    bool showPoup =
        GetIt.I<PoolServices>().sharedPrefsService.getShowCoinsPopup();
    if (showPoup) {
      Get.dialog(CoinsInfoDialog(coinTypeEnum: coinTypeEnum));
    } else {
      Get.toNamed(NavigationRoute.SHOP);
    }
  }
}
