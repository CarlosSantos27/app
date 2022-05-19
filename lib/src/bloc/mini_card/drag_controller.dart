import 'dart:async';
import 'dart:math' as math;
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/utils/responsive.dart';
import 'package:futgolazo/src/enums/drag_target_enum.dart';

class DragTargetModel {
  double proximityWitness;
  List<DragTargetEnum> dragTargetsEnum;

  DragTargetModel({
    this.proximityWitness,
    this.dragTargetsEnum,
  });

  DragTargetModel.seed() {
    proximityWitness = 0.0;
    dragTargetsEnum = [DragTargetEnum.NONE];
  }
}

class AuxModel {
  Offset targetPosition;
  double proximityWitness;
  DragTargetEnum dragTargetsEnum;

  AuxModel({
    this.targetPosition,
    this.dragTargetsEnum,
    this.proximityWitness,
  });
}

class DragController {
  double _position;
  Offset _middlePoint;
  List<AuxModel> _targetPositions;
  bool _isWitnessBeingDrag = false;

  BehaviorSubject<Offset> _draggableWitnessPositian$ =
      BehaviorSubject<Offset>.seeded(Offset(0, 0));
  StreamSubscription<Offset> _witnessPositionSubscription;

  //** GETTER && SETTERS */
  Stream<Offset> get witnessPosition => _draggableWitnessPositian$.stream;

  BehaviorSubject<DragTargetModel> dragModel$ =
      BehaviorSubject<DragTargetModel>.seeded(DragTargetModel.seed());

  void init(Responsive responsive) {
    _position = responsive.wp(100) * .35;

    _middlePoint = Offset(
      responsive.wp(100) * .5,
      responsive.hp(100) * .5,
    );

    _targetPositions = [
      AuxModel(
        dragTargetsEnum: DragTargetEnum.LOCAL,
        targetPosition: Offset(_middlePoint.dx - _position, _middlePoint.dy),
        proximityWitness: 1.0,
      ),
      AuxModel(
        dragTargetsEnum: DragTargetEnum.VISITANT,
        targetPosition: Offset(_middlePoint.dx + _position, _middlePoint.dy),
        proximityWitness: 1.0,
      ),
      AuxModel(
        dragTargetsEnum: DragTargetEnum.DRAW,
        targetPosition: Offset(_middlePoint.dx, _middlePoint.dy + _position),
        proximityWitness: 1.0,
      ),
    ];
    _witnessPositionSubscription = _draggableWitnessPositian$
        .listen((value) => _setDragModelPositions(value));
  }

  void dispose() {
    _draggableWitnessPositian$?.close();
    _witnessPositionSubscription.cancel();
  }

  void startDrag() {
    _isWitnessBeingDrag = true;
  }

  void changeDraggableWitnessPosition(Offset offset) {
    _draggableWitnessPositian$.add(offset);
  }

  void restartProximity() {
    _isWitnessBeingDrag = false;
    dragModel$.add(DragTargetModel.seed());
    _targetPositions.forEach((element) {
      element.proximityWitness = 1.0;
    });
  }

  void _setDragModelPositions(Offset offset) {
    if (!_isWitnessBeingDrag) return;

    double lowestDistance = 2.0;
    List<DragTargetEnum> targets = [];

    for (var i = 0; i < _targetPositions.length; i++) {
      AuxModel item = _targetPositions[i];
      double distance = _getDistanceBetween(
          item.targetPosition, offset, item.dragTargetsEnum);
      distance = distance / _position;
      item.proximityWitness = distance;
      if (distance < lowestDistance) {
        lowestDistance = distance;
      }
    }

    for (var i = 0; i < _targetPositions.length; i++) {
      var item = _targetPositions[i];
      double distance = item.proximityWitness;
      if (distance <= lowestDistance) {
        targets.add(item.dragTargetsEnum);
      }
    }
    dragModel$.add(DragTargetModel(
      dragTargetsEnum: targets,
      proximityWitness: 1 - lowestDistance,
    ));
  }

  double _getDistanceBetween(
    Offset start,
    Offset end,
    DragTargetEnum targetEnum,
  ) {
    if (targetEnum == DragTargetEnum.DRAW) {
      if (start.dy - end.dy < 0) {
        return 0;
      }
      double dy = start.dy - end.dy;
      return math.sqrt(dy * dy);
    }

    if (targetEnum == DragTargetEnum.LOCAL) {
      if (end.dx - start.dx < 0) {
        return 0;
      }
    }

    if (targetEnum == DragTargetEnum.VISITANT) {
      if (start.dx - end.dx < 0) {
        return 0;
      }
    }
    double dx = start.dx - end.dx;
    return math.sqrt(dx * dx);
  }
}
