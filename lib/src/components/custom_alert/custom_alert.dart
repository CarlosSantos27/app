import 'package:get_it/get_it.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:futgolazo/src/services/pool_services.dart';

class CustomAlert extends StatelessWidget {
  final String errorMessage;
  final mainTheme = GetIt.I<PoolServices>().futgolazoMainTheme;

  CustomAlert(this.errorMessage);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
          child: Container(
            width: constraints.maxWidth * .8,
            padding: EdgeInsets.all(mainTheme.getResponsive.ip(1)),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: mainTheme.getColorsTheme.getColorError),
              borderRadius:
                  BorderRadius.circular(mainTheme.getResponsive.wp(4)),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: mainTheme.getResponsive.wp(10),
                  height: mainTheme.getResponsive.wp(10),
                  child: SvgPicture.asset(
                    'assets/common/alert/Ico_Trivia_Silbato.svg',
                    color: mainTheme.getColorsTheme.getColorError,
                  ),
                ),
                SizedBox(
                  width: mainTheme.getResponsive.wp(4),
                ),
                Expanded(
                  child: Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: mainTheme.getFontSize
                        .bodyText2(color: mainTheme.getColorsTheme.getColorError),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
