import 'package:flutter/material.dart';

import '../../../models/my_results.model.dart';
import '../../../components/widget/text_stroke.dart';
import '../../../components/custom_scafold/stateless_custom.dart';
import '../../../components/container_default/contain_default.dart';

class CardPrizeResult extends StateLessCustom {
  final MyResultsModel result;
  CardPrizeResult({
    this.result,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCardPrize(result);
  }

  _buildCardPrize(MyResultsModel result) {
    return ContainerDefault(
      background: result.totalHits == result.matches.length
          ? colorsTheme.getColorBackgroundVariant
          : colorsTheme.getColorOnButton,
      child: Container(
        height: responsive.hp(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: _buildSectionPrize(result),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${result.totalHits}/${result.matches.length} aciertos',
                  style: fontSize.headline6(),
                ),
                Text(
                  'Apostaste 1',
                  style: fontSize.headline6(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionPrize(MyResultsModel result) {
    return result.totalHits == result.matches.length
        ? Container(
            child: Column(
              children: <Widget>[
                Text(
                  'Ganaste',
                  style: fontSize.headline6(),
                ),
                TextStroke(
                  result.earnedAmount.toString(),
                  style: fontSize.headline1().copyWith(
                        fontFamily: 'TitanOne',
                        fontSize: responsive.ip(8),
                      ),
                )
              ],
            ),
          )
        : Center(
            child: Text(
              'No ganaste esta vez',
              style: fontSize.headline5(),
            ),
          );
  }
}
