import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:futgolazo/src/components/widget/text_stroke.dart';
import 'package:futgolazo/src/components/custom_scafold/statefull_custom.dart';

class ValueRealtime extends StateFullCustom {
  final String miniCardSyncName;
  final bool showDolar;
  final TextStyle style;

  ValueRealtime({
    this.style,
    @required this.miniCardSyncName,
    this.showDolar = true,
  });

  @override
  _ValueRealtimeState createState() => _ValueRealtimeState();
}

class _ValueRealtimeState extends State<ValueRealtime> {
  DatabaseReference _databaseReference;

  @override
  void initState() {
    _databaseReference =
        FirebaseDatabase.instance.reference().child(widget.miniCardSyncName);
    _databaseReference.keepSynced(true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _databaseReference.onValue,
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
        return Container(
          child: TextStroke(
            '${snapshot.hasData ? snapshot.data.snapshot.value.toString() : '0'}' +
                (widget.showDolar ? '\$' : ''),
            color: widget.colorsTheme.getColorBackgroundDarkest,
            strokeWidth: 8.0,
            style: widget.style ??
                widget.fontSize.headline2().copyWith(
                      fontFamily: 'TitanOne',
                    ),
          ),
        );
      },
    );
  }
}
