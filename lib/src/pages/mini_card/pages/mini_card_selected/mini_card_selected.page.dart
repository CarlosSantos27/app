import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futgolazo/src/bloc/mini_card/mini_card_bloc.dart';

import 'package:futgolazo/src/models/match.model.dart';
import 'package:futgolazo/src/enums/drag_target_enum.dart';
import 'package:futgolazo/src/components/widget/text_stroke.dart';
import 'package:futgolazo/src/pages/home/components/image_pet.dart';
import 'package:futgolazo/src/components/custom_scafold/statefull_custom.dart';

class MiniCardSelectedPage extends StateFullCustom {
  final String name;
  final Color selectedColor;
  final String selectedImage;
  final MatchModel matchModel;
  final MiniCardBloc miniCardBloc;
  final DragTargetEnum dragTargetEnum;

  MiniCardSelectedPage({
    Key key,
    this.name,
    this.matchModel,
    this.selectedImage,
    @required this.miniCardBloc,
    @required this.selectedColor,
    this.dragTargetEnum = DragTargetEnum.NONE,
  })  : assert(dragTargetEnum != null, 'dragTargetEnum can not be null'),
        assert(
            (dragTargetEnum != DragTargetEnum.DRAW && matchModel == null) ||
                (dragTargetEnum == DragTargetEnum.DRAW && matchModel != null),
            'You need to specify a match model only with DragTargetEnum.DRAW'),
        super(key: key);

  @override
  _MiniCardSelectedPageState createState() => _MiniCardSelectedPageState();
}

class _MiniCardSelectedPageState extends State<MiniCardSelectedPage> {
  bool isDraw = false;
  bool canPop = true;
  CancelableOperation _delayFuture;

  @override
  void initState() {
    super.initState();
    isDraw = widget.dragTargetEnum == DragTargetEnum.DRAW;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _delayFuture = CancelableOperation.fromFuture(
          Future.delayed(
            Duration(seconds: 2),
            () {
              if (canPop) {
                Navigator.maybePop(context);
                canPop = false;
              }
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _delayFuture?.cancel();
    widget.miniCardBloc.nextMatch();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          _delayFuture?.cancel();
          if (canPop) {
            Navigator.maybePop(context);
            canPop = false;
          }
        },
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            _buildBackground(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  _buildBackground() {
    return Container(
      child: SvgPicture.asset(
        'assets/backgrounds/bgMascotasMultiply.svg',
        fit: BoxFit.fill,
        color: widget.selectedColor,
        colorBlendMode: BlendMode.multiply,
      ),
    );
  }

  _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextStroke(
          'VOTASTE',
          style: widget.fontSize.headline1().copyWith(
                fontFamily: 'TitanOne',
              ),
          strokeWidth: 10.0,
        ),
        SizedBox(height: widget.responsive.hp(isDraw ? 5.5 : 1.0)),
        _buildTeamName(),
        SizedBox(height: widget.responsive.hp(isDraw ? 20.0 : 5.5)),
        if (!isDraw) _buildImage(),
        if (isDraw) _buildMatchData(),
      ],
    );
  }

  _buildTeamName() {
    final style = isDraw
        ? widget.fontSize.headline3().copyWith(color: Colors.black)
        : widget.fontSize.headline4().copyWith(color: Colors.black);
    return SizedBox(
      width: widget.responsive.wp(isDraw ? 70.0 : 40.0),
      child: Text(
        widget.name ?? '',
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  _buildImage() {
    return Transform(
      transform: Matrix4(
          widget.dragTargetEnum == DragTargetEnum.VISITANT ? -1 : 1,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          1),
      alignment: FractionalOffset.center,
      child: ImagePet(
        boxFit: BoxFit.contain,
        supportedTeam: widget.selectedImage,
      ),
    );
  }

  _buildMatchData() {
    final style = widget.fontSize
        .headline4()
        .copyWith(color: widget.colorsTheme.getColorOnButton);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.matchModel.local, style: style),
        Text('vs', style: style),
        Text(widget.matchModel.visitant, style: style),
      ],
    );
  }
}

Route buildMiniCardSelectedRoute({
  String name,
  String selectedImage,
  MatchModel matchModel,
  Color selectedColor = Colors.white,
  @required MiniCardBloc miniCardBloc,
  DragTargetEnum dragTargetEnum = DragTargetEnum.NONE,
}) {
  return PageRouteBuilder(
    pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
        MiniCardSelectedPage(
      name: name,
      matchModel: matchModel,
      miniCardBloc: miniCardBloc,
      selectedColor: selectedColor,
      selectedImage: selectedImage,
      dragTargetEnum: dragTargetEnum,
    ),
    transitionDuration: Duration(milliseconds: 800),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation =
          CurvedAnimation(parent: animation, curve: Curves.easeInOut);
      return SlideTransition(
        position: Tween<Offset>(
                begin: Offset(
                    dragTargetEnum == DragTargetEnum.LOCAL
                        ? -1.0
                        : dragTargetEnum == DragTargetEnum.VISITANT ? 1.0 : 0.0,
                    1.0),
                end: Offset.zero)
            .animate(curvedAnimation),
        child: FadeTransition(
            child: child,
            opacity:
                Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation)),
      );
    },
  );
}
