import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import 'package:futgolazo/src/models/user.model.dart';
import 'package:futgolazo/src/bloc/base/base_bloc.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/services/load_assets_service.dart';

class LoadAssetsBloc extends BaseBloc {
  final _isLoadinAssets$ = BehaviorSubject<bool>.seeded(true);
  final LoadAssetsService _loadAssetsService;

  LoadAssetsBloc() : _loadAssetsService = LoadAssetsService() {
    UserModel user = GetIt.I<PoolServices>().dataService.user;

    String userContry = user != null ? user.countryInfo.name : 'Futgolazo';

    _loadAssetsService.init();
    _loadAssetsFromZip();
  }

  Stream<bool> get loadingStream => _isLoadinAssets$.stream;

  @override
  void dispose() {
    _isLoadinAssets$.close();
  }

  void _loadAssetsFromZip() async {
    await _loadAssetsService.downloadZip();
    _isLoadinAssets$.sink.add(false);
  }
}
