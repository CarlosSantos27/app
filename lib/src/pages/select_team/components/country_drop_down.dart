import 'dart:math' as math;
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:futgolazo/src/env/env.model.dart';

import '../../../services/pool_services.dart';
import '../../../models/country_group.model.dart';
import '../../../components/custom_scafold/stateless_custom.dart';

class CountryDropDown extends StateLessCustom {
  final Function onSelectedCountry;
  final CountryGroupModel currentCountry;
  final List<CountryGroupModel> countryList;

  final EnvModel env = GetIt.I<PoolServices>().environment.environment;

  CountryDropDown({
    @required this.countryList,
    @required this.currentCountry,
    @required this.onSelectedCountry,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCountriesDropDown();
  }

  Widget _buildCountriesDropDown() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: responsive.hp(1),
        horizontal: responsive.wp(5),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: colorsTheme.getColorOnButton,
      ),
      child: DropdownButton<CountryGroupModel>(
        dropdownColor: colorsTheme.getColorBackground,
        isExpanded: true,
        hint: _hintText(),
        underline: Container(),
        icon: Container(
          child: Align(
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: math.pi / 2,
              child: Icon(
                Icons.arrow_forward_ios,
                color: colorsTheme.getColorSurface,
                size: responsive.ip(3),
              ),
            ),
          ),
        ),
        value: currentCountry,
        isDense: true,
        items: countryList.map(
          (CountryGroupModel value) {
            return DropdownMenuItem<CountryGroupModel>(
              value: value,
              child: _flagAndName(
                value.name,
                value.name,
              ),
            );
          },
        ).toList(),
        onChanged: onSelectedCountry,
      ),
    );
  }

  Widget _hintText() {
    print(currentCountry.name);
    return Container(
      child: _flagAndName(
        currentCountry.name,
        currentCountry.name,
      ),
    );
  }

  Widget _flagAndName(String countryName, String countryLabel) {
    return Row(
      children: [
        _badgeWidget(countryLabel),
        SizedBox(
          width: responsive.wp(4),
        ),
        Text(
          countryName,
          style: fontSize.bodyText2(
            color: colorsTheme.getColorSurface,
          ),
        ),
      ],
    );
  }

  Widget _badgeWidget(String countryName) {
    return Container(
      width: responsive.wp(10),
      child: Image.network(
        '${env.imagePath}team_badges/$countryName.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
