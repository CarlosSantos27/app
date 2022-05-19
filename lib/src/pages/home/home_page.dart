import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import '../../routes/routes.dart';
import '../../models/user.model.dart';
import './components/sub_header_info.dart';
import '../../services/pool_services.dart';
import './components/user_team_container.dart';
import '../../components/bar_bottom/bar_bottom.dart';
import '../../components/home/header/header_bar.dart';
import '../../pages/home/animation/home_animation.dart';
import '../../components/widget/button_shadow_rounded.dart';
import '../../components/custom_scafold/statefull_custom.dart';
import '../../components/container_default/contain_default.dart';
import '../../components/futgolazo_scaffold/futgolazo_scaffold.dart';

class HomePage extends StateFullCustom {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  HomeAnimation _homeAnimation;
  AnimationController _animController;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _homeAnimation = HomeAnimation(_animController);

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutgolazoScaffold(
      body: StreamBuilder(
        stream: GetIt.I<PoolServices>().dataService.user$,
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: AnimatedBuilder(
                animation: _homeAnimation.controller,
                builder: (context, child) => _buildAnimation(
                  context,
                  child,
                  snapshot.data,
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget _buildAnimation(
    BuildContext context,
    Widget child,
    UserModel user,
  ) {
    return Container(
      height: widget.responsive.hp(100),
      child: Column(
        children: <Widget>[
          HeaderBar(),
          _mainArea(user),
        ],
      ),
    );
  }

  Widget _mainArea(UserModel user) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.responsive.ip(2),
          vertical: widget.responsive.ip(1),
        ),
        child: Column(
          children: <Widget>[
            _subHeadreWidget(user),
            SizedBox(
              height: widget.responsive.hp(1),
            ),
            UserTeamContainer(
              user: user,
            ),
            SizedBox(
              height: widget.responsive.hp(1),
            ),
            BarBottom(),
          ],
        ),
      ),
    );
  }

  Widget _subHeadreWidget(UserModel currentUser) {
    if (currentUser.isGuestUser) {
      return ContainerDefault(
        background: widget.colorsTheme.getColorOnSurface,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '¿Quieres jugar?',
              style: widget.textTheme.button,
            ),
            ButtonShadowRounded(
              onPressed: () {
                Get.toNamed(NavigationRoute.SIGNUP);
              },
              child: Text('Regístrate'),
            ),
          ],
        ),
      );
    } else {
      return SubHeadrInfo(
        user: currentUser,
      );
    }
  }
}
