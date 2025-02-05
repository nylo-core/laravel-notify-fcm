// stubs
import '/stubs/stub_enable_notifications_page.dart';
import '/stubs/stub_firebase_messaging_provider.dart';
import '/stubs/stub_register_for_notifications_event.dart';

// nylo_support
import 'package:nylo_support/metro/constants/strings.dart';
import 'package:nylo_support/metro/models/ny_template.dart';

import 'models/ny_laravel_slate_config.dart';

/// Slate run for LaravelNotifyFcm
laravelNotifyFcmSlateRun(NyLaravelSlateConfig nyLaravelSlateConfig) {
  return [
    /// PROVIDERS
    NyTemplate(
      name: "firebase_messaging_provider",
      saveTo: providerFolder,
      pluginsRequired: ["nylo_framework", "firebase_core"],
      stub: stubFirebaseMessagingProvider(nyLaravelSlateConfig),
    ),

    /// PAGES
    NyTemplate(
      name: "enable_notifications_page",
      saveTo: pagesFolder,
      pluginsRequired: ["nylo_framework", "laravel_notify_fcm"],
      stub: stubEnableNotificationsPage(),
    ),

    /// EVENTS
    NyTemplate(
      name: "register_for_notifications_event",
      saveTo: eventsFolder,
      pluginsRequired: ["nylo_framework"],
      stub: stubRegisterForNotificationsEvent(),
    ),
  ];
}
