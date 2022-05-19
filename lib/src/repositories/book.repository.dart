import 'dart:convert';

import 'package:futgolazo/src/enums/book_status.enum.dart';
import 'package:futgolazo/src/models/date_range_mini_card.model.dart';
import 'package:futgolazo/src/models/resume_book.model.dart';
import 'package:futgolazo/src/models/user.model.dart';
import 'package:futgolazo/src/networking/api_provider.dart';
import 'package:futgolazo/src/networking/generic_response.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:get_it/get_it.dart';

class BookRepository {
  ApiProvider _provider;

  BookRepository() {
    _provider = GetIt.I<PoolServices>().restApi;
  }

  /*
	 * Método para obtener la Mini Cartilla
	 */
  Future<GenericResponse> getMiniBook(UserModel user) async {
    var param = {
      'email': user != null && user.email != null ? user.email : null,
      'cardTypeId': 5
    };

    final genericResponse = await _provider.post('/card', jsonEncode(param));
    return genericResponse;
  }

  ///#### Método para obtener cartilla vigente por tipo y pais
  ///
  ///Param
  ///- [cardTypeId] _int_
  ///- [countryCode] _String_
  ///
  ///Return
  ///- _BookModel_
  Future<GenericResponse> getCountryBook(
      int cardTypeId, String countryCode) async {
    final params = {'email': null, 'cardTypeId': cardTypeId};
    final headers = {'country-code': countryCode};
    final genericResponse =
        await _provider.post('/card', jsonEncode(params), headers: headers);
    return genericResponse;
  }

  /*
	 * Método para obtener el listado de Mini Cartillas
	 */
  Future<GenericResponse> getMiniBookList() async {
    final genericResponse =
        await _provider.get('/available-cards?cardTypeId=5');
    return genericResponse;
  }

  /*
	 * Método para crear cartilla
	 */
  Future<GenericResponse> sendBook(
      Map<String, Object> newBook, String countryCode) async {
    final headers = {'country-code': countryCode};
    final genericResponse = await _provider
        .post('/save/prognostic', jsonEncode(newBook), headers: headers);
    return genericResponse;
  }

  ///#### Método para obtener el listado de jugadas activas (estan en juego o aún no disponen de resultados)
  ///
  ///Return
  ///- [cardSummary] _List od data [ResumeBookModel]_
  Future<GenericResponse> getActivePlaysList() async {
    return await _provider.get('/active-plays');
  }

  Future<GenericResponse> getDateRangesMiniBooks() async {
    return await _provider.get('/result-date-ranges');
  }

  Future<GenericResponse> getResultMiniCard(
      DateRangeMiniCardModel rangeDate) async {
    final params = {"month": rangeDate.month, "year": rangeDate.year};
    return await _provider.post('/result-plays', jsonEncode(params));
  }

  Future<GenericResponse> getMinicardInfo(
      int idCard, String countryCode) async {
    final params = {"cardTypeId": 5, "id": idCard, "showCardList": false};
    final headers = {'country-code': countryCode};
    return await _provider.post('/results', jsonEncode(params),
        headers: headers);
  }

  Future<GenericResponse> progresults(int bookId) async {
    final params = {
      "pageSize": 10000,
      "pageNumber": 1,
      "showCardList": true,
      "cardTypeId": BookTypeEnum.MINIBOOK.index,
      "id": bookId
    };
    return await _provider.post('/progresults', jsonEncode(params));
  }

  ///#### Servicio para obtener datos de mis cartillas
  ///
  ///Return
  ///- [card] _BookModel_ Información de la cartilla
  Future<GenericResponse> getMyBooks(
      int cardId, int cardTypeId, String countryCode) async {
    final params = {"email": null, "id": cardId, "cardTypeId": cardTypeId};
    final headers = {'country-code': countryCode};
    return await _provider.post('/mycards', jsonEncode(params),
        headers: headers);
  }

  ///#### Servicio para obtener lista de pronosticos en mis cartillas
  ///
  ///Return
  ///- [count] _Page Count of Paged Data_
  ///- [prognostics] _[PrognosticModel]_ List of PrognosticModel
  Future<GenericResponse> getMyBooksProgs(
      int cardId, int cardTypeId, String countryCode, int pageNumber) async {
    final params = {
      "pageSize": 20,
      "id": cardId,
      "cardTypeId": cardTypeId,
      "pageNumber": pageNumber
    };
    final headers = {'country-code': countryCode};
    return await _provider.post('/progs', jsonEncode(params), headers: headers);
  }
}
