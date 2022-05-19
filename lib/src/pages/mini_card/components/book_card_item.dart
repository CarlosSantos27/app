import 'package:flutter/material.dart';

import 'container_top_boder.dart';
import '../../../env/env.router.dart';
import '../../../models/book.model.dart';
import '../../../utils/date_for_human.dart';
import '../../../components/widget/circular_image.dart';
import '../../../bloc/time_remaining/time_remaining.bloc.dart';
import '../../../components/custom_scafold/stateless_custom.dart';
import '../../../components/container_default/contain_default.dart';
import '../../../components/widget/container_two_border_radius.dart';

class BookCardItem extends StateLessCustom {
  final BookModel book;
  final EdgeInsets margin;
  final double height;
  final Widget aditionalWidgetContent;

  final String _url;

  BookCardItem({
    @required this.book,
    @required this.height,
    this.aditionalWidgetContent,
    this.margin,
  }) : _url =
            '${EnvironmentConfig().environment.imagePath}/team_badges/${book.countryInfo.name.replaceAll('ú', 'u')}.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
      child: Container(
        margin: margin,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            ContainerDefault(
              child: Container(
                height: height,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Text(
                          book.description,
                          style: fontSize.headline5(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    ContainerTopBorder(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cartilla de ${book.countryInfo.name}',
                            style: fontSize
                                .headline6(
                                  color: colorsTheme.getColorOnPrimary,
                                )
                                .copyWith(
                                  fontSize: responsive.ip(1.7),
                                ),
                          ),
                          CircularShield(
                            url: _url,
                            radio: responsive.ip(2),
                          )
                        ],
                      ),
                    ),
                    aditionalWidgetContent ?? Container()
                  ],
                ),
              ),
            ),
            _buildContentTime(book.dateHuman),
          ],
        ),
      ),
    );
  }

  Positioned _buildContentTime(DateForHuman time) {
    return Positioned(
        top: responsive.hp(-1.5),
        right: responsive.wp(3),
        child: RemainigRealTime(
          dateHuman: time,
          child: (context, snapshot) {
            return Container(
              child: ContainerTwoBorderRadius(
                child: Text('Te quedan ${snapshot.remaining}'),
              ),
            );
          },
        ));
  }
}

typedef RemainigRealTimeBuilder<T> = Widget Function(
    BuildContext context, DateForHuman dateForHuman);

class RemainigRealTime extends StateLessCustom {
  final DateForHuman dateHuman;
  final RemainigRealTimeBuilder child;

  RemainigRealTime({
    this.child,
    this.dateHuman,
  });


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: TimeRemaining().currentDateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          dateHuman.calculateDate(snapshot.data);
        }
        return this.child(context, dateHuman);
      },
    );
  }
}
