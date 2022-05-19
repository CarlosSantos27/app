import 'package:flutter/foundation.dart';

import './env.int.dart';
import './env.prod.dart';
import './env.model.dart';

class EnvironmentConfig {
  bool _prodMode = false;

  EnvironmentConfig() : _prodMode = kReleaseMode;

  EnvModel get environment =>
      _prodMode ? EnviromentProd().config() : EnviromentInt().config();
}
