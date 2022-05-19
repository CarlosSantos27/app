import 'package:flutter/material.dart';
import 'package:futgolazo/src/routes/routes.dart';
import 'package:get/get.dart';

import '../../../models/resume_book.model.dart';
import '../../../components/custom_scafold/stateless_custom.dart';

class ItemResult extends StateLessCustom {
  final ResumeBookModel resumeBookModel;

  ItemResult({this.resumeBookModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> Get.toNamed(NavigationRoute.MY_RESULTS,arguments: resumeBookModel),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            responsive.ip(1.5),
          ),
        ),
        padding: EdgeInsets.all(responsive.ip(1.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              resumeBookModel.cardDescription,
              style: fontSize.headline6(color: colorsTheme.getColorOnButton),
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildCardSection(
                  'Cartillas enviadas',
                  resumeBookModel.cardCount.toString(),
                ),
                SizedBox(
                  width: responsive.wp(5),
                ),
                _buildCardSection(
                  'Ganaste',
                  resumeBookModel.prizeAmount.toInt().toString(),
                  resumeBookModel.prizeAmount > 0
                      ? colorsTheme.getColorBackgroundVariant
                      : colorsTheme.getColorError,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Expanded _buildCardSection(String label, String value, [Color background]) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(responsive.ip(1)),
        decoration: BoxDecoration(
          color: background ?? colorsTheme.getColorOnSecondary,
          borderRadius: BorderRadius.circular(
            responsive.ip(.95),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: fontSize.bodyText2(
                  color: colorsTheme.getColorOnSurface,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: fontSize
                    .headline3(
                      color: colorsTheme.getColorOnSurface,
                    )
                    .copyWith(
                      fontFamily: 'TitanOne',
                    ),
                textAlign: TextAlign.end,
              ),
            )
          ],
        ),
      ),
    );
  }
}
