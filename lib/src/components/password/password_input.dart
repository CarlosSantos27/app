import 'package:flutter/material.dart';

import 'package:futgolazo/src/components/widget/custom_text_field.dart';

class PasswordInput extends StatefulWidget {
  final passwordStream;
  final setPasswordFunct;
  final String labelText;
  final String hintText;
  const PasswordInput({
    Key key,
    this.hintText,
    @required this.passwordStream,
    @required this.setPasswordFunct,
    this.labelText = 'Contraseña',
  }) : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return CustomTextField(
          hintText: widget.hintText,
          obscureText: _passwordVisible,
          labelText: widget.labelText,
          errorText: snapshot.error,
          suffixIcon: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          onChanged: widget.setPasswordFunct,
        );
      },
    );
  }
}
