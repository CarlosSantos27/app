import 'package:flutter/material.dart';
import 'package:futgolazo/src/bloc/base/base_bloc.dart';
import 'package:futgolazo/src/models/book.model.dart';

import 'package:futgolazo/src/models/date_range_mini_card.model.dart';
import 'package:futgolazo/src/models/match.model.dart';
import 'package:futgolazo/src/models/prognostic.model.dart';
import 'package:futgolazo/src/models/resume_book.model.dart';
import 'package:futgolazo/src/networking/generic_paged.dart';
import 'package:futgolazo/src/networking/generic_response.dart';
import 'package:futgolazo/src/repositories/book.repository.dart';
import 'package:futgolazo/src/services/loading_service.dart';
import 'package:futgolazo/src/utils/date_for_human.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import '../../services/pool_services.dart';

class MyBooksBloc extends BaseBloc {
  BookRepository _bookRepository;
  LoadingService _loadingService;
  PageController _pageController;

  final _activePlaysController$ = BehaviorSubject<List<ResumeBookModel>>();
  Stream<List<ResumeBookModel>> get activePlaysStream =>
      _activePlaysController$.stream;
  Function(List<ResumeBookModel>) get setActivePlays =>
      _activePlaysController$.sink.add;

  List<DateRangeMiniCardModel> dateRange = [];

  final _resultStremController = BehaviorSubject<List<ResumeBookModel>>();
  final _bookPrognosticsController =
      BehaviorSubject<GenericPaged<PrognosticModel>>();
  final _currentBookController = BehaviorSubject<BookModel>();
  final _myCardsController = BehaviorSubject<List<List<MatchModel>>>();

  Stream<List<ResumeBookModel>> get streamResult =>
      _resultStremController.stream;
  Stream<GenericPaged<PrognosticModel>> get bookPrognosticsStream =>
      _bookPrognosticsController.stream;
  Stream<BookModel> get currentBookStream => _currentBookController.stream;
  Stream<List<List<MatchModel>>> get myCardsStream => _myCardsController.stream;

  Function(GenericPaged<PrognosticModel>) get setBookPrognostics =>
      _bookPrognosticsController.sink.add;
  Function(BookModel) get setCurrentBook => _currentBookController.sink.add;
  Function(List<List<MatchModel>>) get setMyCards =>
      _myCardsController.sink.add;

  List<List<MatchModel>> get myCards => _myCardsController.value;
  BookModel get currentBook => _currentBookController.value;
  GenericPaged<PrognosticModel> get bookPrognostics =>
      _bookPrognosticsController.value;

  MyBooksBloc()
      : _bookRepository = BookRepository(),
        _pageController = new PageController(),
        _loadingService = GetIt.I<PoolServices>().loadingService;

  PageController get controller => _pageController;

  Future<List<DateRangeMiniCardModel>> getDateRangeMiniCard() async {
    GetIt.I<PoolServices>().loadingService.showLoadingScreen();
    final response = await _bookRepository.getDateRangesMiniBooks();

    dateRange = (response.data['dateRanges'] as List<dynamic>)
        .map(
          (e) => DateRangeMiniCardModel.fromJsonMap(e),
        )
        .toList();

    await getResultsPerMonth(dateRange.first);
    GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
    return dateRange;
  }

  Future<void> getResultsPerMonth(DateRangeMiniCardModel dateRange) async {
    final response = await _bookRepository.getResultMiniCard(dateRange);
    List<ResumeBookModel> resultsList =
        (response.data['cardSummary'] as List<dynamic>)
            .map(
              (e) => ResumeBookModel.fromJson(e),
            )
            .toList();
    _resultStremController.sink.add(resultsList);
  }

