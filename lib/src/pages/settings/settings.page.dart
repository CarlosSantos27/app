import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:futgolazo/src/components/container_default/contain_default.dart';
import 'package:futgolazo/src/components/custom_scafold/statefull_custom.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';
import 'package:futgolazo/src/components/dialogs/dialogs.dart';
import 'package:futgolazo/src/components/widget/text_stroke.dart';
import 'package:futgolazo/src/enums/terms_politics.enum.dart';
import 'package:futgolazo/src/pages/simple_signin/terms_conditions_page/terms_politics_page.dart';
import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class SettingsPage extends StateFullCustom {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool soundActive = true;

  @override
  void initState() {
    super.initState();
    soundActive = !GetIt.I<PoolServices>().audioService.isMute;
  }

  @override
  Widget build(BuildContext context) {
    return FutgolazoScaffold(
      appBar: _buildAppBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(
          horizontal: widget.responsive.wp(4.0),
          vertical: widget.responsive.hp(2.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTitle(),
            SizedBox(height: widget.responsive.hp(2.0)),
            Flexible(
                child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCardItem(_buildSoundOption(), null),
                  _buildCardItem(Text('Términos y Condiciones'),
                      () => _showTermsPage(TermsPoliticsEnum.TERMS)),
                  _buildCardItem(Text('Política de privacidad'),
                      () => _showTermsPage(TermsPoliticsEnum.POLITICS)),
                ],
              ),
            )),
            SizedBox(height: widget.responsive.hp(2.0)),
            _buildLogOut(),
          ],
        ),
      ),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: Container(),
      actions: [
        IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: widget.responsive.ip(4.0),
          ),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          padding: EdgeInsets.all(0.0),
          visualDensity: VisualDensity.compact,
          onPressed: () => Navigator.maybePop(context),
        ),
        SizedBox(width: widget.responsive.wp(2.0)),
      ],
    );
  }

  _buildTitle() {
    return TextStroke(
      'AJUSTES',
      strokeWidth: 8.0,
    );
  }

  _buildLogOut() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Cerrar Sesión',
            style: widget.fontSize.headline6().copyWith(
                color: widget.colorsTheme.getColorOnButton,
                decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()..onTap = _showConfirmLogOut,
          )
        ],
      ),
    );
  }

  _buildSoundOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Text('Sonido del juego')),
        Switch(
          value: soundActive,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: widget.colorsTheme.getColorOnButton,
          activeTrackColor: widget.colorsTheme.getColorOnPrimary,
          inactiveThumbColor: widget.colorsTheme.getColorSurface,
          onChanged: (value) {
            soundActive = value;
            GetIt.I<PoolServices>().audioService.mute(soundActive);
            setState(() {});
          },
        ),
      ],
    );
  }

  _buildCardItem(Widget child, Function onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: ContainerDefault(
            child: DefaultTextStyle(
                style: widget.fontSize.headline4(), child: child),
          ),
        ),
        SizedBox(height: widget.responsive.hp(1.2)),
      ],
    );
  }

  _showTermsPage(TermsPoliticsEnum termsPoliticsEnum) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return TermsPoliticsPage(termsPoliticsEnum);
      }),
    );
  }

  _showConfirmLogOut() async {
    final action = await Dialogs.customYesCancelDialog(context,
        title: '¿Está seguro?',
        body: Text(
          'Se cerrará la sesión actual y volverá a la pantalla inicial',
          style: widget.fontSize
              .headline6()
              .copyWith(color: widget.colorsTheme.getColorOnButton),
          textAlign: TextAlign.center,
        ),
        dismissible: true,
        radius: widget.responsive.ip(2.0));
    if (action == DialogAction.yes) {
      GetIt.I<PoolServices>().authService.logout();
      Get.offNamedUntil(NavigationRoute.INTRO, (Route<dynamic> route) => false);
    }
  }
}
