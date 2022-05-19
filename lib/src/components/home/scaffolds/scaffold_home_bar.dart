import 'package:flutter/material.dart';
import 'package:futgolazo/src/components/bar_bottom/bar_bottom.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';
import 'package:futgolazo/src/components/home/header/header_bar.dart';

class ScaffoldHomeBar extends StateLessCustom {
  /// Widget content of scaffold component
  final Widget body;
  final BarBottomOption barBottomOption;

  ScaffoldHomeBar({
    Key key,
    @required this.body,
    this.barBottomOption = BarBottomOption.HOME,
  })  : assert(body != null, 'body parameter is required'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _buildContent(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: responsive.hp(1.0),
                  horizontal: responsive.ip(2.0),
                ),
                child: BarBottom(selectOption: barBottomOption),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildContent() {
    return Column(
      children: [
        HeaderBar(),
        Expanded(child: body),
      ],
    );
  }
}
