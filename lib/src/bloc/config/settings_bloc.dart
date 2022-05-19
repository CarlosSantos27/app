import 'package:futgolazo/src/repositories/user.repository.dart';
import 'package:get_it/get_it.dart';

import '../../services/pool_services.dart';

class SettingsBloc {
  bool activeSound;
  bool activeNotification;

  UserRepository _userRepository;

  SettingsBloc()
      : activeSound = GetIt.I<PoolServices>().sharedPrefsService.statusSound,
        activeNotification =
            GetIt.I<PoolServices>().sharedPrefsService.allowNotification,
        _userRepository = UserRepository();

  onSoundsMute(setState) {
    return (bool status) {
      GetIt.I<PoolServices>().audioService.mute(status);
      GetIt.I<PoolServices>().sharedPrefsService.statusSound = status;
      setState(() {
        activeSound = status;
      });
    };
  }

  onNotificationActive(setState) {
    return (bool status) async {
      await _userRepository.allowNotification(status);
      GetIt.I<PoolServices>().sharedPrefsService.allowNotification = status;
      GetIt.I<PoolServices>().pushNotificationProvider.configTopic(status);
      setState(() {
        activeNotification = status;
      });
    };
  }
}
