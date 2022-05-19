import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../routes/routes.dart';
import '../../../../env/env.router.dart';
import '../../../../models/book.model.dart';
import '../../../../components/widget/rive_button.dart';
import '../../../mini_card/components/header_book.dart';
import '../../../../bloc/mini_card/mini_card_bloc.dart';
import '../../../mini_card/components/book_card_item.dart';
import '../../../../components/widget/value_realtime.dart';
import '../../../mini_card/components/container_top_boder.dart';
import '../../../../components/custom_scafold/stateless_custom.dart';

class MiniCardInfoPage extends StateLessCustom {
  final BookModel book;

  MiniCardInfoPage({Key key, @required this.book}) : super(key: key);

  Widget build(BuildContext context) {
    return FutgolazoScaffold(
      withBackButton: true,
      body: Column(
        children: <Widget>[
          HeaderBook(
            subtitle: '¡Adivina quien gana!',
          ),
          BookCardItem(
            height: responsive.hp(40),
            book: book,
            margin: EdgeInsets.only(top: responsive.hp(6)),
            aditionalWidgetContent: _buildAdiotionalInfo(),
          ),
          _buildRewardMoney(),
          _buildButtonPlay()
        ],
      ),
    );
  }

  _buildRewardMoney() {
    return Align(
      heightFactor: .1,
      child: ValueRealtime(
        miniCardSyncName: EnvironmentConfig().environment.miniCardSync,
      ),
    );
  }

  Widget _buildButtonPlay() {
    return Container(
      margin: EdgeInsets.only(top: responsive.hp(6)),
      child: RiveButton(
        width: responsive.wp(85),
        buttonText: 'JUGAR',
        onTapButton: () {
          MiniCardBloc().setCurrentMiniCard(book);
          Get.offNamed(NavigationRoute.MINI_CARD);
        },
        responsive: responsive,
      ),
    );
  }

  _buildAdiotionalInfo() {
    print(book.dateHuman.dayWeek);
    return Column(
      children: <Widget>[
        SizedBox(height: responsive.hp(2)),
        ContainerTopBorder(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Este ${book.dateHuman.dayWeek.toLowerCase()} ${book.dateHuman.dateFormatString('dd/m')}',
                style: customStyle(colorsTheme.getColorOnPrimary),
              ),
              Text(
                '${book.matches.length} partidos',
                style: customStyle(colorsTheme.getColorOnPrimary),
              )
            ],
          ),
        ),
        SizedBox(height: responsive.hp(2)),
        ContainerTopBorder(
          child: Container(
            margin: EdgeInsets.only(bottom: responsive.hp(2)),
            child: Text(
              'Si inviertes todo, te puedes ganar hasta',
              textAlign: TextAlign.center,
              style: customStyle(),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle customStyle([Color color]) =>
      fontSize.headline6(color: color).copyWith(
            fontSize: responsive.ip(1.7),
          );
}
