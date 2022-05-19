import 'package:flutter/material.dart';

import '../../utils/date_for_human.dart';
import '../../models/my_results.model.dart';
import '../../models/resume_book.model.dart';
import './components/card_result_mini_card.dart';
import '../../bloc/my_books/my_results.bloc.dart';
import '../../components/widget/text_stroke.dart';
import '../../components/custom_scafold/statefull_custom.dart';
import '../../pages/my_results/components/card_prize_result.dart';

class MyresultsPage extends StateFullCustom {
  final ResumeBookModel resumeBookModel;
  MyresultsPage({Key key, this.resumeBookModel}) : super(key: key);
  @override
  _MyBooksPageState createState() => _MyBooksPageState();
}

class _MyBooksPageState extends State<MyresultsPage> {
  DateForHuman _dateForHuman;
  MyResultsBloc _myResultsBloc;

  Future<List<MyResultsModel>> getMyResults;
  PageController _pageController;
  PageController _pageControllerResults;

  int currentBook = 0;
  bool listener = true;

  @override
  void initState() {
    _pageController = new PageController(viewportFraction: .5);
    _pageControllerResults = PageController();

    _pageController.addListener(() {
      final decimal = _pageController.page - _pageController.page.toInt();
      if (decimal == 0.0 && listener) {
        currentBook = _pageController.page.toInt();
        onChangePage();
      }
    });

    _myResultsBloc = MyResultsBloc();
    getMyResults = _myResultsBloc.getResultsMatch(
      widget.resumeBookModel.cardId,
    );
    super.initState();
    _dateForHuman = DateForHuman(
      widget.resumeBookModel.endDateTime,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _myResultsBloc.dispose();
    _pageController.dispose();
    _pageControllerResults.dispose();
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
                          EdgeInsets.only(
                            top: widget.responsive.hp(4),
                          ),
                        ),
                        _buildContainerGeneric(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Este ${_dateForHuman.dayWeek} ${_dateForHuman.dateFormatString('mm/dd')}',
                                style: widget.fontSize.bodyText2(
                                    color:
                                        widget.colorsTheme.getColorOnPrimary),
                              ),
                              _buildNumberMatch(),
                            ],
                          ),
                        ),
                        _buildContainerGeneric(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Premio total',
                                style: widget.fontSize.bodyText2(
                                  color: widget.colorsTheme.getColorOnPrimary,
                                ),
                              ),
                              Text(
                                '${widget.resumeBookModel.prizeAmount.toInt()}',
                                style: widget.fontSize.bodyText2(
                                  color: widget.colorsTheme.getColorOnPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildListCard(),
                ],
              ),
            ),
            Container(
              width: widget.responsive.wp(100),
              color: widget.colorsTheme.getColorBackgroundDarkest,
              child: FutureBuilder<List<MyResultsModel>>(
                future: getMyResults,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<MyResultsModel>> snapshot,
                ) {
                  final totalMatch =
                      snapshot.hasData ? snapshot.data[0].matches.length : 0;
                  return Container(
                    height: (totalMatch * widget.responsive.hp(47)) +
                        widget.responsive.hp(20),
                    padding: EdgeInsets.only(
                      top: widget.responsive.hp(3.5),
                    ),
                    child: PageView.builder(
                      controller: _pageControllerResults,
                      itemCount: snapshot.data?.length ?? 0,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, int index) {
                        return Container(
                          padding: EdgeInsets.only(
                            left: widget.responsive.wp(5),
                            right: widget.responsive.wp(5),
                          ),
                          child: Column(
                            children: <Widget>[
                              CardPrizeResult(
                                result: snapshot.data[index],
                              ),
                              SizedBox(height: widget.responsive.hp(2)),
                              Column(
                                children: List.generate(
                                  snapshot.data[index].matches.length,
                                  (int i) {
                                    return Column(
                                      children: <Widget>[
                                        CardResultMiniCard(
                                          match:
                                              snapshot.data[index].matches[i],
                                        ),
                                        SizedBox(
                                          height: widget.responsive.hp(3.5),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNumberMatch() {
    return StreamBuilder<int>(
      stream: _myResultsBloc.totalMatch,
      initialData: 0,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        return Text(
          '${snapshot.data} partidos ',
          style: widget.fontSize.bodyText2(
            color: widget.colorsTheme.getColorOnPrimary,
          ),
        );
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

  void onChangePage() {
    setState(() {
      _pageControllerResults.animateToPage(
        currentBook,
        duration: Duration(milliseconds: 450),
        curve: Curves.linear,
      );
      _pageController.animateToPage(
        currentBook,
        duration: Duration(milliseconds: 450),
        curve: Curves.linear,
      );
    });
    Future.delayed(Duration(milliseconds: 450), () => listener = true);
  }

  _buildListCard() {
    return Container(
      margin: EdgeInsets.only(top: widget.responsive.hp(1)),
      height: widget.responsive.hp(8),
      alignment: Alignment.bottomCenter,
      child: StreamBuilder(
        stream: _myResultsBloc.totalBooksSent,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            child: PageView.builder(
              controller: _pageController,
              itemCount: snapshot.data ?? 0,
              itemBuilder: (_, int index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        listener = false;
                        currentBook = index;
                        onChangePage();
                      },
                      child: Container(
                        width: widget.responsive.wp(50),
                        padding: EdgeInsets.only(
                          bottom: widget.responsive.hp(1.5),
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 3.0,
                              color: currentBook == index
                                  ? widget.colorsTheme.getColorOnButton
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        // color: Colors.amber,
                        child: Text(
                          'Cartilla ${index + 1}',
                          style: widget.fontSize.headline6(
                            color: widget.colorsTheme.getColorOnButton,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