  void nextPage() async {
    await this._changeDate(
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.bounceOut,
        ),
        _pageController.page.toInt() + 1);
  }

  _changeDate(Future f, int nextPageNumber) async {
    if (nextPageNumber == dateRange.length || nextPageNumber < 0) return;
    await f;
    GetIt.I<PoolServices>().loadingService.showLoadingScreen();
    await this.getResultsPerMonth(dateRange[_pageController.page.toInt()]);
    GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
  }

  void previousPage() async {
    this._changeDate(
        _pageController.previousPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.bounceOut,
        ),
        _pageController.page.toInt() - 1);
  }

  Future<int> getMyBooksByCardIdAndType(
      int cardId, int cardTypeId, String countryCode, int pageNumber) async {
    try {
      if (bookPrognostics == null ||
          bookPrognostics.pageCount + 1 > pageNumber) {
        GetIt.I<PoolServices>().loadingService.showLoadingScreen();
        List<MatchModel> matchesList = [];
        if (pageNumber == 1) {
          final bookResponse =
              await _bookRepository.getMyBooks(cardId, cardTypeId, countryCode);
          await _getBookByCardIdAndType(bookResponse);
        }
        matchesList = currentBook.matches;
        final progsResponse = await _bookRepository.getMyBooksProgs(
            cardId, cardTypeId, countryCode, pageNumber);
        _getPrognosticsData(progsResponse);
        final processedList = bookPrognostics.data.map((item) {
          return item.prognostics.map((prognostic) {
            final match = matchesList
                .firstWhere((e) => e.id == prognostic.cardDetailValue);
            match.setPrognostic = prognostic.prognosticValue;
            return MatchModel.clone(match);
          }).toList();
        }).toList();
        setMyCards(processedList);
        pageNumber++;

        GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
      }
      return pageNumber;
    } catch (error) {
      GetIt.I<PoolServices>()
          .loadingService
          .showErrorSnackbar(error.toString());
      throw error;
    }
  }

  Future<BookModel> _getBookByCardIdAndType(
      GenericResponse genericResponse) async {
    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      BookModel book = BookModel.fromJsonMap(genericResponse.data['card']);
      book.dateHuman = DateForHuman(book.firstMatchTime);
      await setCurrentBook(book);
      return book;
    } else {
      throw genericResponse.message;
    }
  }

  Future<void> getPrognostics(
      int cardId, int cardTypeId, String countryCode, int pageNumber) async {
    try {
      GetIt.I<PoolServices>().loadingService.showLoadingScreen();
      final genericResponse = await _bookRepository.getMyBooksProgs(
          cardId, cardTypeId, countryCode, pageNumber);
      GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
      _getPrognosticsData(genericResponse);
    } catch (error) {
      GetIt.I<PoolServices>()
          .loadingService
          .showErrorSnackbar(error.toString());
      throw error;
    }
  }

  _getPrognosticsData(GenericResponse genericResponse) {
    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      GenericPaged<PrognosticModel> genericPaged =
          bookPrognostics ?? GenericPaged(data: []);
      genericPaged.pageCount = genericResponse.data['count'] ??
          genericResponse.data['pageCount'] ??
          0;
      List<PrognosticModel> prognostics = prognosticsModelFromDynamicList(
          genericResponse.data['prognostics'] ??
              genericResponse.data['prognosticList'] ??
              []);
      genericPaged.data.addAll(prognostics);
      setBookPrognostics(genericPaged);
    } else {
      throw genericResponse.message;
    }
  }

  Future<List<ResumeBookModel>> getActivePlays() async {
    try {
      _loadingService.showLoadingScreen();
      GenericResponse genericResponse =
          await _bookRepository.getActivePlaysList();
      _loadingService.hideLoadingScreen();

      List<ResumeBookModel> resultList = [];
      if (genericResponse.status == GenericResponseStatus.COMPLETED) {
        (genericResponse.data['cardSummary'] as List<dynamic>)
            .forEach((element) {
          ResumeBookModel resumeBook = ResumeBookModel.fromJson(element);
          resumeBook.dateHuman = DateForHuman(resumeBook.endDateTime);
          resultList.add(resumeBook);
        });
      } else {
        throw genericResponse.message;
      }
      setActivePlays(resultList);
      return resultList;
    } catch (error) {
      GetIt.I<PoolServices>()
          .loadingService
          .showErrorSnackbar(error.toString());
      throw error;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _myCardsController?.close();
    _resultStremController.close();
    _activePlaysController$.close();
    _currentBookController?.close();
    _bookPrognosticsController?.close();
  }
}
