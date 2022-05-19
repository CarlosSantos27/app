import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'components/password_page.dart';
import 'components/input_email_page.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/themes/futgolazo_theme.dart';
import 'package:futgolazo/src/bloc/recover_password/recover_password_bloc.dart';
import 'package:futgolazo/src/components/futgolazo_scaffold/futgolazo_scaffold.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({Key key}) : super(key: key);

  @override
  _RecoverPasswordPageState createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  FutgolazoMainTheme theme;
  PageController _pageController;
  RecoverPasswordBloc _passwordBloc;

  @override
  void initState() {
    this._pageController = PageController(
      initialPage: 0,
    );
    this._passwordBloc = RecoverPasswordBloc(pageController: _pageController);
    this.theme = GetIt.I<PoolServices>().futgolazoMainTheme;
    super.initState();
  }

  @override
  void dispose() {
    this._passwordBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutgolazoScaffold(
      body: Container(
        height: theme.getResponsive.hp(100),
        child: Container(
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            physics: new NeverScrollableScrollPhysics(),
            children: <Widget>[
              InputEmailPage(passwordBloc: _passwordBloc),
              PasswordPage(passwordBloc: _passwordBloc),
            ],
          ),
        ),
      ),
    );
  }
}
