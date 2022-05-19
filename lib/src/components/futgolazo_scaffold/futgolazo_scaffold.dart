import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';
import 'package:futgolazo/src/components/futgolazo_scaffold/back_button.dart';

class FutgolazoScaffold extends StateLessCustom {
  final Widget body;
  final bool primary;
  final Widget drawer;
  final bool showHeader;
  final bool withBackButton;
  final Widget endDrawer;
  final Widget bottomSheet;
  final Color backgroundColor;
  final Color drawerScrimColor;
  final double drawerEdgeDragWidth;
  final PreferredSizeWidget appBar;
  final Widget bottomNavigationBar;
  final Widget floatingActionButton;
  final bool resizeToAvoidBottomInset;
  final bool resizeToAvoidBottomPadding;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final List<Widget> persistentFooterButtons;
  final DragStartBehavior drawerDragStartBehavior;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final FloatingActionButtonAnimator floatingActionButtonAnimator;

  FutgolazoScaffold({
    Key key,
    this.body,
    this.appBar,
    this.floatingActionButton,
    this.persistentFooterButtons,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomPadding,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.showHeader = false,
    this.withBackButton = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      primary: primary,
      appBar: appBar,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      resizeToAvoidBottomPadding: resizeToAvoidBottomPadding,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      floatingActionButtonLocation: floatingActionButtonLocation,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              child: body,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: bottomNavigationBar,
            ),
            if (withBackButton) _buildBackButton(),
          ],
        ),
      ),
    );
  }

  _buildBackButton() {
    return Positioned(
      top: responsive.hp(1.0),
      left: responsive.wp(2.0),
      child: BackButtonWidget(),
    );
  }
}
