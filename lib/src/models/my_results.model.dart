import 'package:futgolazo/src/models/match.model.dart';

class MyResultsModel {
  final List<MatchModel> matches;
  final int totalHits;
  final double earnedAmount;

  MyResultsModel({
    this.matches,
    this.totalHits,
    this.earnedAmount,
  });
}
