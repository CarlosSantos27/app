import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:futgolazo/src/bloc/mini_card/mini_card_bloc.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';

class DraggableWitness extends StateLessCustom {
  final MiniCardBloc _miniCardBloc;
  DraggableWitness() : _miniCardBloc = MiniCardBloc();

  @override
  Widget build(BuildContext context) {
    return _draggableButton();
  }

  Widget _draggableButton() {
    return Listener(
      onPointerMove: (pointer) {
        Offset pos = Offset(pointer.position.dx, pointer.position.dy - 55.5);
        _miniCardBloc.changeDraggableWitnessPosition(pos);
      },
      child: Draggable<int>(
        data: 1,
        feedback: Container(
          width: math.max(
            responsive.wp(20),
            90,
          ),
          child: Image.asset(
            'assets/mini_card/drag_witness.png',
          ),
        ),
        childWhenDragging: Container(),
        child: Container(
          width: math.max(
            responsive.wp(20),
            90,
          ),
          child: Image.asset(
            'assets/mini_card/drag_witness.png',
          ),
        ),
        onDragStarted: () => _miniCardBloc.startDrag(),
        onDraggableCanceled: (velocity, offset) {
          _miniCardBloc.restartProximity();
        },
      ),
    );
  }
}
