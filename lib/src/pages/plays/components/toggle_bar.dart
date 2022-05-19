import 'package:flutter/material.dart';
import 'package:futgolazo/src/components/custom_scafold/statefull_custom.dart';

enum PositionedSelected { LEFT, RIGHT }

class ToggleBarWidget extends StateFullCustom {
  /// height of container. Default _responsive.hp(6.67)_
  final double height;
  final Function(PositionedSelected) onChanged;

  ToggleBarWidget({Key key, this.height, this.onChanged}) : super(key: key);

  @override
  _ToggleBarWidgetState createState() => _ToggleBarWidgetState();
}

class _ToggleBarWidgetState extends State<ToggleBarWidget> {
  PositionedSelected selected;

  @override
  void initState() {
    selected = PositionedSelected.LEFT;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          _buildBackground(constraints.maxWidth),
          Align(
            alignment: Alignment.centerLeft,
            child: _buildSelected(constraints.maxWidth),
          ),
        ],
      );
    });
  }

  _buildBackground(double maxWidth) {
    final innerHeight = widget.height ?? widget.responsive.hp(6.67);
    return Row(
      children: [
        _buildBackgroundPosition(
            innerHeight, maxWidth, PositionedSelected.LEFT, 'Activas'),
        _buildBackgroundPosition(
            innerHeight, maxWidth, PositionedSelected.RIGHT, 'Resultados'),
      ],
    );
  }

  _buildBackgroundPosition(double innerHeight, double maxWidth,
      PositionedSelected positioned, String text) {
    final BorderRadiusGeometry radius = positioned == PositionedSelected.LEFT
        ? _buildLeftRadius(innerHeight)
        : _buildRightRadius(innerHeight);
    return InkWell(
      onTap: () {
        selected = positioned;
        if (widget.onChanged != null) widget.onChanged(positioned);
        setState(() {});
      },
      borderRadius: radius,
      child: Container(
        width: maxWidth / 2,
        height: innerHeight,
        decoration: BoxDecoration(
          borderRadius: radius,
          color: widget.colorsTheme.getColorPrimary,
        ),
        child: Center(
          child: Text(
            text,
            style: widget.fontSize
                .headline6()
                .copyWith(color: widget.colorsTheme.getColorOnButton),
          ),
        ),
      ),
    );
  }

  BorderRadiusGeometry _buildLeftRadius(double height) {
    return BorderRadius.only(
        topLeft: Radius.circular(height / 2),
        bottomLeft: Radius.circular(height / 2));
  }

  BorderRadiusGeometry _buildRightRadius(double height) {
    return BorderRadius.only(
        topRight: Radius.circular(height / 2),
        bottomRight: Radius.circular(height / 2));
  }

  _buildSelected(double maxWidth) {
    final innerHeight = widget.height ?? widget.responsive.hp(6.67);
    final double translation =
        selected == PositionedSelected.LEFT ? 0.0 : (maxWidth / 2);
    final String text =
        selected == PositionedSelected.LEFT ? 'Activas' : 'Resultados';
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: maxWidth / 2,
      height: innerHeight,
      transform: Matrix4.translationValues(translation, 0.0, 0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(innerHeight / 2),
        color: widget.colorsTheme.getColorOnSurface,
      ),
      child: Center(
        child: Text(
          text,
          style: widget.fontSize.headline6(),
        ),
      ),
    );
  }
}
