import 'package:flutter/material.dart';
import 'package:futgolazo/src/bloc/recover_password/recover_password_bloc.dart';
import 'package:futgolazo/src/components/container_default/contain_default.dart';
import 'package:futgolazo/src/components/custom_scafold/statefull_custom.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';
import 'package:futgolazo/src/components/halo_image/halo_image.dart';
import 'package:futgolazo/src/components/widget/button_shadow_rounded.dart';
import 'package:futgolazo/src/components/widget/custom_text_field.dart';
import 'package:futgolazo/src/themes/font_size_themes.dart';
import 'package:futgolazo/src/utils/responsive.dart';

class PasswordPage extends StateFullCustom {
  final RecoverPasswordBloc passwordBloc;

  PasswordPage({this.passwordBloc}) : super();

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage>
    with AutomaticKeepAliveClientMixin {
  Responsive get responsive => widget.responsive;
  FontSizeThemes get fontSize => widget.fontSize;
  bool _visibleTempPasword = true,
      _visibleNewPassword = true,
      _visibleConfirmPasword = true;
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutgolazoScaffold(
      withBackButton: true,
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: AppBar().preferredSize.height,
      ),
      physics: ClampingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _logoTrivia(),
          _titlePage(),
          SizedBox(
            height: responsive.hp(2),
          ),
          _buildForm(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: widget.responsive.hp(3.3)),
            child: _buildPrivacyPolicy(),
          ),
        ],
      ),
    );
  }

  Widget _logoTrivia() {
    return Container(
      height: responsive.hp(33.6),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          OverflowBox(
            child: HaloImage(),
          ),
          SizedBox(
            width: responsive.wp(53.6),
            child: Image.asset(
              'assets/common/logo.png',
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ],
      ),
    );
  }

  Widget _titlePage() {
    return Container(
      width: responsive.wp(75.0),
      child: Text(
        'Crea una nueva contraseña',
        style: widget.textTheme.headline4.copyWith(
          color: widget.colorsTheme.getColorOnButton,
          fontStyle: FontStyle.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildForm() {
    return SizedBox(
      width: widget.responsive.wp(90.0),
      child: ContainerDefault(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _oldPassword(),
            SizedBox(height: responsive.hp(2.3)),
            _createPassword(),
            SizedBox(height: responsive.hp(2.3)),
            _createRepeatPassword(),
            SizedBox(height: responsive.hp(2.7)),
            _createButton(),
          ],
        ),
      ),
    );
  }

  Widget _oldPassword() {
    return StreamBuilder(
      stream: widget.passwordBloc.oldPasswordField.itemStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return CustomTextField(
          conditioned: false,
          labelText: 'Contraseña temporal',
          obscureText: this._visibleTempPasword,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
          errorText: snapshot.error,
          suffixIcon: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              this._visibleTempPasword
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                this._visibleTempPasword = !this._visibleTempPasword;
              });
            },
          ),
          onChanged: widget.passwordBloc.oldPasswordField.addDataToStream,
        );
      },
    );
  }

  Widget _createPassword() {
    return StreamBuilder(
      stream: widget.passwordBloc.passwordField.itemStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return CustomTextField(
          conditioned: false,
          hintText: 'Crea una contraseña',
          obscureText: this._visibleNewPassword,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
          errorText: snapshot.error,
          suffixIcon: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              this._visibleNewPassword
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                this._visibleNewPassword = !this._visibleNewPassword;
              });
            },
          ),
          onChanged: widget.passwordBloc.passwordField.addDataToStream,
        );
      },
    );
  }

  Widget _createRepeatPassword() {
    return StreamBuilder(
      stream: widget.passwordBloc.repeatedPasswordField,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return CustomTextField(
          conditioned: false,
          obscureText: this._visibleConfirmPasword,
          hintText: 'Repetir la contraseña',
          errorText: snapshot.error,
          suffixIcon: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              this._visibleConfirmPasword
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                this._visibleConfirmPasword = !this._visibleConfirmPasword;
              });
            },
          ),
          onChanged: widget.passwordBloc.repeatedPassword$.sink.add,
        );
      },
    );
  }

  Widget _createButton() {
    return StreamBuilder(
      stream: widget.passwordBloc.firstScreenValidForm,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ButtonShadowRounded(
          width: double.infinity,
          child: Text('Confirmar'),
          onPressed: snapshot.hasData
              ? () => widget.passwordBloc.doChangePassword()
              : () => widget.passwordBloc.showNoPasswordError(),
        );
      },
    );
  }

  Widget _buildPrivacyPolicy() {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: 'Política de privacidad',
        style: widget.fontSize.bodyText2().copyWith(
              color: widget.colorsTheme.getColorOnButton,
              decoration: TextDecoration.underline,
            ),
      ),
    ]));
  }
}
