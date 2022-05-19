import 'package:flutter/material.dart';
import 'package:futgolazo/src/components/custom_alert/custom_alert.dart';

class NotInternetComponent<T> extends StatelessWidget {
  final Future<T> future;
  final Stream<T> stream;
  final AsyncWidgetBuilder<T> builder;
  const NotInternetComponent({
    Key key,
    this.future,
    this.builder,
    this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.future != null ? _buildFutureBuilder() : _buildStreamBuilder();
  }

  Widget _buildStreamBuilder() {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        return _validateSnapshot(context, snapshot);
      },
    );
  }

  Widget _buildFutureBuilder() {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        return _validateSnapshot(context,snapshot);
      },
    );
  }

  Widget _validateSnapshot(BuildContext context, AsyncSnapshot<T> snapshot){
    if (snapshot.hasError) {
          return _showErrorMesage(snapshot.error);
        }
        return snapshot.hasData ? this.builder(context, snapshot) : Container();
  }

  Widget _showErrorMesage(String errorMsg) {
    return Center(
      child: Container(
        // width: _responsive.wp(90),
        child: CustomAlert(
          errorMsg,
        ),
      ),
    );
  }
}
