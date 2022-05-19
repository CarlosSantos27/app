import 'package:flutter/material.dart';
import 'package:futgolazo/src/bloc/my_books/my_books.bloc.dart';
import 'package:futgolazo/src/components/widget/text_stroke.dart';
import 'package:futgolazo/src/models/book.model.dart';
import 'package:futgolazo/src/models/match.model.dart';
import 'package:futgolazo/src/models/resume_book.model.dart';
import 'package:futgolazo/src/networking/generic_paged.dart';
import 'package:futgolazo/src/pages/mini_card/components/book_card_item.dart';
import 'package:futgolazo/src/pages/mini_card/components/card_match.dart';
import 'package:futgolazo/src/pages/my_results/components/card_result_mini_card.dart';
import 'package:futgolazo/src/utils/date_for_human.dart';
import 'package:provider/provider.dart';

import '../../components/custom_scafold/statefull_custom.dart';

class MyBooksPage extends StatelessWidget {
  final ResumeBookModel resumeBookModel;
  final MyBooksBloc myBooksBloc;
  const MyBooksPage({Key key, this.resumeBookModel, this.myBooksBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => new PageViewIndexProvider(),
      child: _Main(resumeBookModel: resumeBookModel, myBooksBloc: myBooksBloc),
    );
  }
}

class _Main extends StateFullCustom {
  final ResumeBookModel resumeBookModel;
  final MyBooksBloc myBooksBloc;
  _Main({
    @required this.resumeBookModel,
    @required this.myBooksBloc,
  });
  @override
  __MainState createState() => __MainState();
}

class __MainState extends State<_Main> {
  DateForHuman _dateForHuman;
  PageController _pageController = PageController(viewportFraction: .5);
  PageController _pageListController = PageController();
  int pageIndex = 1;
  // int currentIndex = 0;

  @override
  void dispose() {
    widget.myBooksBloc.setMyCards([]);
    widget.myBooksBloc.setCurrentBook(null);
    widget.myBooksBloc.setBookPrognostics(null);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _dateForHuman = DateForHuman(
      widget.resumeBookModel.endDateTime,
    );
    _getMyCardsData();
  }

