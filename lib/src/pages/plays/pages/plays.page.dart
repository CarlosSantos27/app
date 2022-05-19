import 'package:flutter/material.dart';
import 'package:futgolazo/src/bloc/my_books/my_books.bloc.dart';
import 'package:futgolazo/src/pages/plays/pages/results_play.page.dart';

import '../../../bloc/mini_card/mini_card_bloc.dart';
import '../../../components/bar_bottom/bar_bottom.dart';
import '../../../components/custom_scafold/statefull_custom.dart';
import '../../../components/home/scaffolds/scaffold_home_bar.dart';
import '../../../components/widget/text_stroke.dart';
import '../../../pages/plays/components/toggle_bar.dart';
import '../../../pages/plays/pages/active_plays.dart';

class PlaysPage extends StateFullCustom {
  PlaysPage({Key key}) : super(key: key);

  @override
  _PlaysPageState createState() => _PlaysPageState();
}

class _PlaysPageState extends State<PlaysPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  MyBooksBloc _myBooksBloc;

  @override
  void initState() {
    super.initState();
    _myBooksBloc = new MyBooksBloc();

    tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    super.dispose();
    _myBooksBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldHomeBar(
      body: _buildContent(),
      barBottomOption: BarBottomOption.EVENTS,
    );
  }

  _buildContent() {
    return DefaultTabController(
      length: 2,
      child: _buildDataSection(),
    );
  }

  _buildDataSection() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: widget.responsive.wp(4.0),
          vertical: widget.responsive.hp(2.2)),
      child: Column(
        children: [
          _buildTitle(),
          ToggleBarWidget(
            onChanged: (position) {
              if (position == PositionedSelected.LEFT) {
                tabController.animateTo(0);
              } else {
                tabController.animateTo(1);
              }
            },
          ),
          SizedBox(height: widget.responsive.hp(2.0)),
          Expanded(
            child: _buildView(),
          ),
        ],
      ),
    );
  }

  _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: widget.responsive.hp(4.0)),
      child: TextStroke(
        'JUGADAS',
        strokeWidth: 8.0,
        style: widget.fontSize.headline2().copyWith(
              fontFamily: 'TitanOne',
            ),
      ),
    );
  }

  _buildView() {
    return TabBarView(
      controller: tabController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        ActivePlaysPage(
          myBooksBloc: _myBooksBloc,
        ),
        ResultsPlayPage(
          myBooksBloc: _myBooksBloc,
        )
      ],
    );
  }
}
