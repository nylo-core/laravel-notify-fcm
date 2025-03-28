String stubEnableNotificationsPage() => '''
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/events/register_for_notifications_event.dart';
import '/resources/widgets/buttons/buttons.dart';
import '/resources/widgets/safearea_widget.dart';

class EnableNotificationsPage extends NyStatefulWidget {
  static RouteView path =
      ("/enable-notifications", (_) => EnableNotificationsPage());

  EnableNotificationsPage({super.key})
      : super(child: () => _EnableNotificationsPageState());
}

class _EnableNotificationsPageState extends NyPage<EnableNotificationsPage> {

  nextPage() async {
      // await routeTo(YourNextPage.path, navigationType: NavigationType.pushReplace);
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: SafeAreaWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Enable Notifications")
                    .headingLarge(fontWeight: FontWeight.bold),
                Text("Receive notifications so you'll never miss a moment")
                    .bodyLarge(),
              ],
            ).withGap(7),
            Icon(Icons.notifications, size: 60),
            Column(
              children: [
                Button.primary(
                    text: "Enable Notifications",
                    onPressed: () async {
                      await event<RegisterForNotificationsEvent>();
                      
                      await nextPage();
                    }),
                Button.textOnly(
                    text: "Skip",
                    textColor: Colors.grey,
                    onPressed: () async {
                      await nextPage();
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
''';
