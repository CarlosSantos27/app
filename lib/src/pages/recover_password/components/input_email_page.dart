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

class InputEmailPage extends StateFullCustom {
  final RecoverPasswordBloc passwordBloc;

  InputEmailPage({this.passwordBloc}) : super();

  @override
  _InputEmailPageState createState() => _InputEmailPageState();
}

class _InputEmailPageState extends State<InputEmailPage>
    with AutomaticKeepAliveClientMixin {
  Responsive get responsive => widget.responsive;
  FontSizeThemes get fontSize => widget.fontSize;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    this.widget.passwordBloc.dispose();
    super.dispose();
  }

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
            height: responsive.hp(1.8),
          ),
          _subtitlePage(),
          SizedBox(
            height: responsive.hp(2.0),
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
          )
        ],
      ),
    );
  }

  Widget _titlePage() {
    return Container(
      width: responsive.wp(75.0),
      child: Text(
        '¡Rescatemos tu contraseña!',
        style: widget.textTheme.headline4.copyWith(
          color: widget.colorsTheme.getColorOnButton,
          fontStyle: FontStyle.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _subtitlePage() {
    return Container(
      width: responsive.wp(82.2),
      child: Text(
        'Te enviaremos una clave temporal a tu correo electrónico para crear una nueva contraseña',
        style: widget.textTheme.bodyText1.copyWith(
          color: widget.colorsTheme.getColorOnSecondary,
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
            _emailInput(),
            SizedBox(height: responsive.hp(2.7)),
            _createButton(),
          ],
        ),
      ),
    );
  }

  Widget _emailInput() {
    return StreamBuilder(
      stream: widget.passwordBloc.emailField.itemStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return CustomTextField(
          keyBoardType: TextInputType.emailAddress,
          errorText: snapshot.error,
          labelText: 'Email',
          hintText: 'Ingresa tu email',
          onChanged: widget.passwordBloc.emailField.addDataToStream,
        );
      },
    );
  }

  Widget _createButton() {
    return StreamBuilder(
      stream: widget.passwordBloc.emailField.itemStream
          .map<bool>((event) => event != null),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ButtonShadowRounded(
          width: double.infinity,
          child: Text('Enviar email de rescate'),
          onPressed: snapshot.hasData
              ? () => widget.passwordBloc.doSendEmailWithNewPassword()
              : () => widget.passwordBloc.showNoEmailError(),
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
