import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/services.dart';
import 'package:futgolazo/src/components/custom_scafold/statefull_custom.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import '../../services/pool_services.dart';
import '../../bloc/loading/loading_bloc.dart';

class Loading extends StateFullCustom {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  LoadingBloc _loadingBloc;

  @override
  void initState() {
    _loadingBloc = LoadingBloc();
    super.initState();
  }

  @override
  void dispose() async {
    _loadingBloc.dispose();
    print('cerro');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = GetIt.I<PoolServices>().futgolazoMainTheme.getResponsive;
    return Container(
      color: GetIt.I<PoolServices>()
          .futgolazoMainTheme
          .getColorsTheme
          .getColorBackground
          .withOpacity(.70),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          // color: Colors.yellow,
          width: responsive.hp(25),
          height: responsive.hp(25),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FlareActor.asset(
              AssetFlare(
                bundle: rootBundle,
                name: 'assets/animations/LoadingFGZ.flr',
              ),
              animation: 'Untitled',
            ),
          ),
        ),
      ),
    );
  }
}
