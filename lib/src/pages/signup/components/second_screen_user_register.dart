import 'package:flutter/material.dart';

import '../../../models/country.model.dart';
import '../../../bloc/signup/signup_bloc.dart';
import '../../../components/widget/custom_text_field.dart';
import '../../../components/widget/button_shadow_rounded.dart';
import '../../../components/custom_scafold/statefull_custom.dart';
import '../../../components/container_default/contain_default.dart'; 

class SecondScreenUserRegister extends StateFullCustom {
  final SignUpBloc signupBloc;

  SecondScreenUserRegister({Key key, this.signupBloc})
      : super(key: key);

  @override
  _SecondScreenUserRegisterState createState() =>
      _SecondScreenUserRegisterState();
}

class _SecondScreenUserRegisterState extends State<SecondScreenUserRegister>
    with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: widget.responsive.hp(100),
      padding: EdgeInsets.symmetric(horizontal: widget.responsive.wp(5)),
      child: Center(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Text(
            'Registrate',
            style: widget.fontSize.headline3(
              color: widget.colorsTheme.getColorOnSurface
            ),
          ),
          SizedBox(
            height: widget.responsive.hp(3),
          ),
          ContainerDefault(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: widget.responsive.hp(2),
                ),
                _buildCountriesWidget(),
                SizedBox(
                  height: widget.responsive.hp(3),
                ),
                _buildCellPhoneContainer(),
                SizedBox(
                  height: widget.responsive.hp(5),
                ),
                _createNewUserButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //** COUNTRY DROPDOWN */
  Widget _buildCountriesWidget() {
    return StreamBuilder<List<CountryInfo>>(
      stream: widget.signupBloc.countries$,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildCountriesDropDown(snapshot.data);
        }
        return _buildCountriesDropDown([]);
      },
    );
  }

  Widget _buildCountriesDropDown(List<CountryInfo> countries) {
    Widget uiBuilder = StreamBuilder(
      stream: widget.signupBloc.countryController.itemStream,
      initialData: widget.signupBloc.currentCountryInfo,
      builder: (context, snapshot) {
        return DropdownButton<CountryInfo>(
          dropdownColor: widget.colorsTheme.getColorBackground,
          isExpanded: true,
          hint: Text(
            'País de residencia',
            style: widget.fontSize.bodyText2(
              color: widget.colorsTheme.getColorSurface,
            ),
          ),
          underline: Container(),
          icon: Container(
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_drop_down,
                color: widget.colorsTheme.getColorOnButton,
                size: widget.responsive.ip(3),
              ),
            ),
          ),
          value: snapshot?.data,
          isDense: true,
          items: countries.map(
            (CountryInfo value) {
              return new DropdownMenuItem<CountryInfo>(
                value: value,
                child: new Text(
                  value.name,
                  style: widget.fontSize.bodyText2(color: widget.colorsTheme.getColorOnButton),
                ),
              );
            },
          ).toList(),
          onChanged: widget.signupBloc.countryController.addDataToStream,
        );
      },
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.responsive.ip(2),
        vertical: widget.responsive.ip(2),
      ),
      decoration: BoxDecoration(
          color: widget.colorsTheme.getColorSecondary,
          borderRadius: BorderRadius.circular(8.0)),
      child: uiBuilder,
    );
  }

  //** CELLPHONE */
  Widget _buildCellPhoneContainer() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildSelectedCountryCode(),
          SizedBox(
            width: widget.responsive.wp(5),
          ),
          _buildCellPhone(),
        ],
      ),
    );
  }

  Widget _buildSelectedCountryCode() {
    return Container(
      height: 50,
      child: Align(
        alignment: Alignment(0, .5),
        child: StreamBuilder(
          stream: widget.signupBloc.countryController.itemStream,
          initialData: widget.signupBloc.currentCountryInfo,
          builder: (context, AsyncSnapshot<CountryInfo> snapshot) {
            return snapshot.hasData
                ? Text(
                    snapshot.data.phoneCode,
                    style: widget.fontSize.headline5(color: widget.colorsTheme.getColorOnButton),
                  )
                : Text('+');
          },
        ),
      ),
    );
  }

  Widget _buildCellPhone() {
    return Expanded(
      child: StreamBuilder(
        stream: widget.signupBloc.cellPhoneField.itemStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return CustomTextField(
            labelText: 'Teléfono',
            hintText: 'Ingrese Teléfono',
            onChanged: widget.signupBloc.cellPhoneField.addDataToStream,
            errorText: snapshot.error,
            keyBoardType: TextInputType.number,
          );
        },
      ),
    );
  }

  //** BUTTONS */
  Widget _createNewUserButton() {
    return StreamBuilder(
      stream: widget.signupBloc.cellPhoneField.itemStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ButtonShadowRounded(
          onPressed: snapshot.hasData ? widget.signupBloc.doRegister : null,
          width: double.infinity,
          child: Text(
            'Registrarme',
            style: widget.fontSize.bodyText1(
              color: widget.colorsTheme.getColorOnSecondary,
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
