import 'package:flutter/material.dart';

import 'package:futgolazo/src/bloc/mini_card/mini_card_bloc.dart';
import 'package:futgolazo/src/pages/mini_card/components/header_book.dart';
import 'package:futgolazo/src/pages/mini_card/components/mini_card_body.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';
import 'package:futgolazo/src/pages/mini_card/components/mini_card_app_bar.dart';

class MiniCardPlay extends StateLessCustom {
  final MiniCardBloc _miniCardBloc;
  MiniCardPlay() : _miniCardBloc = MiniCardBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _miniCardBloc.currentMatch$,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        return FutgolazoScaffold(
          appBar: _buildAppbar(),
          body: Column(
            children: [
              HeaderBook(
                subtitle: '¿Quién ganará?',
                height: responsive.hp(12),
                background: Colors.transparent,
              ),
              SizedBox(
                height: responsive.hp(4),
              ),
              Expanded(
                child: MiniCardBody(
                  currentMatch: snapshot.data,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _buildAppbar() {
    final int currentIndex = _miniCardBloc.currentMatchIndex;
    final int itemCount = _miniCardBloc.currentMiniCard?.matches?.length;

    return PreferredSize(
      preferredSize: Size.fromHeight(
        responsive.hp(10.0),
      ),
      child: AppBar(
        elevation: 0.0,
        leading: Container(),
        flexibleSpace: MiniCardAppBar(
          itemCount: itemCount,
          currentIndex: currentIndex,
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
