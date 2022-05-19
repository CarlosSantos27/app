import 'package:flutter/material.dart';

import '../../../models/resume_book.model.dart';
import '../../../bloc/my_books/my_books.bloc.dart';
import '../../../components/widget/text_stroke.dart';
import '../../../models/date_range_mini_card.model.dart';
import '../../../pages/plays/components/item_result.dart';
import '../../../components/custom_alert/custom_alert.dart';
import '../../../components/custom_scafold/statefull_custom.dart';
import '../../../pages/plays/components/expandle_card_section.dart';

class ResultsPlayPage extends StateFullCustom {
  final MyBooksBloc myBooksBloc;

  ResultsPlayPage({@required this.myBooksBloc});

  @override
  _ResultsPlayPageState createState() => _ResultsPlayPageState();
}

class _ResultsPlayPageState extends State<ResultsPlayPage> {
  Future<List<DateRangeMiniCardModel>> _dateRangeFuture;

  @override
  void initState() {
    super.initState();
    _dateRangeFuture = widget.myBooksBloc.getDateRangeMiniCard();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildDateSelect(),
          _buildListResults(),
          SizedBox(height: widget.responsive.hp(10),)
        ],
      ),
    );
  }

  FutureBuilder<List<DateRangeMiniCardModel>> _buildDateSelect() {
    return FutureBuilder<List<DateRangeMiniCardModel>>(
      future: _dateRangeFuture,
      initialData: [],
      builder: (
        BuildContext context,
        AsyncSnapshot<List<DateRangeMiniCardModel>> snapshot,
      ) {
        return Container(
          height: widget.responsive.hp(8),
          child: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: widget.responsive.hp(7),
                margin: EdgeInsets.symmetric(
                  // vertical: 2.0,
                  horizontal: widget.responsive.wp(7),
                ),
                color: Colors.white,
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  controller: widget.myBooksBloc.controller,
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, int index) {
                    return _buildTextDate(snapshot.data[index].description);
                  },
                ),
              ),
              _buildButtonChangeDate(
                Alignment.centerLeft,
                '<<',
                widget.myBooksBloc.previousPage,
              ),
              _buildButtonChangeDate(
                Alignment.centerRight,
                '>>',
                widget.myBooksBloc.nextPage,
              ),
            ],
          ),
        );
      },
    );
  }

  TextStroke _buildTextDate(String dateText) {
    return TextStroke(
      dateText,
      style: widget.fontSize
          .headline4(
            color: widget.colorsTheme.getColorOnBackground,
          )
          .copyWith(
            fontFamily: 'TitanOne',
          ),
    );
  }

  Align _buildButtonChangeDate(
      Alignment alignment, String textButton, Function tap) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: tap,
        child: Container(
          alignment: Alignment.center,
          width: widget.responsive.hp(8),
          height: widget.responsive.hp(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.colorsTheme.getColorBackgroundDarkest,
              width: widget.responsive.ip(.3),
            ),
            color: widget.colorsTheme.getColorPrimaryVariant,
            borderRadius: BorderRadius.circular(35.0),
          ),
          child: Text(
            textButton,
            style: widget.fontSize
                .headline3(
                  color: Colors.black,
                )
                .copyWith(
                  letterSpacing: widget.responsive.wp(-2.5),
                ),
          ),
        ),
      ),
    );
  }

  _buildListResults() {
    return Padding(
      padding: EdgeInsets.only(top: widget.responsive.hp(2)),
      child: StreamBuilder<List<ResumeBookModel>>(
        stream: widget.myBooksBloc.streamResult,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<ResumeBookModel>> snapshot,
        ) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return Center(
                child: CustomAlert('Aún no estan disponibles los resultados'),
              );
            }
            return ExpandleCardSection(
              data: snapshot.data,
              title: 'Cartillas',
              itemBuilder: (_, ResumeBookModel item) {
                return ItemResult(
                  resumeBookModel: item,
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
