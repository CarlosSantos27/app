import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../../components/custom_scafold/stateless_custom.dart';

class CircularShield extends StateLessCustom {
  final String url;
  final double radio;
  
  CircularShield({
    @required this.url,
    @required this.radio,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radio),
      child: Container(
        width: radio * 2,
        height: radio * 2,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            OverflowBox(
              maxHeight: radio * 3,
              maxWidth: radio * 3,
              child: Container(
                width: radio * 3,
                height: radio * 3,
                color: Colors.brown,
                child: CachedNetworkImage(
                  imageUrl: url,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
