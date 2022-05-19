import 'package:flutter/material.dart';

class GeneralThemes {
  GeneralThemes();

  List<BoxShadow> getBoxShadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(.15),
        spreadRadius: 1,
        blurRadius: 2,
        offset: Offset(2, 3),
      ),
    ];
  }
}
