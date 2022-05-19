import './env.model.dart';
import './env.interface.dart';

class EnviromentInt implements EnviromentInterface {
  @override
  EnvModel config() {
    return EnvModel(
      miniCardSync: "mini_card_int_ec",
      apiPath: 'https://int.futgolazo.com.ec/api/',
      imagePath: 'https://int.futgolazo.com.ec/assets/',
    );
  }
}
