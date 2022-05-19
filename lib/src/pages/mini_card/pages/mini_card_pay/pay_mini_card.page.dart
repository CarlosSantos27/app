import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../env/env.router.dart';
import '../../../../components/widget/rive_button.dart';
import '../../../../bloc/mini_card/mini_card_bloc.dart';
import '../../../../components/widget/value_realtime.dart';
import '../../../../pages/mini_card/components/header_book.dart';
import '../../../../components/custom_scafold/statefull_custom.dart';
import '../../../../components/container_default/contain_default.dart';
import '../../../../components/widget/irregular_rounded_container.dart';

class PayMiniCard extends StateFullCustom {
  @override
  _PayMiniCardState createState() => _PayMiniCardState();
}

class _PayMiniCardState extends State<PayMiniCard> {
  MiniCardBloc _miniCardBloc;

  @override
  void initState() {
    super.initState();
    _miniCardBloc = MiniCardBloc();
  }

  @override
  Widget build(BuildContext context) {
    return FutgolazoScaffold(
      withBackButton: true,
      body: Column(
        children: <Widget>[
          _buildHeadPayment(),
          _buildBodyPayment(),
        ],
      ),
    );
  }

  Widget _buildHeadPayment() {
    return Container(
      color: widget.colorsTheme.getColorBackgroundDarkest,
      height: widget.responsive.hp(62),
      child: Column(
        children: <Widget>[
          HeaderBook(
            subtitle: 'Inversión de envío',
          ),
          _buildContainerCost()
        ],
      ),
    );
  }

  Expanded _buildContainerCost() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.responsive.wp(20),
        ),
        margin: EdgeInsets.only(bottom: widget.responsive.hp(5)),
        child: IrregularRoundedContainer(
          backgroundColor: widget.colorsTheme.getColorPrimary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildCostMiniCard('1'),
              SizedBox(
                width: widget.responsive.wp(3),
              ),
              _buildBalonDiamond(),
            ],
          ),
        ),
      ),
    );
  }

  Image _buildBalonDiamond([double width, double height]) => Image.asset(
        'assets/common/moneda_diamante.png',
        width: width,
        height: height,
      );

  Text _buildCostMiniCard(String number) {
    return Text(
      number,
      style: _defineStyle(12),
    );
  }

  Widget _buildBodyPayment() {
    return Container(
      width: double.infinity,
      height: widget.responsive.hp(38) - Get.mediaQuery.padding.top,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: widget.responsive.hp(1)),
            child: Text(
              'Si aciertas los ${_miniCardBloc.currentMiniCard.matches.length} partidos puedes ganar',
              style: widget.fontSize
                  .bodyText2(color: widget.colorsTheme.getColorOnButton),
              textAlign: TextAlign.center,
            ),
          ),
          _buildContainerGain(),
          _buildButtonPay(),
        ],
      ),
    );
  }

  Container _buildContainerGain() {
    return Container(
      width: widget.responsive.wp(70),
      child: ContainerDefault(
        background: widget.colorsTheme.getColorBackgroundDarkest,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildNumberGain(),
            SizedBox(
              width: widget.responsive.wp(3),
            ),
            _buildBalonDiamond(widget.responsive.wp(12)),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonPay() {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.responsive.hp(2)),
      child: RiveButton(
        width: widget.responsive.wp(83),
        buttonText: 'Continuar',
        responsive: widget.responsive,
        onTapButton: () {
          _miniCardBloc.sendMiniCard();
        },
      ),
    );
  }

  ValueRealtime _buildNumberGain() {
    return ValueRealtime(
      miniCardSyncName: EnvironmentConfig().environment.miniCardSync,
      showDolar: false,
      style: _defineStyle(6),
    );
  }

  TextStyle _defineStyle(double fontSizePercentage) {
    return widget.fontSize.headline1().copyWith(
          fontFamily: 'TitanOne',
          fontSize: widget.responsive.ip(
            fontSizePercentage,
          ),
        );
  }
}
