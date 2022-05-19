import 'package:flutter/material.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';

class BackButtonWidget extends StateLessCustom {
  final Color iconColor;
  final Color color;
  final IconData iconData;
  final bool withShadow;
  final Function onBack;

  BackButtonWidget({
    this.iconColor,
    this.color = Colors.white,
    this.withShadow = false,
    this.iconData,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator.canPop(context) ? _buildContent(context) : Container();
  }

  _buildContent(BuildContext context) {
    return Container(
      height: responsive.hp(5.0),
      width: responsive.hp(5.0),
      child: IconButton(
        onPressed: () {
          if (onBack != null) onBack();
          Navigator.maybePop(context);
        },
        icon: Icon(
          iconData ?? Icons.arrow_back_ios,
          color: iconColor ?? colorsTheme.getColorSurface,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
