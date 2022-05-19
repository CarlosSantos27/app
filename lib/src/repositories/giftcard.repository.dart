import 'dart:convert';

import 'package:futgolazo/src/networking/api_provider.dart';
import 'package:futgolazo/src/networking/generic_response.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:get_it/get_it.dart';

class GiftCardRepository {
  ApiProvider _apiProvider;
  GiftCardRepository() {
    _apiProvider = GetIt.I<PoolServices>().restApi;
  }

  Future<GenericResponse> claimGiftCard(String code) async => await _apiProvider
      .post('/apply-gift-card', jsonEncode({"cardCode": code.toUpperCase()}));
}
