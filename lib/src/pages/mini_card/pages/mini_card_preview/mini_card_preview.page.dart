import 'package:flutter/material.dart';
import 'package:futgolazo/src/components/widget/rive_button.dart';
import 'package:futgolazo/src/routes/routes.dart';

import 'package:get/get.dart';

import '../../../../models/book.model.dart';
import '../../../../models/match.model.dart';
import '../../../../bloc/mini_card/mini_card_bloc.dart';
import '../../../../pages/mini_card/components/card_match.dart';
import '../../../../pages/mini_card/components/header_book.dart';
import '../../../../components/custom_scafold/statefull_custom.dart';
import '../../../../components/container_default/contain_default.dart';

class MiniCardPreviewPage extends StateFullCustom {
  MiniCardPreviewPage({Key key}) : super(key: key);
  @override
  _MiniCardPreviewPageState createState() => _MiniCardPreviewPageState();
}

class _MiniCardPreviewPageState extends State<MiniCardPreviewPage> {
  MiniCardBloc _miniCardBloc;
  BookModel book;
  @override
  void initState() {
    super.initState();
    _miniCardBloc = MiniCardBloc();
    book = _miniCardBloc.currentMiniCard;
  }

  @override
  Widget build(BuildContext context) {
    return FutgolazoScaffold(
      withBackButton: false,
      body: Column(
        children: <Widget>[
          _buildHeadContainer(),
          _buildBodyPreview(),
        ],
      ),
    );
  }

  Container _buildHeadContainer() {
    return Container(
      height: widget.responsive.hp(40),
      child: Column(
        children: <Widget>[
          HeaderBook(
            height: widget.responsive.hp(15),
            subtitle: 'Confirma tu jugada',
            background: Colors.transparent,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: widget.responsive.wp(85),
                  child: ContainerDefault(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Tu inversión',
                          style: widget.fontSize.headline6(
                            color: widget.colorsTheme.getColorOnButton,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '1',
                              style: _defineStyle(8),
                            ),
                            SizedBox(
                              width: widget.responsive.wp(2),
                            ),
                            _buildBalonDiamond(
                              widget.responsive.ip(7),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Image _buildBalonDiamond([double width, double height]) => Image.asset(
        'assets/common/moneda_diamante.png',
        width: width,
        height: height,
      );

  TextStyle _defineStyle(double fontSizePercentage) {
    return widget.fontSize.headline1().copyWith(
          fontFamily: 'TitanOne',
          fontSize: widget.responsive.ip(
            fontSizePercentage,
          ),
        );
  }

  _buildBodyPreview() {
    return Container(
      height: widget.responsive.hp(60) - Get.mediaQuery.padding.top,
      padding: EdgeInsets.only(
        left: widget.responsive.wp(3),
        right: widget.responsive.wp(3),
        top: widget.responsive.hp(4),
      ),
      color: widget.colorsTheme.getColorBackgroundDarkest,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        separatorBuilder: (_, int index) {
          return SizedBox(
            height: 15.0,
          );
        },
        itemCount: book.matches.length + 2,
        itemBuilder: (_, int index) {
          return index == 0 || index == book.matches.length + 1
              ? _buildButtonSendBook(index == book.matches.length + 1)
              : _buildCardMatch(book.matches[index - 1]);
        },
      ),
    );
  }

  _buildButtonSendBook(bool marginBotton) {
    return Container(
      margin: marginBotton
          ? EdgeInsets.only(bottom: widget.responsive.hp(2))
          : null,
      child: RiveButton(
        responsive: widget.responsive,
        buttonText: 'Enviar cartilla',
        onTapButton: () => Get.toNamed(NavigationRoute.MINI_CARD_PAY),
      ),
    );
  }

  _buildCardMatch(MatchModel match) {
    return CardMatchContainer(
      match: match,
    );
  }
}
