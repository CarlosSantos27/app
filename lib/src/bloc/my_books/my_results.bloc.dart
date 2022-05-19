import 'package:futgolazo/src/models/my_results.model.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import 'package:futgolazo/src/models/match.model.dart';
import 'package:futgolazo/src/bloc/base/base_bloc.dart';
import 'package:futgolazo/src/repositories/book.repository.dart';

class MyResultsBloc extends BaseBloc {
  BookRepository _bookRepository;

  MyResultsBloc() : _bookRepository = BookRepository();

  final _totalBooksSent = BehaviorSubject<int>();
  Stream<int> get totalBooksSent => _totalBooksSent.stream;

  final _totalMatch = BehaviorSubject<int>();
  Stream<int> get totalMatch => _totalMatch.stream;

  Future<List<MyResultsModel>> getResultsMatch(int idCard) async {
    GetIt.I<PoolServices>().loadingService.showLoadingScreen();

    final response = await _bookRepository.getMinicardInfo(idCard, 'EC');
    final matches = response.data['card']['groupList'][0]['matches'];
    final matchesList = (matches as List<dynamic>)
        .map((e) => MatchModel.fromJsonMap(e))
        .toList();

    _totalMatch.add(matchesList.length);

    final responseProgResults = await _bookRepository.progresults(idCard);

    final listPrognostic =
        (responseProgResults.data['prognostics'] as List<dynamic>);

    final myResultsValue = listPrognostic.map((element) {
      final matches =
          (element['prognostics'] as List<dynamic>).map((prognostics) {
        final match = matchesList
            .firstWhere((e) => e.id == prognostics['cardDetailValue']);
        match.setPrognostic = prognostics['prognosticValue'];
        return MatchModel.clone(match);
      }).toList();

      return MyResultsModel(
          matches: matches,
          earnedAmount: (element['earnedAmount'] ?? 0) / 1,
          totalHits: element['totalHits']);
    }).toList();

    _totalBooksSent.add(listPrognostic.length);
    GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
    return myResultsValue;
  }

  @override
  void dispose() {
    _totalBooksSent.close();
    _totalMatch.close();
  }
}
