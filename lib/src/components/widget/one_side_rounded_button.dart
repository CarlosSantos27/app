import 'package:flutter/material.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:get_it/get_it.dart';

class OneSideRoundedButton extends StatelessWidget {
  final String buttonText;
  final IconData iconData;
  final bool useFullWidth;
  final bool leftDirection;
  final VoidCallback onTap;
  final bool showNotification;
  final Widget child;

  const OneSideRoundedButton({
    @required this.iconData,
    this.onTap,
    this.buttonText = '',
    this.useFullWidth = false,
    this.leftDirection = false,
    this.showNotification = false,
    this.child,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap != null ? onTap() : null,
      child: Container(
        child: FractionallySizedBox(
          widthFactor: useFullWidth ? 1 : .14,
          heightFactor: 1,
          child: Stack(
            fit: StackFit.expand,
            overflow: Overflow.visible,
            children: <Widget>[
              _iconContainer(),
              _nofiticationCountContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: GetIt.I<PoolServices>()
              .futgolazoMainTheme
              .getColorsTheme
              .getColorSurface,
        ),
        borderRadius: BorderRadius.only(
          topLeft: leftDirection ? Radius.circular(20) : Radius.zero,
          topRight: !leftDirection ? Radius.circular(20) : Radius.zero,
          bottomLeft: leftDirection ? Radius.circular(20) : Radius.zero,
          bottomRight: !leftDirection ? Radius.circular(20) : Radius.zero,
        ),
      ),
      child: _buttonContent(),
    );
  }

  Widget _buttonContent() {
    if (buttonText.isEmpty) {
      return Align(
        alignment: leftDirection ? Alignment(-.7, 0) : Alignment(.70, 0),
        child: child ?? Icon(
          iconData,
          size: GetIt.I<PoolServices>()
              .futgolazoMainTheme
              .getTextTheme
              .headline5
              .fontSize,
          color: GetIt.I<PoolServices>()
              .futgolazoMainTheme
              .getColorsTheme
              .getColorSurface,
        ),
      );
    } else {
      if (leftDirection) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _icon(),
            SizedBox(
              width: GetIt.I<PoolServices>()
                  .futgolazoMainTheme
                  .getResponsive
                  .wp(1),
            ),
            _text(),
          ],
        );
      } else {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _text(),
            SizedBox(
              width: GetIt.I<PoolServices>()
                  .futgolazoMainTheme
                  .getResponsive
                  .wp(1),
            ),
            _icon(),
          ],
        );
      }
    }
  }

  Widget _icon() {
    return Icon(
      iconData,
      size: GetIt.I<PoolServices>()
          .futgolazoMainTheme
          .getTextTheme
          .headline4
          .fontSize,
      color: GetIt.I<PoolServices>()
          .futgolazoMainTheme
          .getColorsTheme
          .getColorSurface,
    );
  }

  Widget _text() {
    return Text(
      buttonText,
      style: GetIt.I<PoolServices>().futgolazoMainTheme.getFontSize.button(
            color: GetIt.I<PoolServices>()
                .futgolazoMainTheme
                .getColorsTheme
                .getColorSurface,
          ),
    );
  }

  Widget _nofiticationCountContainer() {
    return showNotification
        ? Align(
            alignment:
                leftDirection ? Alignment(-.9, -1.0) : Alignment(.9, -1.0),
            child: Transform.translate(
              offset: Offset(0, -8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: GetIt.I<PoolServices>()
                      .futgolazoMainTheme
                      .getColorsTheme
                      .getColorError,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2.5,
                  ),
                  child: Text(
                    '1',
                    style: GetIt.I<PoolServices>()
                        .futgolazoMainTheme
                        .getFontSize
                        .overline(
                          color: GetIt.I<PoolServices>()
                              .futgolazoMainTheme
                              .getColorsTheme
                              .getColorSurface,
                        ),
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}
