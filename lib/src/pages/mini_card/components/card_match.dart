import 'dart:math';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../../../env/env.router.dart';
import '../../../models/match.model.dart';
import '../../../utils/date_for_human.dart';
import '../../../enums/drag_target_enum.dart';
import '../../../components/widget/checkbox_circular.dart';
import '../../../components/custom_scafold/statefull_custom.dart';
import '../../../components/container_default/contain_default.dart';

class CardMatchContainer extends StateFullCustom {
  final MatchModel match;
  final bool readOnly;

  CardMatchContainer({@required this.match, this.readOnly = false});

  @override
  _CardMatchContainerState createState() => _CardMatchContainerState();
}

class _CardMatchContainerState extends State<CardMatchContainer> {
  DateForHuman _dateForHuman;

  @override
  void initState() {
    _dateForHuman = DateForHuman(widget.match.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ContainerDefault(
      child: Column(
        children: <Widget>[
          _buildTeamRow(),
          _buildContentPrognostic(),
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
            child: _buildDateString(),
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

  _buildDateString() {
    final date = _dateForHuman.dayWeek.substring(0, 3) +
        ',\n${_dateForHuman.dateFormatString('dd/mm')}\n\n${_dateForHuman.time}';
    return _buildText(date);
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
            compare == widget.match.matchResult
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
                    'Visitante', DragTargetEnum.VISITANT),
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
            radio: widget.responsive.ip(2.5),
            value: (widget.readOnly
                    ? widget.match.prognostic
                    : widget.match.matchResult) ==
                compareStatus,
            border: true,
            background: widget.colorsTheme.getColorSurface,
            onChanged: (status) {
              if (widget.readOnly) return;
              setState(() {
                widget.match.matchResult = compareStatus;
              });
            },
          ),
          SizedBox(
            height: widget.responsive.hp(1),
          ),
          _buildText(
            label,
            widget.match.matchResult == compareStatus ? Colors.white : null,
          ),
        ],
      ),
    );
  }
}
