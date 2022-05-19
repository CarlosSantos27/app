import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import './drag_controller.dart';
import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/models/user.model.dart';
import 'package:futgolazo/src/models/book.model.dart';
import 'package:futgolazo/src/models/match.model.dart';
import 'package:futgolazo/src/bloc/base/base_bloc.dart';
import 'package:futgolazo/src/utils/date_for_human.dart';
import 'package:futgolazo/src/enums/coin_type.enum.dart';
import 'package:futgolazo/src/enums/drag_target_enum.dart';
import 'package:futgolazo/src/services/audio_service.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/models/resume_book.model.dart';
import 'package:futgolazo/src/services/loading_service.dart';
import 'package:futgolazo/src/networking/generic_response.dart';
import 'package:futgolazo/src/repositories/book.repository.dart';
import 'package:futgolazo/src/models/user_coins_balance.model.dart';
import 'package:futgolazo/src/dialog/no_coins_to_buy/no_coins_to_buy_popup.dart';
import 'package:futgolazo/src/dialog/send_card_as_guest/send_card_as_guest_popup.dart';
import 'package:futgolazo/src/pages/mini_card/pages/mini_card_selected/mini_card_selected.page.dart';

class MiniCardBloc extends BaseBloc {
  LoadingService _loadingService;
  BookRepository _bookRepository;

  int _currentindex;
  int _storedGuestBookID;
  UserModel _user;

  bool _isAStorageBook;
  DragController _dragController;

  BehaviorSubject _selectedMiniBook$ = BehaviorSubject<BookModel>();
  BehaviorSubject _miniBookList$ = BehaviorSubject<List<BookModel>>();
  BehaviorSubject<MatchModel> _currentMatch$ = BehaviorSubject<MatchModel>();
  
  StreamSubscription<UserModel> _userSubscription;
  
  /*
   * SINGLETON
   */
  static MiniCardBloc _instance = MiniCardBloc._internal();

  factory MiniCardBloc() {
    return _instance;
  }

  MiniCardBloc._internal() {
    _loadingService = GetIt.I<PoolServices>().loadingService;
    _bookRepository = BookRepository();
    _currentindex = 0;
    _isAStorageBook = false;
    // Init Drag Controller
    _dragController = DragController();
    _dragController
        .init(GetIt.I<PoolServices>().futgolazoMainTheme.getResponsive);
    _user = GetIt.I<PoolServices>().dataService.user;
  }

  @override
  void dispose() {
    _currentMatch$.close();
    _miniBookList$?.close();
    _userSubscription?.cancel();
    _selectedMiniBook$?.close();

    _dragController.dispose();
  }

  int get currentMatchIndex => _currentindex;
  MatchModel get currentMatch => _currentMatch$.stream.value;
  Stream<MatchModel> get currentMatch$ => _currentMatch$.stream;
  BookModel get currentMiniCard => _selectedMiniBook$.stream.value;

  Stream<DragTargetModel> get dragTragetModel =>
      _dragController.dragModel$..stream;

