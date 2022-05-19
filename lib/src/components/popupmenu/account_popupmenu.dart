import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/themes/futgolazo_theme.dart';
import 'package:futgolazo/src/components/popupmenu/popupmenu_item.model.dart';

class AccountPopupMenu extends StatelessWidget {
  final Widget child;
  AccountPopupMenu({Key key, this.child});

  final FutgolazoMainTheme _futgolazoMainTheme =
      GetIt.I<PoolServices>().futgolazoMainTheme;

  final List<PopUpItemMenuModel> items = [
    PopUpItemMenuModel(
      icon: Icons.exit_to_app,
      label: 'Cerrar sesión',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PopUpItemMenuModel>(
      offset: Offset(0, 100),
      padding: EdgeInsets.zero,
      child: child,
      itemBuilder: (_) {
        return items
            .map((PopUpItemMenuModel e) => PopupMenuItem<PopUpItemMenuModel>(
                  value: e,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        e.label,
                        style: _futgolazoMainTheme.getFontSize.bodyText2(
                            color: _futgolazoMainTheme
                                .getColorsTheme.getColorBackground),
                      ),
                      SizedBox(
                        width: _futgolazoMainTheme.getResponsive.wp(2),
                      ),
                      Expanded(
                        child: Icon(
                          e.icon,
                          size: _futgolazoMainTheme.getFontSize
                              .bodyText1()
                              .fontSize,
                          color: _futgolazoMainTheme
                              .getColorsTheme.getColorBackground,
                        ),
                      )
                    ],
                  ),
                ))
            .toList();
      },
      onSelected: (PopUpItemMenuModel item) {
        final itemSelected = item.label.toLowerCase();
        switch (itemSelected) {
          case 'cerrar sesión':
            print('Cerrando sesion');
            GetIt.I<PoolServices>().authService.logout();
            Get.offNamedUntil(
                NavigationRoute.INTRO, (Route<dynamic> route) => false);
            break;
          default:
        }
      },
    );
  }
}
