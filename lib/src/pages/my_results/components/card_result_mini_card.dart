import 'dart:math';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../../../env/env.router.dart';
import '../../../models/match.model.dart';
import '../../../enums/drag_target_enum.dart';
import '../../../components/widget/checkbox_circular.dart';
import '../../../components/custom_scafold/statefull_custom.dart';
import '../../../components/container_default/contain_default.dart';

class CardResultMiniCard extends StateFullCustom {
  final MatchModel match;

  CardResultMiniCard({
    this.match,
  });
  @override
  _CardResultMiniCardState createState() => _CardResultMiniCardState();
}

class _CardResultMiniCardState extends State<CardResultMiniCard> {
  @override
  Widget build(BuildContext context) {
    return ContainerDefault(
      child: Column(
        children: <Widget>[
          _buildTeamRow(),
          _buildContentPrognosticResult(),
        ],
      ),
    );
  }

  Container _buildTeamRow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: _buildContentTeam(
              widget.match.localBadgeImgUrl,
              widget.match.local,
              DragTargetEnum.LOCAL,
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildContentPrognostic(),
          ),
          Expanded(
            flex: 1,
            child: _buildContentTeam(
              widget.match.visitantBadgeImgUrl,
              widget.match.visitant,
              DragTargetEnum.VISITANT,
            ),
          ),
        ],
      ),
    );
  }

  _buildContentTeam(String imageTeam, String teamName, DragTargetEnum compare) {
    return Container(
      width: widget.responsive.wp(30),
      child: Column(
        children: <Widget>[
          _buildImageTeam(imageTeam),
          SizedBox(
            height: widget.responsive.hp(1.5),
          ),
          _buildText(
            teamName,
            compare == widget.match.prognostic
                ? widget.colorsTheme.getColorSurface
                : null,
          ),
        ],
      ),
    );
  }

  _buildText(String teamName, [Color color]) {
    return Text(
      teamName,
      style: widget.fontSize.bodyText2(
        color: color ?? widget.colorsTheme.getColorOnButton,
      ),
      textAlign: TextAlign.center,
    );
  }

  _buildImageTeam(String teamImage) {
    return Container(
      width: max(widget.responsive.wp(15), 50.0),
      height: min(widget.responsive.wp(15), 50.0),
      child: CachedNetworkImage(
        imageUrl: EnvironmentConfig().environment.imagePath +
            "team_badges/$teamImage.png",
        // height: widget.responsive.wp(15),
      ),
    );
  }

  _buildContentPrognostic() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildResultMatch(
            widget.match.localScore.toString(),
            widget.match.localScore,
            widget.match.visitantScore,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.responsive.wp(1),
            ),
            child: Text('-', style: widget.fontSize.headline3()),
          ),
          _buildResultMatch(
            widget.match.visitantScore.toString(),
            widget.match.visitantScore,
            widget.match.localScore,
          ),
        ],
      ),
    );
  }

  _buildResultMatch(String value, int compareTo, int compareFrom) {
    final color = compareTo > compareFrom
        ? widget.colorsTheme.getColorBackgroundVariant
        : compareTo < compareFrom
            ? widget.colorsTheme.getColorError
            : Colors.white;

    return Text(
      value,
      style: widget.fontSize.headline3(color: color),
    );
  }

  _buildContentPrognosticResult() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: widget.responsive.hp(2),
      ),
      margin: EdgeInsets.only(top: widget.responsive.hp(3)),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 2.0,
            color: widget.colorsTheme.getColorSecondary,
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          _buildText('Tu apuesta'),
          SizedBox(
            height: widget.responsive.hp(2.5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _buildPrognosticSelected('Local', DragTargetEnum.LOCAL),
              ),
              Expanded(
                flex: 1,
                child: _buildPrognosticSelected('Empate', DragTargetEnum.DRAW),
              ),
              Expanded(
                flex: 1,
                child: _buildPrognosticSelected(
                  'Visitante',
                  DragTargetEnum.VISITANT,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Container _buildPrognosticSelected(
    String label,
    DragTargetEnum compareStatus,
  ) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CheckBoxCircular(
            borderColor: widget.colorsTheme.getColorSurface,
            radio: widget.responsive.ip(2.5),
            value: widget.match.prognostic == compareStatus,
            border: true,
            background: widget.match.prognostic == compareStatus
                ? widget.match.prognostic == widget.match.matchResult
                    ? widget.colorsTheme.getColorBackgroundVariant
                    : widget.colorsTheme.getColorOnError
                : widget.colorsTheme.getColorSurface,
            onChanged: (status) {},
          ),
          SizedBox(
            height: widget.responsive.hp(1),
          ),
          _buildText(
            label,
            widget.match.prognostic == compareStatus ? Colors.white : null,
          ),
        ],
      ),
    );
  }
}