  Future<List<BookModel>> getAvailableMiniCards() async {
    _loadingService.showLoadingScreen();
    GenericResponse genericResponse = await _bookRepository.getMiniBookList();
    _loadingService.hideLoadingScreen();

    List<BookModel> miniBooks = [];
    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      if (genericResponse.data == '[]') {
        return [];
      }

      (genericResponse.data as List<dynamic>).forEach((element) {
        BookModel book = BookModel.fromJsonMap(element);
        book.dateHuman = DateForHuman(book.firstMatchTime);
        miniBooks.add(book);
      });
    } else {
      //_showErrorMessage(genericResponse.errorStatus);
    }
    return miniBooks;
  }

  Future<BookModel> getBookByCountry(ResumeBookModel resumeBookModel) async {
    try {
      _loadingService.showLoadingScreen();
      GenericResponse genericResponse = await _bookRepository.getCountryBook(
          resumeBookModel.cardTypeId, resumeBookModel.countryCode);
      _loadingService.hideLoadingScreen();
      BookModel book = BookModel.fromJsonMap(genericResponse.data);
      book.dateHuman = DateForHuman(book.firstMatchTime);
      book.extractMatchesFromGroupList();
      return book;
    } catch (error) {
      GetIt.I<PoolServices>()
          .loadingService
          .showErrorSnackbar(error.toString());
      throw error;
    }
  }

  void setCurrentMiniCard(BookModel bookModel) async {
    _currentindex = 0;
    _selectedMiniBook$.add(bookModel);
    _currentMatch$.add(bookModel.matches[_currentindex]);
  }

  void changeDraggableWitnessPosition(Offset offset) {
    _dragController.changeDraggableWitnessPosition(offset);
  }

  void startDrag() {
    _dragController.startDrag();
  }

  void selectedPronosticOption(BuildContext context, DragTargetEnum option) {
    _dragController.restartProximity();
    MatchModel matchModel = _currentMatch$.stream.value;
    matchModel.matchResult = option;
    if (option == DragTargetEnum.DRAW) {
      Navigator.push(
        context,
        buildMiniCardSelectedRoute(
          miniCardBloc: this,
          name: 'Empate entre',
          matchModel: matchModel,
          dragTargetEnum: DragTargetEnum.DRAW,
        ),
      );
    } else {
      String name;
      Color teamPrimaryColor;
      String petImage;

      if (option == DragTargetEnum.LOCAL) {
        name = matchModel.local;
        petImage = matchModel.localBadgeImgUrl;
        teamPrimaryColor = matchModel.localPrimaryColor;
      } else {
        name = matchModel.visitant;
        petImage = matchModel.visitantBadgeImgUrl;
        teamPrimaryColor = matchModel.visitantPrimaryColor;
      }

      Navigator.push(
        context,
        buildMiniCardSelectedRoute(
          name: name,
          miniCardBloc: this,
          dragTargetEnum: option,
          selectedImage: petImage,
          selectedColor: teamPrimaryColor,
        ),
      );
    }
  }

  void nextMatch() {
    BookModel currentBook = _selectedMiniBook$.stream.value;
    if (_currentindex + 1 < currentBook.matches.length) {
      _currentindex++;
      _currentMatch$.add(currentBook.matches[_currentindex]);
    } else {
      _currentindex = 0;
      _currentMatch$.add(null);
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          Get.offNamed(NavigationRoute.MINI_CARD_PREVIEW);
        },
      );
    }
    _dragController.restartProximity();
  }

  void restarMinicard() {
    if (_isAStorageBook) {
      _startMiniCard();
    } else {
      _currentindex = 0;
      BookModel currentBook = _selectedMiniBook$.stream.value;
      _currentMatch$.add(currentBook.matches[_currentindex]);
      _dragController.restartProximity();
    }
  }

  void setCurrentMatch(MatchModel match) {
    _currentMatch$.add(match);
  }

  void restartProximity() {
    _dragController.restartProximity();
  }

  void sendMiniCard() {
    _onSendCard();
  }

  void setCurrentBookByStorage() {
    _isAStorageBook = true;
    var copyBook = jsonDecode(GetIt.I<PoolServices>()
        .sharedPrefsService
        .getBookIfUserHasNotRegister());
    _storedGuestBookID = copyBook['id'];
  }

  void _startMiniCard() async {
    List<BookModel> miniBooks = await getAvailableMiniCards();

    BookModel bookModel =
        miniBooks.firstWhere((element) => element.id == _storedGuestBookID);

    setCurrentMiniCard(bookModel);

    _isAStorageBook = false;
    _storedGuestBookID = 0;
    GetIt.I<PoolServices>().sharedPrefsService.removeBookUntilUserLogin();
  }

  void _onSendCard() async {
    UserModel currentUser = GetIt.I<PoolServices>().dataService.user;

    if (currentUser.isGuestUser) {
      _showNavegationPopup();
    } else if (currentUser.diamondCoins < 1) {
      _showNoCoinsPopup();
    } else {
      _loadingService.showLoadingScreen();

      var copyBook = _isAStorageBook
          ? jsonDecode(GetIt.I<PoolServices>()
              .sharedPrefsService
              .getBookIfUserHasNotRegister())
          : _createBook(currentMiniCard);

      BookRepository bookRepository = BookRepository();

      GenericResponse resp = await bookRepository.sendBook(
        _buildSendBookObject(
          currentUser,
          copyBook,
          payCoinEnum: CoinTypeEnum.DIAMOND_COIN,
        ),
        _user.countryInfo.countryCode,
      );

      _loadingService.hideLoadingScreen();
      if (resp.status == GenericResponseStatus.COMPLETED) {
        _successFlow(resp.data);
      } else {
        _showErrorMessage(resp.errorStatus);
      }
    }
  }

  Map<String, dynamic> _createBook(BookModel book) {
    var copyBook = {
      'id': book.id,
      'matches': [],
      'cardTypeId': 5,
      'coinType': 'DIAMOND_COIN',
    };

    for (int i = 0; i < book.matches.length; i++) {
      MatchModel element = book.matches[i];
      var newMatch = {
        'id': element.id,
        'matchResult': element.matchResult == DragTargetEnum.LOCAL
            ? 'L'
            : element.matchResult == DragTargetEnum.VISITANT ? 'V' : 'E',
      };

      (copyBook['matches'] as List<dynamic>).add(newMatch);
    }
    return copyBook;
  }

  Map<String, dynamic> _buildSendBookObject(UserModel user, Object book,
      {CoinTypeEnum payCoinEnum = CoinTypeEnum.GOLD_COIN}) {
    String paintCointType = '';

    switch (payCoinEnum) {
      case CoinTypeEnum.GOLD_COIN:
        paintCointType = 'GOLD_COIN';
        break;
      case CoinTypeEnum.DIAMOND_COIN:
        paintCointType = 'DIAMOND_COIN';
        break;
      case CoinTypeEnum.US_DOLLAR:
        paintCointType = 'US_DOLLAR';
        break;
    }

    var newBook = {
      'book': book,
      'email': user.email,
      'coinType': paintCointType,
    };

    return newBook;
  }

  void _successFlow(val) {
    UserCoinsBalanceModel balance = UserCoinsBalanceModel.fromJsonMap(val);
    GetIt.I<PoolServices>().dataService.changePlayerByBalance(balance);
    GetIt.I<PoolServices>().audioService.play(AudioFilePath.Gol);
    Get.close(2);
    Get.toNamed(NavigationRoute.MINI_CARD_SENT_SUCCESS);
  }

  void _showErrorMessage(int errorCode) {
    String errorMessage;
    switch (errorCode) {
      case 410:
        errorMessage =
            'ESTOS PARTIDOS YA EMPEZARON A JUGARSE, POR FAVOR ESPERA A LA SIGUIENTE MINI CARTILLA.';
        break;
      case 412:
        errorMessage =
            'No tienes suficientes Balones de Diamante, recuerda que el costo de enviar una Mini Cartilla es de 1 Balón de Dimante.';
        break;
      case 416:
        errorMessage = 'Ya enviaste tu Mini Cartilla de esta semana.';
        break;
      case 423:
        errorMessage = 'Verifica tu cuenta para poder enviar tu Mini Cartilla.';
        break;
      case 424:
        errorMessage =
            'Actualiza tus Datos para poder enviar tu Mini Cartilla.';
        break;
      case 0:
        errorMessage = 'Tenemos inconvenientes revisa tu conexión a Internet';
        break;
      default:
        errorMessage =
            'LO SENTIMOS, HA OCURRIDO UN ERROR Y TU MINI CARTILLA NO PUDO ENVIARSE. ESPERA UN MOMENTO Y VUELVE A INTENTARLO.';
        break;
    }
    _loadingService.showErrorSnackbar(errorMessage);
  }

  void _showNavegationPopup() {
    Get.dialog(
      SendCardAsGuestPopup(
        miniCardBloc: this,
        onAcceptCallback: () {
          var copyBook = _createBook(currentMiniCard);
          GetIt.I<PoolServices>()
              .sharedPrefsService
              .saveBookUntilUserLogin(jsonEncode(copyBook));
          Get.offAllNamed(NavigationRoute.SIGNUP);
        },
      ),
    );
  }

  void _showNoCoinsPopup() {
    Get.dialog(
      NoCoinsToBuyPopup(),
    );
  }
}
