import 'package:flutter/material.dart';
import 'package:futgolazo/src/bloc/mini_card/mini_card_bloc.dart';
import 'package:futgolazo/src/bloc/my_books/my_books.bloc.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';
import 'package:futgolazo/src/models/resume_book.model.dart';
import 'package:futgolazo/src/pages/mini_card/components/book_card_item.dart';
import 'package:futgolazo/src/pages/plays/components/card_space_between.dart';
import 'package:futgolazo/src/pages/plays/components/expandle_card_section.dart';
import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/utils/date_for_human.dart';
import 'package:get/get.dart';

class BookSection extends StateLessCustom {
  final List<ResumeBookModel> data;
  final MyBooksBloc myBooksBloc;

  BookSection({
    Key key,
    @required this.data,
    @required this.myBooksBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandleCardSection(
      data: data,
      title: 'Cartillas Enviadas',
      itemBuilder: (_, item) {
        return _buildCardItem(item);
      },
    );
  }

  _buildCardItem(ResumeBookModel item) {
    final innerCardTextStyle =
        fontSize.bodyText2().copyWith(color: colorsTheme.getColorOnSurface);
    final titanTextStyle = fontSize
        .headline5()
        .copyWith(fontFamily: 'TitanOne', color: colorsTheme.getColorOnSurface);
    return CardSpaceBetween(
      onTap: () {
        Get.toNamed(NavigationRoute.MY_BOOKS,
            arguments: {'resumeBookModel': item, 'myBooksBloc': myBooksBloc});
      },
      crossAxisAlignment: CrossAxisAlignment.end,
      leftChild: _buildLeftData(item, innerCardTextStyle, titanTextStyle),
      rightChild: _buildRightData(item, innerCardTextStyle, titanTextStyle),
    );
  }

  _buildLeftData(
      ResumeBookModel item, TextStyle innerStyle, TextStyle titanStyle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.cardDescription ?? '',
          style: fontSize
              .headline6()
              .copyWith(color: colorsTheme.getColorOnButton),
        ),
        SizedBox(height: responsive.hp(1.0)),
        CardSpaceBetween(
          leftFlex: 2,
          horizontalPadding: responsive.ip(1.2),
          verticalPadding: responsive.ip(1.0),
          background: colorsTheme.getColorOnSecondary,
          leftChild: Text(
            'Cartillas\nenviadas',
            style: innerStyle,
          ),
          rightChild: Text(
            item.cardCount.toString(),
            style: titanStyle,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  _buildRightData(
      ResumeBookModel item, TextStyle innerStyle, TextStyle titanStyle) {
    return Column(
      crossAxisAlignment:
          item.available ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (item.available) _buildSendOtherBookButton(item),
        if (!item.available) _buildRemainTime(item.dateHuman),
        SizedBox(height: responsive.hp(1.0)),
        CardSpaceBetween(
          horizontalPadding: responsive.ip(1.2),
          verticalPadding: responsive.ip(1.0),
          background: colorsTheme.getColorOnSecondary,
          leftChild: Text(
            'Puedes\nganar',
            style: innerStyle,
          ),
          rightChild: Text(
            '${item.prizeAmount.toStringAsFixed(0)}\$',
            style: titanStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  _buildSendOtherBookButton(ResumeBookModel item) {
    return SizedBox(
      child: RaisedButton(
        disabledElevation: 0.0,
        focusElevation: 0.0,
        highlightElevation: 0.0,
        hoverElevation: 0.0,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () => _actionSendOtherBook(item),
        elevation: 0.0,
        color: colorsTheme.getColorOnButton,
        padding: EdgeInsets.symmetric(
            vertical: responsive.ip(1.0), horizontal: responsive.ip(1.5)),
        child: Text(
          'Enviar otra cartilla',
          style: fontSize.bodyText2(),
        ),
        shape: StadiumBorder(),
      ),
    );
  }

  _buildRemainTime(DateForHuman time) {
    return RemainigRealTime(
      dateHuman: time,
      child: (context, snapshot) {
        return Text(
          '${snapshot.remaining}\npara los resultados',
          style: fontSize
              .bodyText2()
              .copyWith(color: colorsTheme.getColorSurfaceVariant),
          textAlign: TextAlign.center,
        );
      },
    );
  }

  _configMiniCard(ResumeBookModel item) async {
    final MiniCardBloc miniCardBloc = MiniCardBloc();
    final book = await miniCardBloc
        .getBookByCountry(item)
        .catchError((error) => throw error);
    miniCardBloc.setCurrentMiniCard(book);
  }

  _actionSendOtherBook(ResumeBookModel item) async {
    await _configMiniCard(item);
    Get.toNamed(NavigationRoute.MINI_CARD);
  }
}
