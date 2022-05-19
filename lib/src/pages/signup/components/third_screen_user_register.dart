import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:futgolazo/src/enums/terms_politics.enum.dart';
import 'package:futgolazo/src/pages/simple_signin/terms_conditions_page/terms_politics_page.dart';

import 'package:get/get.dart';

import '../../../bloc/signup/signup_bloc.dart';
import '../../../bloc/base/validation_item_block.dart';
import '../../../components/halo_image/halo_image.dart';
import '../../../components/widget/custom_text_field.dart';
import '../../../components/widget/button_shadow_rounded.dart';
import '../../../components/custom_scafold/statefull_custom.dart';
import '../../../components/container_default/contain_default.dart';

class ThirdScreenUserRegister extends StateFullCustom {
  final SignUpBloc signupBloc;

  ThirdScreenUserRegister({Key key, this.signupBloc}) : super(key: key);

  @override
  _SecondScreenUserRegisterState createState() =>
      _SecondScreenUserRegisterState();
}

class _SecondScreenUserRegisterState extends State<ThirdScreenUserRegister>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widget.responsive.wp(5)),
      child: SingleChildScrollView(
        child: Container(
          height: widget.responsive.hp(100) - Get.mediaQuery.padding.top,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: widget.responsive.hp(45) - Get.mediaQuery.padding.top,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    HaloImage(),
                    Image.asset('assets/common/logo.png'),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: widget.responsive.wp(90),
                        child: Text(
                          '¿Cómo quieres que te llame?',
                          style: widget.fontSize
                              .headline4(
                                color: widget.colorsTheme.getColorOnButton,
                              )
                              .copyWith(
                                fontSize: widget.responsive.ip(2.5),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: widget.responsive.hp(5)),
                child: Column(
                  children: <Widget>[
                    ContainerDefault(
                      child: Column(
                        children: <Widget>[
                          _builInput(widget.signupBloc.firstNameField, 'Nombre',
                              'Ingresa tu nombre'),
                          SizedBox(
                            height: widget.responsive.hp(1.5),
                          ),
                          _builInput(
                            widget.signupBloc.lastNameField,
                            'Apellido',
                            'Ingresa tu apellido',
                          ),
                          SizedBox(
                            height: widget.responsive.hp(1.5),
                          ),
                          _builInput(
                            widget.signupBloc.nickNameField,
                            'Nickname',
                            'Ingresa tu nickname',
                          ),
                          SizedBox(
                            height: widget.responsive.hp(1.5),
                          ),
                          _buildButtonConfirm()
                        ],
                      ),
                    ),
                    SizedBox(
                      height: widget.responsive.hp(2),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Políticas de privacidad',
                        style: widget.fontSize
                            .bodyText2(
                              color: widget.colorsTheme.getColorOnButton,
                            )
                            .copyWith(decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _showTermsPage(TermsPoliticsEnum.TERMS);
                          },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonConfirm() {
    return StreamBuilder(
      stream: widget.signupBloc.secondScreenValidForm,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ButtonShadowRounded(
          width: double.infinity,
          child: Text('Confirmar'),
          onPressed:
              snapshot.hasData ? widget.signupBloc.gotoThirdScreen : null,
        );
      },
    );
  }

  _builInput(ValidationItemBloc item, String labelText, String hintText) {
    return StreamBuilder(
      stream: item.itemStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return CustomTextField(
          labelText: labelText,
          hintText: hintText,
          errorText: snapshot.error,
          onChanged: item.addDataToStream,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  _showTermsPage(TermsPoliticsEnum termsPoliticsEnum) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return TermsPoliticsPage(termsPoliticsEnum);
      }),
    );
  }
}
