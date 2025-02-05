import 'dart:io';

import 'package:laravel_notify_fcm/cli_dialog/cli_dialog.dart';
import 'package:laravel_notify_fcm/models/ny_laravel_slate_config.dart';
import 'package:laravel_notify_fcm/slate_laravel_notify_fcm.dart';
import 'package:nylo_support/metro/metro_console.dart';
import 'package:nylo_support/metro/metro_service.dart';
import 'package:nylo_support/metro/models/ny_template.dart';

void main(List<String> arguments) async {
  if (arguments.length != 1) {
    MetroConsole.writeInRed("Invalid arguments");
    MetroConsole.writeInRed("Usage: dart run laravel_notify_fcm:main install");
    exit(1);
  }

  String command = arguments[0];
  if (command != 'install') {
    MetroConsole.writeInRed("Invalid command");
    MetroConsole.writeInRed("Usage: dart run laravel_notify_fcm:main install");
    exit(1);
  }

  final dialogLaravelUrl = CliDialog(questions: [
    ['What is your Laravel Url?', 'laravel_url']
  ]);

  String laravelUrl = dialogLaravelUrl.ask()['laravel_url'];
  // remove trailing slash if exists
  if (laravelUrl.endsWith('/')) {
    laravelUrl = laravelUrl.substring(0, laravelUrl.length - 1);
  }

  await MetroService.addPackage("firebase_core");
  await MetroService.addPackage("firebase_messaging");
  await MetroService.addPackage("laravel_notify_fcm");

  NyLaravelSlateConfig nyLaravelSlateConfig = NyLaravelSlateConfig(
    url: laravelUrl,
  );

  List<NyTemplate> templates = laravelNotifyFcmSlateRun(nyLaravelSlateConfig);
  await MetroService.createSlate(templates, hasForceFlag: true);

  MetroConsole.writeInGreen(
      'Go to your Laravel project\n\nRun: composer require nylo/laravel-fcm-channel\n\nThen run: php artisan laravelfcm:install');
  MetroConsole.writeInGreen(
      'Make sure you have Laravel Sanctum installed\n Run: php artisan install:api\n\nYour User model must use the HasApiTokens trait');

  // usage instructions
  String usageInstructions = '''
Use the following code to register for notifications:
event<RegisterForNotificationsEvent>();

Make sure to call this code after the user has logged in.

You can also use the enable notifications page:
routeTo(EnableNotificationsPage.path);

This will prompt the user to enable notifications.
''';

  String firebaseInfo = "\nSetup Firebase";
  firebaseInfo +=
      "\n- Create a Firebase project: https://console.firebase.google.com";
  firebaseInfo +=
      "\n- Download flutterfire: https://firebase.google.com/docs/flutter/setup";
  firebaseInfo += "\n- Run `flutterfire configure`";
  firebaseInfo += "\n- For IOS, you'll need to do the following steps";
  firebaseInfo +=
      "\n  - Project settings > Cloud Messaging > iOS app configuration";
  firebaseInfo +=
      "\n  - Add your APNs Authentication Key from your Apple Developer account";

  MetroConsole.writeInGreen("\n\n$usageInstructions$firebaseInfo");

  exit(0);
}
