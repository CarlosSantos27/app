import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/utils/responsive.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/components/widget/text_stroke.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';

class RiveButton extends StateLessCustom {
  final double width;
  final TextStyle style;
  final bool isBigButton;
  final String buttonText;
  final Responsive responsive;
  final VoidCallback onTapButton;
  final EdgeInsetsGeometry padding;

  RiveButton({
    Key key,
    this.width,
    this.style,
    this.padding,
    this.responsive,
    this.isBigButton = false,
    @required this.buttonText,
    @required this.onTapButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? _defineStyleDefault();
    final paddingDefault = padding ?? _definePaddingDefault();

    return RawMaterialButton(
      onPressed: _onTapButton,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.ip(1.6)),
      ),
      child: ClipPath(
        clipper: RiveCustomClipper(responsive: responsive),
        child: Container(
          width: width ?? double.infinity,
          padding: EdgeInsets.all(responsive.ip(0.5)),
          color: colorsTheme.getColorPrimary,
          child: ClipPath(
            clipper: RiveCustomClipper(responsive: responsive),
            child: Container(
              color: colorsTheme.getColorButtonVariant,
              padding: paddingDefault,
              child: Center(
                child: _buildChild(textStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChild(TextStyle textStyle) {
    return TextStroke(
      buttonText.toUpperCase(),
      style: textStyle.copyWith(
        fontFamily: "TitanOne",
      ),
    );
  }

  void _onTapButton() {
    GetIt.I<PoolServices>().audioService.playRandomButton();

    if (onTapButton != null) onTapButton();
  }

  EdgeInsetsGeometry _definePaddingDefault() {
    return EdgeInsets.symmetric(
      vertical: isBigButton ? 40 * responsive.aspectRatio : responsive.hp(2.7),
      horizontal:
          isBigButton ? 40 * responsive.aspectRatio : responsive.wp(5.6),
    );
  }

  TextStyle _defineStyleDefault() {
    return super.fontSize.headline3().copyWith(
          fontSize: responsive.ip(3),
          color: colorsTheme.getColorOnSecondary,
        );
  }
}

class RiveCustomClipper extends CustomClipper<Path> {
  final Responsive responsive;

  RiveCustomClipper({@required this.responsive});

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height - responsive.ip(1.6));
    path.quadraticBezierTo(0.0, size.height, responsive.ip(1.6), size.height);
    path.lineTo(size.width - responsive.ip(1.6), size.height * 0.95);
    path.quadraticBezierTo(
        size.width, size.height * 0.95, size.width, (size.height * 0.95) - 16);
    path.lineTo(size.width * 0.99, (size.height * 0.05) + responsive.ip(1.6));
    path.quadraticBezierTo(size.width * 0.98, size.height * 0.05,
        (size.width * 0.98) - responsive.ip(1.6), size.height * 0.05);
    path.lineTo(responsive.ip(1.6), 0.0);
    path.quadraticBezierTo(0.0, 0.0, 0.0, responsive.ip(1.6));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
