import 'package:laravel_notify_fcm/models/ny_laravel_slate_config.dart';

String stubFirebaseMessagingProvider(
        NyLaravelSlateConfig nyLaravelSlateConfig) =>
    '''
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:laravel_notify_fcm/laravel_notify_fcm.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/firebase_options.dart';

class FirebaseMessagingProvider implements NyProvider {
  @override
  boot(Nylo nylo) async {
    // check if Firebase is already initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await LaravelNotifyFcm.instance.init(
      url: 'http://otto.test/api/fcm',
      firebaseMessaging: firebaseMessaging,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      printInfo('A new onMessageOpenedApp event was published!');
      // handle your message here
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      printInfo('A new onMessage event was published!');
      // handle your message here
    });
    
    return nylo;
  }
  
  @override
  afterBoot(Nylo nylo) async {
  
  }
}
''';
