import 'package:futgolazo/src/models/product.model.dart';
import 'package:futgolazo/src/networking/generic_response.dart';
import 'package:get_it/get_it.dart';

import '../services/pool_services.dart';
import '../networking/api_provider.dart';

class ShopRepository {
  ApiProvider _provider;

  ShopRepository() {
    _provider = GetIt.I<PoolServices>().restApi;
  }

  Future<List<ProductModel>> getProducts() async {
    final genericResponse = await _provider.get("prod/list");

    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      GetIt.I<PoolServices>().loadingService.showLoadingScreen();
      List<ProductModel> products =
          ProductsModel.listFromJsonMap(genericResponse.data).list;
      GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
      return products;
    }else if (genericResponse.errorStatus==0) {
      throw('Tenemos inconvenientes revisa tu conexión a Internet');
    }
    return null;
  }
}