  _getMyCardsData() async {
    pageIndex = await widget.myBooksBloc.getMyBooksByCardIdAndType(
        widget.resumeBookModel.cardId,
        widget.resumeBookModel.cardTypeId,
        widget.resumeBookModel.countryCode,
        pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return FutgolazoScaffold(
      withBackButton: true,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              color: widget.colorsTheme.getColorPrimary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.responsive.wp(8),
                    ),
                    child: Column(
                      children: <Widget>[
                        _buildContainerGeneric(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/mini_card/decoration-left.png',
                                height: widget.responsive.hp(15),
                              ),
                              Expanded(
                                child: TextStroke(
                                  widget.resumeBookModel.cardDescription,
                                  strokeWidth: widget.responsive.ip(1.2),
                                ),
                              ),
                              Image.asset(
                                'assets/mini_card/decoration-right.png',
                                height: widget.responsive.hp(15),
                              ),
                            ],
                          ),
                          EdgeInsets.only(top: widget.responsive.hp(4)),
                        ),
                        _buildContainerGeneric(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  'Este ${_dateForHuman.dayWeek} ${_dateForHuman.dateFormatString('mm/dd')}'),
                              _buildMatchLenght(),
                            ],
                          ),
                        ),
                        _buildTimerTitle(),
                      ],
                    ),
                  ),
                  _buildListCard(),
                ],
              ),
            ),
            _buildBookDetails(),
          ],
        ),
      ),
    );
  }

  _buildMatchLenght() {
    return StreamBuilder(
      stream: widget.myBooksBloc.currentBookStream,
      builder: (BuildContext context, AsyncSnapshot<BookModel> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Text('${snapshot.data.matches.length} partidos ');
        }
        return Text('0 partidos ');
      },
    );
  }

  Widget _buildContainerGeneric(Widget child, [EdgeInsets margin]) {
    return Container(
      child: child,
      margin: margin,
      decoration: _buildDecorationDefault(),
      padding: EdgeInsets.symmetric(
        vertical: widget.responsive.hp(2),
      ),
    );
  }

  BoxDecoration _buildDecorationDefault() {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: widget.responsive.ip(.2),
          color: widget.colorsTheme.getColorOnSurface,
        ),
      ),
    );
  }

  _buildListCard() {
    return StreamBuilder(
      stream: widget.myBooksBloc.bookPrognosticsStream,
      builder: (BuildContext context, AsyncSnapshot<GenericPaged> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Container(
            margin: EdgeInsets.only(top: widget.responsive.hp(1)),
            height: widget.responsive.hp(8),
            alignment: Alignment.bottomCenter,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (page) {
                if (page == snapshot.data.data.length - 1) {
                  _getMyCardsData();
                }
                Provider.of<PageViewIndexProvider>(context, listen: false)
                    .index = page;
                _pageListController.animateToPage(page,
                    duration: Duration(milliseconds: 800),
                    curve: Curves.linear);
              },
              itemCount: snapshot.data.data.length,
              itemBuilder: (_, int index) {
                return _buildPageHeaderItem(
                    index, snapshot.data.data.length == 1);
              },
            ),
          );
        }
        return Container();
      },
    );
  }

  _buildPageHeaderItem(int index, bool isSingle) {
    final currentIndex = Provider.of<PageViewIndexProvider>(context).index;
    return Column(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              isSingle ? 'Tu Cartilla' : 'Cartilla ${index + 1}',
              style: widget.fontSize
                  .headline5()
                  .copyWith(color: widget.colorsTheme.getColorOnButton),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: index == currentIndex ? widget.responsive.ip(0.8) : 0.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500.0),
            color: index == currentIndex
                ? widget.colorsTheme.getColorOnButton
                : Colors.transparent,
          ),
        )
      ],
    );
  }

  _buildBookDetails() {
    return StreamBuilder<List<List<MatchModel>>>(
      stream: widget.myBooksBloc.myCardsStream,
      initialData: [],
      builder: (BuildContext context,
          AsyncSnapshot<List<List<MatchModel>>> snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          return Container(
            width: widget.responsive.wp(100),
            color: widget.colorsTheme.getColorBackgroundDarkest,
            child: Container(
              height: snapshot.data.first.length * widget.responsive.hp(45),
              padding: EdgeInsets.only(
                top: widget.responsive.hp(3.5),
              ),
              child: _buildPageViewList(snapshot.data),
            ),
          );
        }
        return Container();
      },
    );
  }

  _buildPageViewList(List<List<MatchModel>> data) {
    return PageView.builder(
      controller: _pageListController,
      itemCount: data.length,
      onPageChanged: (page) {
        _pageController.animateToPage(page,
            duration: Duration(milliseconds: 800),
            curve: Curves.linearToEaseOut);
      },
      itemBuilder: (_, int index) {
        return Container(
          padding: EdgeInsets.only(
            left: widget.responsive.wp(5),
            right: widget.responsive.wp(5),
          ),
          child: ListView.separated(
              physics: BouncingScrollPhysics(),
              separatorBuilder: (_, int index) {
                return SizedBox(
                  height: 15.0,
                );
              },
              itemCount: data[index].length,
              itemBuilder: (_, int i) {
                if (data[index][i].localScore != null &&
                    data[index][i].visitantScore != null) {
                  return CardResultMiniCard(
                    match: data[index][i],
                  );
                }
                return CardMatchContainer(
                  match: data[index][i],
                  readOnly: true,
                );
              }),
        );
      },
    );
  }

  _buildTimerTitle() {
    return StreamBuilder(
      stream: widget.myBooksBloc.currentBookStream,
      builder: (BuildContext context, AsyncSnapshot<BookModel> snapshot) {
        return _buildContainerGeneric(_buildRemainTime(
            !widget.resumeBookModel.available
                ? _dateForHuman
                : (snapshot.hasData && snapshot.data.firstMatchTime != null)
                    ? DateForHuman(snapshot.data.firstMatchTime)
                    : _dateForHuman));
      },
    );
  }

  _buildRemainTime(DateForHuman time) {
    return RemainigRealTime(
      dateHuman: time,
      child: (context, snapshot) {
        String beforeResults =
            'Te quedan ${snapshot.remaining} para seguir jugando';
        String afterResults = 'En ${snapshot.remaining} sabrás los resultados';
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: widget.resumeBookModel.available
                  ? widget.colorsTheme.getColorSurfaceVariant
                  : widget.colorsTheme.getColorBackgroundVariant,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(widget.responsive.ip(1.2)),
                bottomLeft: Radius.circular(widget.responsive.ip(1.2)),
              )),
          padding: EdgeInsets.all(widget.responsive.ip(0.5)),
          child: Text(
            widget.resumeBookModel.available ? beforeResults : afterResults,
            style: widget.fontSize.bodyText2(),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

class PageViewIndexProvider with ChangeNotifier {
  int _index = 0;

  int get index => this._index;
  set index(int index) {
    this._index = index;
    notifyListeners();
  }
}
