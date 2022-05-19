import './env.model.dart';
import './env.interface.dart';

class EnviromentProd implements EnviromentInterface {
  @override
  EnvModel config() {
    return EnvModel(
      miniCardSync: "mini_card_prod_ec",
      apiPath: 'https://futgolazo.com.ec/api/',
      imagePath: 'https://futgolazo.com.ec/assets/',
    );
  }
}
