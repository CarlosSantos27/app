import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/services/pool_services.dart';

class SearchInput extends StatefulWidget {
  final Function(String) setSearchTeam;
  final Stream<String> searchTeamStream;

  SearchInput({
    Key key,
    @required this.searchTeamStream,
    @required this.setSearchTeam,
  }) : super(key: key);

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final _futgolazoMainTheme = GetIt.I<PoolServices>().futgolazoMainTheme;

  var _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: _futgolazoMainTheme.getFontSize.subtitle1(),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        suffixIcon: StreamBuilder(
          stream: widget.searchTeamStream,
          builder: (BuildContext contex, AsyncSnapshot<String> snapshot) {
            return GestureDetector(
              onTap: () => snapshot.hasData && snapshot.data.length > 0
                  ? _clearInputText()
                  : null,
              child: Icon(
                snapshot.hasData && snapshot.data.length > 0
                    ? Icons.close
                    : Icons.search,
                color: _futgolazoMainTheme.getColorsTheme.getColorSurface,
                size: _futgolazoMainTheme.getResponsive.ip(2),
              ),
            );
          },
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: _futgolazoMainTheme.getResponsive.wp(10),
          vertical: _futgolazoMainTheme.getResponsive.hp(1),
        ),
        filled: true,
        fillColor: _futgolazoMainTheme.getColorsTheme.getColorBackground,
        labelText: 'Buscar tu Equipo',
        labelStyle: TextStyle(color: Color.fromRGBO(250, 250, 250, 0.4)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        errorStyle: TextStyle(
            color: _futgolazoMainTheme.getColorsTheme.getColorSecondary),
      ),
      onChanged: widget.setSearchTeam,
    );
  }

  void _clearInputText() {
    widget.setSearchTeam('');
    _controller.clear();
    setState(() {});
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
