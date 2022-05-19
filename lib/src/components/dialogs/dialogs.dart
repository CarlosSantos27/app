import 'package:flutter/material.dart';
import 'package:futgolazo/src/components/futgolazo_scaffold/back_button.dart';
import 'package:futgolazo/src/components/widget/button_shadow_rounded.dart';
import 'package:get_it/get_it.dart';
import '../../services/pool_services.dart';

enum DialogAction { yes, cancel, close }

class Dialogs {
  static final _responsive =
      GetIt.I<PoolServices>().futgolazoMainTheme.getResponsive;
  static final _colorsThemes =
      GetIt.I<PoolServices>().futgolazoMainTheme.getColorsTheme;
  static final _fontSize =
      GetIt.I<PoolServices>().futgolazoMainTheme.getFontSize;

  static Future<DialogAction> customYesCancelDialog(
    BuildContext context, {
    @required String title,
    Widget body,
    bool dismissible = false,
    String yesText = 'SI',
    String cancelText = 'NO',
    EdgeInsetsGeometry contentPadding,
    double radius = 8.0,
    double maxWidth = 338.0,
    bool showCloseButton = false,
    Color closeIconColor,
  }) async {
    EdgeInsetsGeometry defaultPadding = EdgeInsets.all(_responsive.ip(1.8));
    final action = await showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) {
        return AlertDialog(
          contentPadding: contentPadding ?? defaultPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          insetPadding: EdgeInsets.all(10.0),
          content: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (title != null)
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _fontSize
                          .headline4()
                          .copyWith(color: _colorsThemes.getColorPrimary),
                    ),
                  if (title != null) SizedBox(height: _responsive.hp(1.0)),
                  Flexible(
                      child: Container(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: body ??
                              Container(
                                height: 0.0,
                              ))),
                  SizedBox(height: _responsive.hp(2.0)),
                  _buildRowButtons(context, yesText, cancelText),
                ],
              ),
              if (showCloseButton)
                _buildCloseWidget(
                    closeIconColor ?? _colorsThemes.getColorPrimary),
            ],
          ),
        );
      },
    );
    return action ?? DialogAction.close;
  }

  static _buildRowButtons(
      BuildContext context, String yesText, String cancelText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildButton(
            yesText, () => Navigator.of(context).pop(DialogAction.yes)),
        SizedBox(width: 16.0),
        _buildButton(
            cancelText, () => Navigator.of(context).pop(DialogAction.cancel),
            isPrimary: false),
      ],
    );
  }

  static _buildButton(String text, Function onPressed,
      {bool isPrimary = true}) {
    return ButtonShadowRounded(
      child: Text(
        text ?? '',
        style: _fontSize.bodyText1().copyWith(
              fontStyle: FontStyle.normal,
              color: isPrimary
                  ? _colorsThemes.getColorOnSecondary
                  : _colorsThemes.getColorPrimary,
            ),
      ),
      background: isPrimary ? _colorsThemes.getColorPrimary : Colors.white,
      side: isPrimary
          ? BorderSide(color: Colors.transparent)
          : BorderSide(color: _colorsThemes.getColorPrimary, width: 2.0),
      width: _responsive.wp(40.0),
      onPressed: onPressed,
    );
  }

  static _buildCloseWidget(Color iconColor) {
    return Positioned(
      top: _responsive.wp(-2.7),
      right: _responsive.wp(-2.7),
      child: BackButtonWidget(
        iconColor: iconColor,
        iconData: Icons.close,
      ),
    );
  }
}
