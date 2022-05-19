import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/components/custom_scafold/statefull_custom.dart';

class CustomDialog extends StateFullCustom {
  final Widget body;
  final EdgeInsets insetPadding;
  CustomDialog({
    @required this.body,
    this.insetPadding,
  });

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: new Duration(milliseconds: 400))
      ..addListener(() => setState(() {}));

    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOutBack);
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      insetPadding: widget.insetPadding,
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _dialogContent(context),
        ],
      ),
    );
  }

  Widget _dialogContent(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: Stack(
        children: [
          this.widget.body,
          _closeButton(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  Widget _closeButton() {
    return Align(
      alignment: Alignment(1, 0),
      child: IconButton(
        icon: Icon(
          Icons.close,
          color: widget.colorsTheme.getColorSurface,
        ),
        onPressed: () => Get.back(),
      ),
    );
  }
}
