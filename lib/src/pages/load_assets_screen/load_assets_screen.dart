import 'package:flutter/material.dart';
import 'package:futgolazo/src/bloc/load_assets/load_assets_block.dart';

class LoadAssetsScreen extends StatelessWidget {
  final LoadAssetsBloc _loadAssetsBloc = LoadAssetsBloc();

  LoadAssetsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: _loadAssetsBloc.loadingStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text('data');
          } else {
            return Text('loading');
          }
        },
      ),
    );
  }
}
