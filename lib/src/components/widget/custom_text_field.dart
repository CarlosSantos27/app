import 'package:flutter/material.dart';
import 'package:futgolazo/src/components/custom_scafold/statefull_custom.dart';

class CustomTextField extends StateFullCustom {
  final Key key;
  final TextInputType keyBoardType;
  final TextInputAction textInputAction;
  final String labelText;
  final String hintText;
  final int maxLength;
  final String errorText;
  final bool obscureText;
  final bool readOnly;
  final bool conditioned;
  final Widget suffixIcon;
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function onEditingComplete;

  /// Text Field genérico para formularios
  /// Bordes redondeados
  /// Label oculto por defecto y se muestra con el foco
  CustomTextField({
    this.key,
    this.labelText,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.maxLength,
    this.controller,
    this.onEditingComplete,
    this.conditioned = true,
    this.suffixIcon,
    this.readOnly = false,
    this.obscureText = false,
    this.keyBoardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextEditingController controller;
  FocusNode focusNode;
  String labelText;

  @override
  void initState() {
    focusNode = FocusNode();
    controller = widget.controller ?? TextEditingController();
    super.initState();
    if (widget.conditioned ?? true) {
      focusNode.addListener(() {
        if (focusNode.hasFocus || controller.text.isNotEmpty) {
          labelText = widget.labelText;
        } else {
          labelText = null;
        }
        setState(() {});
      });
    } else {
      labelText = widget.labelText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: widget.maxLength,
      key: widget.key,
      focusNode: focusNode,
      controller: controller,
      style: widget.textTheme.bodyText2.copyWith(
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        color: widget.colorsTheme.getColorOnSecondary,
      ),
      onEditingComplete: widget.onEditingComplete,
      keyboardType: widget.keyBoardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: widget.hintText,
        labelStyle: new TextStyle(color: widget.colorsTheme.getColorOnButton),
        hintStyle: new TextStyle(color: widget.colorsTheme.getColorOnButton),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.transparent, width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.transparent, width: 1.0),
        ),
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        fillColor: widget.colorsTheme.getColorSecondary,
        filled: true,
        suffixIcon: widget.suffixIcon,
        isDense: false,
        errorText: widget.errorText,
        errorStyle: TextStyle(color: widget.colorsTheme.getColorError),
      ),
      onChanged: widget.onChanged,
    );
  }
}
