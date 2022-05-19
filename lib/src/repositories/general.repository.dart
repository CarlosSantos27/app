import 'package:futgolazo/src/routes/routes.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'package:futgolazo/src/models/country.model.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/networking/api_provider.dart';
import 'package:futgolazo/src/networking/generic_response.dart';

class GeneralRepository {
  ApiProvider _provider;

  GeneralRepository() {
    _provider = GetIt.I<PoolServices>().restApi;
  }

  Future<List<CountryInfo>> getCountries() async {
    List<CountryInfo> countries = List<CountryInfo>();
    final genericResponse = await _provider.get("country-info");

    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      final response = genericResponse.data;
      if (response != null) {
        countries =
            (response as List).map((i) => CountryInfo.fromJsonMap(i)).toList();
      }
    } else if (genericResponse.errorStatus == 0) {
      GetIt.I<PoolServices>().loadingService.showErrorSnackbar(
            'Tenemos inconvenientes revisa tu conexión a Internet',
          );
      Get.offNamedUntil(NavigationRoute.INTRO, (route)=>false);
    }
    return countries;
  }

  Future<dynamic> getNotiAll() async {
    await _provider.get('notif/all');
  }
}
