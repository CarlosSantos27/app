import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:futgolazo/src/enums/drag_target_enum.dart';
import 'package:futgolazo/src/bloc/mini_card/mini_card_bloc.dart';
import 'package:futgolazo/src/bloc/mini_card/drag_controller.dart';
import 'package:futgolazo/src/pages/home/components/image_pet.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';

class TeamTargetPrognostic extends StateLessCustom {
  final String name;
  final String petImage;
  final double diameter;
  final bool isVisitant;
  final Color teamPrimaryColor;
  final MiniCardBloc _miniCardBloc;
  final DragTargetEnum dragTargetEnum;

  final ColorFilter greyscale = ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);
  final ColorFilter normalFilter = ColorFilter.matrix(<double>[
    1.0,
    0.0,
    0.0,
    0,
    0,
    0.0,
    1.0,
    0.0,
    0,
    0,
    0.0,
    0.0,
    1.0,
    0,
    0,
    0.0,
    0.0,
    0.0,
    1.0,
    0,
  ]);

  TeamTargetPrognostic({
    @required this.name,
    this.teamPrimaryColor,
    @required this.petImage,
    @required this.diameter,
    this.isVisitant = false,
    @required this.dragTargetEnum,
  }) : _miniCardBloc = MiniCardBloc();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: responsive.wp(40.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildTeamName(),
          _buildTeamsPet(),
        ],
      ),
    );
  }

  _buildTeamName() {
    var padding = isVisitant
        ? EdgeInsets.only(right: responsive.wp(5))
        : EdgeInsets.only(left: responsive.wp(5));
    return Container(
      padding: padding,
      height: responsive.hp(7.5),
      child: Text(name),
    );
  }

  _buildTeamsPet() {
    return Expanded(
      child: Container(
        child: StreamBuilder<DragTargetModel>(
          initialData: DragTargetModel.seed(),
          stream: _miniCardBloc.dragTragetModel,
          builder: (context, snapshot) {
            var dragModel = snapshot.data;
            var calculatedProximity =
                (dragModel.dragTargetsEnum.contains(dragTargetEnum) ? 1 : -1) *
                    dragModel.proximityWitness;
            return Stack(
              overflow: Overflow.visible,
              children: [
                _backgroundIndicator(calculatedProximity),
                _teamImage(calculatedProximity),
                _buildDragTarget(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _backgroundIndicator(double proximityWitness) {
    if (proximityWitness < 0) {
      return Container();
    }

    double factor = isVisitant ? -1 : 1;
    var position = isVisitant ? responsive.hp(2) : -responsive.hp(47);

    double traslatePos = factor * 70 * proximityWitness;

    return Positioned(
      left: position,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: diameter - (diameter * .01 * (1 - proximityWitness)),
        width: diameter - (diameter * .01 * (1 - proximityWitness)),
        transform: Matrix4.identity()..translate(traslatePos),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            diameter,
          ),
          gradient: LinearGradient(
            colors: [
              teamPrimaryColor.withOpacity(
                  proximityWitness - .6 <= 0.0 ? 0.0 : proximityWitness - .6),
              teamPrimaryColor.withOpacity(proximityWitness)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(180),
          child: SvgPicture.asset(
            'assets/backgrounds/bgMascotasMultiply.svg',
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.multiply,
          ),
        ),
      ),
    );
  }

  Widget _teamImage(double proximityWitness) {
    double factor = isVisitant ? 1 : -1;
    double traslatePos =
        (factor * 40.0) + (factor * -1 * 40) * .75 * proximityWitness;
    return LayoutBuilder(
      builder: (context, constraints) {
        double heightContent = (constraints.maxHeight * .7);
        return OverflowBox(
          maxWidth: constraints.maxWidth * 2.5,
          child: AnimatedContainer(
            transform: Matrix4.identity()..translate(traslatePos),
            duration: Duration(milliseconds: 200),
            height: heightContent + (heightContent * .15 * proximityWitness),
            child: Transform(
              transform: Matrix4(isVisitant ? -1 : 1, 0, 0, 0, 0, 1, 0, 0, 0, 0,
                  1, 0, 0, 0, 0, 1),
              alignment: FractionalOffset.center,
              child: ColorFiltered(
                colorFilter: proximityWitness >= 0 ? normalFilter : greyscale,
                child: ImagePet(
                  boxFit: BoxFit.cover,
                  supportedTeam: petImage,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildDragTarget() {
    return Align(
      alignment: isVisitant ? Alignment.centerRight : Alignment.centerLeft,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return DragTarget(
            builder: (context, List<int> candidateData, rejectedData) {
              return Container(
                width: constraints.maxWidth * .75,
                height: constraints.maxHeight,
              );
            },
            onWillAccept: (data) => true,
            onAccept: (data) =>
                _miniCardBloc.selectedPronosticOption(context, dragTargetEnum),
          );
        },
      ),
    );
  }
}
