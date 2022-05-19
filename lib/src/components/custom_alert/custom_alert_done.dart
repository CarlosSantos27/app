import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:futgolazo/src/services/pool_services.dart';

class CustomAlertDone extends StatelessWidget {
  final String bodyMessage;
  final String title;
  final Widget icon;
  
  final mainTheme = GetIt.I<PoolServices>().futgolazoMainTheme;

  CustomAlertDone(this.title,this.bodyMessage, this.icon);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
          child: Container(
            width: constraints.maxWidth * .9,
            padding: EdgeInsets.all(mainTheme.getResponsive.ip(1)),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: mainTheme.getColorsTheme.getColorOnPrimary,
              ),
              borderRadius: BorderRadius.circular(
                mainTheme.getResponsive.wp(4),
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: mainTheme.getResponsive.wp(15),
                  height: mainTheme.getResponsive.wp(15),
                  child: icon,
                ),
                SizedBox(
                  width: mainTheme.getResponsive.wp(4),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: mainTheme.getFontSize.bodyText1(
                          color: mainTheme.getColorsTheme.getColorBackground,
                        ),
                      ),
                      SizedBox(
                        height: mainTheme.getResponsive.hp(0.3),
                      ),
                      Text(
                        bodyMessage,
                        style: mainTheme.getFontSize.bodyText2(
                          color: mainTheme.getColorsTheme.getColorBackground,
                        ),
                      ),
                    ],
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
