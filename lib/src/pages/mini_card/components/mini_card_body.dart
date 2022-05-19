import 'package:flutter/material.dart';

import 'package:futgolazo/src/models/match.model.dart';
import 'package:futgolazo/src/enums/drag_target_enum.dart';
import 'package:futgolazo/src/components/jump_animation/jump_animation.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';
import 'package:futgolazo/src/pages/mini_card/components/draggable_witness.dart';
import 'package:futgolazo/src/pages/mini_card/components/draw_target_prognostic.dart';
import 'package:futgolazo/src/pages/mini_card/components/team_target_prognostic.dart';

class MiniCardBody extends StateLessCustom {
  final MatchModel currentMatch;

  MiniCardBody({
    Key key,
    this.currentMatch,
  });

  @override
  Widget build(BuildContext context) {
    double diameter = responsive.wp(115);
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.center,
      children: [
        _buildLocalTeam(diameter),
        _buildVisitantTeam(diameter),
        _buildDrawOption(diameter),
        _buildDraggableWitness(),
      ],
    );
  }

  Widget _buildLocalTeam(double diameter) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TeamTargetPrognostic(
        diameter: diameter,
        name: currentMatch.local,
        dragTargetEnum: DragTargetEnum.LOCAL,
        petImage: currentMatch.localBadgeImgUrl,
        teamPrimaryColor: currentMatch.localPrimaryColor,
      ),
    );
  }

  Widget _buildVisitantTeam(double diameter) {
    return Align(
      alignment: Alignment.centerRight,
      child: TeamTargetPrognostic(
        isVisitant: true,
        diameter: diameter,
        name: currentMatch.visitant,
        dragTargetEnum: DragTargetEnum.VISITANT,
        petImage: currentMatch.visitantBadgeImgUrl,
        teamPrimaryColor: currentMatch.visitantPrimaryColor,
      ),
    );
  }

  Widget _buildDrawOption(double diameter) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: DrawTargetPrognostic(
        diameter: diameter,
        dragTargetEnum: DragTargetEnum.DRAW,
      ),
    );
  }

  Widget _buildDraggableWitness() {
    return Align(
      alignment: Alignment.center,
      child: JumpAnimation(
        child: DraggableWitness(),
      ),
    );
  }
}
