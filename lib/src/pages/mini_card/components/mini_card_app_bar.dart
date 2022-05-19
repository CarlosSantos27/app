import 'package:flutter/material.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';
import 'package:futgolazo/src/components/futgolazo_scaffold/back_button.dart';
import 'package:futgolazo/src/pages/mini_card/components/container_dot.dart';

class MiniCardAppBar extends StateLessCustom {
  final int itemCount;
  final int currentIndex;

  MiniCardAppBar({this.itemCount, this.currentIndex});

  @override
  Widget build(BuildContext context) {
    double height = responsive.hp(6.8);
    return SafeArea(
      bottom: false,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          left: responsive.wp(4.0),
          right: responsive.wp(4.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            BackButtonWidget(),
            SizedBox(
              width: responsive.wp(6),
            ),
            Expanded(
              child: ContainerDot(
                height: height,
                itemCount: itemCount,
                currentIndex: currentIndex,
              ),
            )
          ],
        ),
      ),
    );
  }
}
