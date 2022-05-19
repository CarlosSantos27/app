import 'package:flutter/material.dart';

import '../../bloc/signup/signup_bloc.dart';
import './components/user_code_validation.dart';
import './components/first_screen_user_register.dart';
import './components/second_screen_user_register.dart';
import '../../components/futgolazo_scaffold/futgolazo_scaffold.dart';
import '../../pages/signup/components/third_screen_user_register.dart';

class SignUp extends StatefulWidget {
  final int page;
  const SignUp({Key key, this.page = 0}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  SignUpBloc signUpBloc;
  PageController _pageController;

  @override
  void initState() {
    this._pageController = PageController(
      initialPage: widget.page ?? 0,
    );
    this.signUpBloc = SignUpBloc(pageController: _pageController);
    super.initState();
  }

  @override
  void dispose() {
    this.signUpBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutgolazoScaffold(
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        physics: new NeverScrollableScrollPhysics(),
        children: <Widget>[
          FirstScreenUserRegister(signupBloc: signUpBloc),
          ThirdScreenUserRegister(signupBloc: signUpBloc),
          SecondScreenUserRegister(signupBloc: signUpBloc),
          UserCodeValidation(signupBloc: signUpBloc),
        ],
      ),
    );
  }
}
