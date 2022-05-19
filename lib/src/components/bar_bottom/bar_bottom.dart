import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../routes/routes.dart';
import '../../components/custom_scafold/stateless_custom.dart';
import '../../components/container_default/contain_default.dart';

enum BarBottomOption { SHOP, HOME, EVENTS }

class BarBottom extends StateLessCustom {
  final BarBottomOption selectOption;

  BarBottom({this.selectOption = BarBottomOption.HOME});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: responsive.hp(14.8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _iconsContainer(),
          _buildActiveOption(),
        ],
      ),
    );
  }

  Widget _iconsContainer() {
    return ContainerDefault(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: responsive.hp(.01),
          horizontal: responsive.wp(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _shopButton(),
            _playButton(),
            _eventsButton(),
          ],
        ),
      ),
      boxShadow: generalThemes.getBoxShadow(),
    );
  }

  Widget _shopButton({bool isActive = false}) {
    return GestureDetector(
      onTap: () => _onTabMenuButton(BarBottomOption.SHOP),
      child: SvgPicture.asset(
        'assets/bar_bottom/Tienda.svg',
        width: responsive.wp(isActive ? 11.11 : 8.8),
        color: isActive
            ? colorsTheme.getColorPrimaryVariant
            : colorsTheme.getColorOnButton,
      ),
    );
  }

  Widget _eventsButton({bool isActive = false}) {
    return GestureDetector(
      onTap: () => _onTabMenuButton(BarBottomOption.EVENTS),
      child: SvgPicture.asset(
        'assets/bar_bottom/Jugadas.svg',
        width: responsive.wp(isActive ? 11.11 : 8.8),
        color: isActive
            ? colorsTheme.getColorPrimaryVariant
            : colorsTheme.getColorOnButton,
      ),
    );
  }

  Widget _playButton({bool isActive = false}) {
    return GestureDetector(
      onTap: () => _onTabMenuButton(BarBottomOption.HOME),
      child: SvgPicture.asset(
        'assets/bar_bottom/Play.svg',
        width: responsive.wp(isActive ? 11.11 : 8.8),
        color: isActive
            ? colorsTheme.getColorPrimaryVariant
            : colorsTheme.getColorOnButton,
      ),
    );
  }

  Widget _buildActiveOption() {
    final Widget child = _getSelectedItem();
    return Align(
      alignment: _getAlign(),
      child: Container(
        width: responsive.hp(14.8),
        height: responsive.hp(14.8),
        padding: EdgeInsets.all(
          responsive.hp(3.5),
        ),
        margin: _getMargin(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            200,
          ),
          color: colorsTheme.getColorButton,
          boxShadow: generalThemes.getBoxShadow(),
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget _getSelectedItem() {
    final Widget child = selectOption == BarBottomOption.SHOP
        ? _shopButton(isActive: true)
        : selectOption == BarBottomOption.HOME
            ? _playButton(isActive: true)
            : _eventsButton(isActive: true);
    return child;
  }

  AlignmentGeometry _getAlign() {
    return selectOption == BarBottomOption.SHOP
        ? Alignment.bottomLeft
        : selectOption == BarBottomOption.HOME
            ? Alignment.bottomCenter
            : Alignment.bottomRight;
  }

  EdgeInsetsGeometry _getMargin() {
    return selectOption == BarBottomOption.SHOP
        ? EdgeInsets.only(left: responsive.wp(2.2))
        : selectOption == BarBottomOption.HOME
            ? EdgeInsets.all(0.0)
            : EdgeInsets.only(right: responsive.wp(2.2));
  }

  void _onTabMenuButton(BarBottomOption selecteButtonOption) {
    if (selectOption == selecteButtonOption) {
      return;
    }
    switch (selecteButtonOption) {
      case BarBottomOption.HOME:
        Get.offNamed(NavigationRoute.HOME);
        break;
      case BarBottomOption.SHOP:
        Get.toNamed(NavigationRoute.SHOP);
        break;
      case BarBottomOption.EVENTS:
        Get.toNamed(NavigationRoute.PLAYS);
        break;
    }
  }
}
