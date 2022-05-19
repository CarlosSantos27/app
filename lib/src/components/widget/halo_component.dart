import 'package:flutter/material.dart';
import 'package:futgolazo/src/components/halo_image/halo_image.dart';

class HaloWidget extends StatelessWidget {
  final Widget child;

  const HaloWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        return OverflowBox(
          maxWidth: constraints.maxWidth * 1.1,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform.translate(
                offset: Offset(0, (constraints.maxHeight * .05) * -1),
                child: Container(
                  child: HaloImage()
                ),
              ),
              child != null ? child : Container(),
            ],
          ),
        );
      },
    );
  }
}
