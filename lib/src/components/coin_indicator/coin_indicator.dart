import 'package:flutter/material.dart';

import 'package:futgolazo/src/enums/coin_type.enum.dart';
import 'package:futgolazo/src/components/widget/text_stroke.dart';
import 'package:futgolazo/src/components/custom_scafold/statefull_custom.dart';

class CoinIndicator extends StateFullCustom {
  final int coinNumber;
  final CoinTypeEnum type;
  final VoidCallback onSelectedCoinIndicator;
  final int maxLength;

  CoinIndicator({
    this.coinNumber,
    this.type,
    this.onSelectedCoinIndicator,
    this.maxLength,
  });

  @override
  _CoinIndicatorState createState() => _CoinIndicatorState();
}

class _CoinIndicatorState extends State<CoinIndicator> {
  double widthCoin;

  @override
  void initState() {
    widthCoin = widget.responsive.ip(6.5 + (0.2 * widget.maxLength));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: widget.responsive.wp(26),
      width: widthCoin * 1.8,
      height: widget.responsive.hp(6.5),
      margin: EdgeInsets.only(left: widget.responsive.wp(1)),
      decoration: BoxDecoration(
        color: widget.colorsTheme.getColorBackground,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0)),
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          OverflowBox(
            alignment: Alignment(-1.7, 0.0),
            maxHeight: widget.responsive.ip(6.5),
            maxWidth: widthCoin,
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(widget.responsive.ip(3.5)),
                  color: widget.colorsTheme.getColorPrimary,
                  border: Border.all(color: Colors.black, width: 3.0)),
              child: Image.asset(
                CoinTypeEnum.DIAMOND_COIN == widget.type
                    ? 'assets/common/moneda_diamante.png'
                    : 'assets/common/moneda_oro.png',
              ),
            ),
          ),
          _buildNumberCoin()
        ],
      ),
    );
  }

  Widget _buildNumberCoin() {
    return Container(
      margin: EdgeInsets.only(right: widget.responsive.wp(3)),
      child: TextStroke(
        widget.coinNumber.toString(),
        style: widget.fontSize.headline3().copyWith(
              fontFamily: 'TitanOne',
              fontSize: _fontSize(),
            ),
      ),
    );
  }

  double _fontSize() {
    return widget.responsive.ip(
      4 - (widget.maxLength > 2 ? 0.05 * widget.maxLength : 0.0),
    );
  }
}
