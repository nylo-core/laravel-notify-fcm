String stubRegisterForNotificationsEvent() => '''
import 'package:laravel_notify_fcm/laravel_notify_fcm.dart';
import 'package:nylo_framework/nylo_framework.dart';

class RegisterForNotificationsEvent implements NyEvent {

  @override
  final listeners = {
    DefaultListener: DefaultListener(),
  };
}

class DefaultListener extends NyListener {

  @override
  handle(dynamic event) async {
    dynamic userData = await Auth.data();
    if (userData !is Map) {
      return;
    }

    userData as Map;
    if (!userData.containsKey('token')) {
      return;
    }
    
    if (userData['token'] == null) {
      return;
    }
    
    String userToken = userData['token'];
    
    await LaravelNotifyFcm.storeFcmDevice(
        sanctumToken: userToken);
  }
}
''';
