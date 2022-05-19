import 'package:flutter/material.dart';

import './components/team_item.dart';
import '../../models/team.model.dart';
import '../../models/country_group.model.dart';
import '../../bloc/user_team/user_team_block.dart';
import '../../components/custom_scafold/statefull_custom.dart';
import '../../pages/select_team/components/country_drop_down.dart';
import '../../components/futgolazo_scaffold/futgolazo_scaffold.dart';

class SelectTeam extends StateFullCustom {
  @override
  _SelectTeamState createState() => _SelectTeamState();
}

class _SelectTeamState extends State<SelectTeam> {
  UserTeamBloc _userTeamBloc;

  @override
  void initState() {
    _userTeamBloc = UserTeamBloc();
    super.initState();
  }

  @override
  void dispose() {
    _userTeamBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutgolazoScaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: widget.responsive.hp(5),
          horizontal: widget.responsive.wp(6),
        ),
        width: widget.responsive.wp(100),
        height: widget.responsive.hp(100),
        child: Column(
          children: <Widget>[
            _header(),
            _dropDownCountryList(),
            _teamStreamBuilder(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: widget.responsive.wp(70),
      child: Text(
        'Selecciona el equipo preferido de tu país',
        style: widget.fontSize.getTextTheme.headline4.copyWith(
          color: widget.colorsTheme.getColorOnButton,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _dropDownCountryList() {
    return StreamBuilder(
      stream: _userTeamBloc.countriesStream,
      builder: (BuildContext contex,
          AsyncSnapshot<List<CountryGroupModel>> snapshot) {
        List<CountryGroupModel> countries = snapshot.data;
        if (snapshot.hasData) {
          return Container(
            margin: EdgeInsets.symmetric(
              vertical: widget.responsive.hp(4),
            ),
            width: widget.responsive.wp(82),
            child: CountryDropDown(
              countryList: countries,
              onSelectedCountry: _selectedCountry,
              currentCountry: _userTeamBloc.selectedCountry,
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _teamStreamBuilder() {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return StreamBuilder(
            stream: _userTeamBloc.teamsStream,
            builder:
                (BuildContext contex, AsyncSnapshot<List<TeamModel>> snapshot) {
              if (snapshot.hasData) {
                List<TeamModel> teams = snapshot.data;
                return _teamsComponent(constraints.maxHeight, teams);
              }
              return Container();
            },
          );
        },
      ),
    );
  }

  Widget _teamsComponent(double heightParent, List<TeamModel> teams) {
    return Container(
      height: heightParent,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: teams.length,
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) => SizedBox(
          height: widget.responsive.hp(4),
        ),
        itemBuilder: (BuildContext ctxt, int index) {
          return TeamItem(
            teamModel: teams[index],
            onSelectedTeam: _selectedTeam,
          );
        },
      ),
    );
  }

  void _selectedCountry(CountryGroupModel country) {
    _userTeamBloc.setCountryGroup(country);
  }

  void _selectedTeam(TeamModel selectedTeam) {
    _userTeamBloc.saveSalectedTeam(selectedTeam);
  }
}
