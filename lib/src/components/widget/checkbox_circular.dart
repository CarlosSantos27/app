import 'package:flutter/material.dart';
import 'package:futgolazo/src/components/custom_scafold/statefull_custom.dart';

class CheckBoxCircular extends StateFullCustom {
  final bool value;
  final double radio;
  final ValueChanged<bool> onChanged;
  final bool border;
  final Color background;
  final Color borderColor;

  CheckBoxCircular({
    @required this.value,
    @required this.onChanged,
    this.radio = 10,
    this.background,
    this.border = false,
    this.borderColor,
  });

  @override
  _CheckBoxCircularState createState() => _CheckBoxCircularState();
}

class _CheckBoxCircularState extends State<CheckBoxCircular> {
  bool tempValue;
  double width = 0.0;
  double height = 0.0;

  @override
  Widget build(BuildContext context) {
    tempValue = widget.value;
    width = tempValue ? widget.radio : 0.0;
    height = tempValue ? widget.radio : 0.0;

    return InkWell(
      onTap: () {
        tempValue = !tempValue;
        widget.onChanged(tempValue);
      },
      child: Container(
        height: widget.radio * 2,
        width: widget.radio * 2,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.radio),
          border: !widget.border
              ? null
              : Border.all(
                  color:
                      widget.borderColor ?? widget.background ?? widget.colorsTheme.getColorOnSurface,
                  width: widget.responsive.ip(.2),
                ),
        ),
        padding: EdgeInsets.all(5),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOutCirc,
          alignment: Alignment.center,
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: widget.background ?? widget.colorsTheme.getColorOnSurface,
            borderRadius: BorderRadius.circular(widget.radio),
          ),
        ),
      ),
    );
  }
}
