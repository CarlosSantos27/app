import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../routes/routes.dart';
import '../../../../models/book.model.dart';
import '../../../../bloc/mini_card/mini_card_bloc.dart';
import '../../../mini_card/components/header_book.dart';
import '../../../mini_card/components/book_card_item.dart';
import '../../../../bloc/time_remaining/time_remaining.bloc.dart';
import '../../../../components/custom_scafold/stateless_custom.dart';
import '../../../../components/custom_scafold/statefull_custom.dart';

class MiniCardListPage extends StateFullCustom {
  MiniCardListPage({Key key}) : super(key: key);
  @override
  _MiniCardListPageState createState() => _MiniCardListPageState();
}

class _MiniCardListPageState extends State<MiniCardListPage> {
  final paddingTop = Get.mediaQuery.padding.top;
  MiniCardBloc miniCardBloc;
  Future<List<BookModel>> getAllMiniCard;

  TimeRemaining _timeRemaining;

  @override
  void initState() {
    _timeRemaining = new TimeRemaining();
    miniCardBloc = MiniCardBloc();
    getAllMiniCard = miniCardBloc.getAvailableMiniCards();
    super.initState();
  }

  @override
  void dispose() {
    _timeRemaining.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutgolazoScaffold(
      withBackButton: true,
      body: Column(
        children: <Widget>[
          HeaderBook(
            subtitle: 'Elige la fecha',
          ),
          _buildListCard(),
        ],
      ),
    );
  }

  _buildListCard() {
    return Container(
      height: widget.responsive.hp(75) - paddingTop,
      child: FutureBuilder(
        future: getAllMiniCard,
        builder: (_, AsyncSnapshot<List<BookModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return _noCardToPlay();
            } else {
              return _listOfItems(snapshot.data);
            }
          }
          return Container();
        },
      ),
    );
  }

  Widget _noCardToPlay() {
    return Center(
      child: Container(
        width: widget.responsive.wp(80),
        child: Text(
          'No existen cartillas activas por el momento',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _listOfItems(List<BookModel> data) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (_, i) {
        return _buildCard(i, data[i]);
      },
      separatorBuilder: (_, i) {
        return SizedBox(
          height: widget.responsive.hp(5),
        );
      },
    );
  }

  Widget _buildCard(int index, BookModel miniCard) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        NavigationRoute.MINI_CARD_INFO,
        arguments: miniCard,
      ),
      child: BookCardItem(
        height: widget.responsive.hp(25),
        book: miniCard,
        margin: index == 0
            ? EdgeInsets.only(
                top: widget.responsive.hp(7),
              )
            : null,
      ),
    );
  }
}
