import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _tokenFCM = '';

  initPushNotification() async {
    _firebaseMessaging.requestNotificationPermissions();

    _tokenFCM = await _firebaseMessaging.getToken();

    print('================= FCM =====================');
    print(tokenFCM);
    print('===========================================');

    _firebaseMessaging.configure(
      onLaunch: (info) async {
        print('onlaunch');
      },
      onMessage: (info) async {
        print('onmessage');
      },
      onResume: (info) async {
        print('on resume');
      },
    );
  }

  /// ----------------------------------------------------------
  /// Method that returns the token FCM
  /// ----------------------------------------------------------
  String get tokenFCM => _tokenFCM;

  Future<void> subscribeToTopicDefault() =>
      _firebaseMessaging.subscribeToTopic('common');

  Future<void> unsubscribeTopicDefault() =>
      _firebaseMessaging.unsubscribeFromTopic('common');

  Future<void> configTopic(bool allow) async {
    if (allow) {
      return await subscribeToTopicDefault();
    } else {
      return await unsubscribeTopicDefault();
    }
  }
}
