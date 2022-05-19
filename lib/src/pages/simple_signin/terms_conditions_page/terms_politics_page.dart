import 'package:flutter/material.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';
import 'package:futgolazo/src/components/futgolazo_scaffold/back_button.dart';
import 'package:futgolazo/src/components/futgolazo_scaffold/futgolazo_scaffold.dart';
import 'package:futgolazo/src/components/widget/text_stroke.dart';
import 'package:futgolazo/src/enums/terms_politics.enum.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsPoliticsPage extends StateLessCustom {
  final TermsPoliticsEnum showType;

  TermsPoliticsPage(this.showType);

  @override
  Widget build(BuildContext context) {
    String url =
        'https://trivia.futgolazo.com/${showType == TermsPoliticsEnum.POLITICS ? 'politics-privacy/politics-privacy.html' : 'politics-conditions/politics-conditions.html'}';
    return FutgolazoScaffold(
      appBar: _buildAppBar(),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  _buildAppBar() {
    return PreferredSize(
      child: AppBar(
        backgroundColor: colorsTheme.getColorBackground,
        leading: BackButtonWidget(),
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(bottom: responsive.ip(2.0)),
            width: responsive.wp(83.0),
            child: TextStroke(
              showType == TermsPoliticsEnum.POLITICS
                  ? 'Política de\nprivacidad'.toUpperCase()
                  : 'Términos y\ncondiciones'.toUpperCase(),
              style: fontSize.headline4().copyWith(
                    fontFamily: 'TitanOne',
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      preferredSize: Size.fromHeight(
        responsive.hp(22.2),
      ),
    );
  }
}
