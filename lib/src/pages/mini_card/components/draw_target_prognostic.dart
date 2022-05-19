import 'package:flutter/material.dart';

import 'package:futgolazo/src/enums/drag_target_enum.dart';
import 'package:futgolazo/src/bloc/mini_card/mini_card_bloc.dart';
import 'package:futgolazo/src/bloc/mini_card/drag_controller.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';

class DrawTargetPrognostic extends StateLessCustom {
  final double diameter;
  final MiniCardBloc _miniCardBloc;
  final DragTargetEnum dragTargetEnum;

  DrawTargetPrognostic({
    this.diameter,
    this.dragTargetEnum,
  }) : _miniCardBloc = MiniCardBloc();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: responsive.wp(30.0),
      child: _buildStreamData(),
    );
  }

  _buildStreamData() {
    return StreamBuilder<DragTargetModel>(
      initialData: DragTargetModel.seed(),
      stream: _miniCardBloc.dragTragetModel,
      builder: (context, AsyncSnapshot<DragTargetModel> snapshot) {
        final dragModel = snapshot.data;
        final calculatedProximity =
            (dragModel.dragTargetsEnum.contains(dragTargetEnum) ? 1 : -1) *
                dragModel.proximityWitness;
        return Stack(
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: [
            _backgroundIndicator(calculatedProximity),
            _buildDragTarget(context),
          ],
        );
      },
    );
  }

  Widget _backgroundIndicator(double proximityWitness) {
    double translatePos = 20 * proximityWitness;

    return Positioned(
      bottom: -diameter * .78,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: diameter + translatePos,
        width: diameter + translatePos,
        transform: Matrix4.identity()..translate(0.0, -translatePos),
        alignment: Alignment.topCenter,
        padding:
            EdgeInsets.only(top: diameter * (0.11 + (proximityWitness / 20.0))),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            diameter,
          ),
          color: proximityWitness > 0.5
              ? Colors.white
              : colorsTheme.getColorPrimary,
        ),
        child: Text(
          'Empatan',
          style: fontSize.bodyText1().copyWith(
              color: proximityWitness > 0.5
                  ? colorsTheme.getColorPrimary
                  : proximityWitness < 0
                      ? Colors.white.withOpacity(0.5)
                      : Colors.white),
        ),
      ),
    );
  }

  Widget _buildDragTarget(BuildContext _context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: DragTarget(
        builder: (BuildContext context, List<int> candidateData, rejectedData) {
          return Container(
            width: diameter,
            height: diameter * .25,
          );
        },
        onWillAccept: (data) => true,
        onAccept: (data) {
          _miniCardBloc.selectedPronosticOption(_context, dragTargetEnum);
        },
      ),
    );
  }
}
