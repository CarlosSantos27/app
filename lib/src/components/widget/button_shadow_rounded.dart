import 'package:flutter/material.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';

class ButtonShadowRounded extends StateLessCustom {
  /// Ancho del botón [auto] por defecto
  final double width;

  /// Alto del botón [56.0 con responsive height] por defecto
  final double height;

  /// Los textos heredan el estilo por defecto
  /// ```dart
  ///child: DefaultTextStyle(
  ///         style: fontSize.bodyText1().copyWith(
  ///              fontStyle: FontStyle.normal,
  ///              color: colorsTheme.getColorOnSecondary,
  ///            ),
  ///        child: child,
  ///      ),
  /// ```
  final Widget child;

  /// Color de fondo del botón [primary color] por defecto
  final Color background;

  /// Función llamada al presionar el botón
  final Function onPressed;

  /// Shadow del botón. [shadow con 4.0 en Y] por defecto
  final List<BoxShadow> boxShadow;

  final BorderSide side;

  ///Widget Button customizado con borders redondeados y box shadow
  ///
  ///Return
  ///- [Widget]
  ButtonShadowRounded({
    @required this.child,
    @required this.onPressed,
    this.height,
    this.width,
    this.background,
    this.boxShadow,
    this.side = const BorderSide(color: Colors.transparent),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? responsive.hp(7.7),
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
            Radius.circular((this.height ?? responsive.hp(7.7)) / 2)),
        boxShadow: onPressed == null ? [] : (boxShadow ?? _getDefaultBoxShadow()),
      ),
      child: RaisedButton(
        child: DefaultTextStyle(
          style: fontSize.bodyText1().copyWith(
                fontStyle: FontStyle.normal,
                color: colorsTheme.getColorOnSecondary,
              ),
          child: child,
        ),
        color: background ?? colorsTheme.getColorPrimary,
        shape: StadiumBorder(side: side),
        elevation: 0.0,
        disabledColor:colorsTheme.getColorOnSurface,
        onPressed: onPressed,
      ),
    );
  }

  List<BoxShadow> _getDefaultBoxShadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.5),
        blurRadius: 3.0,
        offset: Offset(0, 4),
      ),
    ];
  }
}
