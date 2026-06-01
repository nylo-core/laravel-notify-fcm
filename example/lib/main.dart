import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:laravel_notify_fcm/laravel_notify_fcm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LaravelNotifyFcm.instance.init(
    url: "https://example.com/api/fcm",
    debugMode: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laravel Notify FCM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _fcmTokenController = TextEditingController();
  final TextEditingController _sanctumTokenController = TextEditingController();
  String _statusMessage = 'Idle. Paste tokens above and tap an action.';

  @override
  void dispose() {
    _fcmTokenController.dispose();
    _sanctumTokenController.dispose();
    super.dispose();
  }

  String get _fcmToken => _fcmTokenController.text.trim();
  String get _sanctumToken => _sanctumTokenController.text.trim();

  Future<void> _runAction(
    String label,
    Future<Object?> Function() action,
  ) async {
    setState(() => _statusMessage = '$label → running…');
    try {
      final result = await action();
      setState(() => _statusMessage = '$label → $result');
    } catch (e) {
      setState(() => _statusMessage = '$label error: $e');
    }
  }

  Future<void> _onStoreDevice() => _runAction(
        'storeFcmDevice',
        () => LaravelNotifyFcm.storeFcmDevice(
          _fcmToken,
          sanctumToken: _sanctumToken,
        ),
      );

  Future<void> _onEnableDevice() => _runAction(
        'enableFcmDevice',
        () => LaravelNotifyFcm.enableFcmDevice(
          _fcmToken,
          sanctumToken: _sanctumToken,
        ),
      );

  Future<void> _onDisableDevice() => _runAction(
        'disableFcmDevice',
        () => LaravelNotifyFcm.disableFcmDevice(
          _fcmToken,
          sanctumToken: _sanctumToken,
        ),
      );

  Future<void> _onSyncDeviceMeta() => _runAction(
        'syncDeviceMeta',
        () => LaravelNotifyFcm.syncDeviceMeta(sanctumToken: _sanctumToken),
      );

  void _onShowDeviceMeta() {
    try {
      final meta = LaravelNotifyFcm.instance.getDeviceMetaJson();
      final pretty = const JsonEncoder.withIndent('  ').convert(meta);
      setState(() => _statusMessage = 'getDeviceMetaJson →\n$pretty');
    } catch (e) {
      setState(() => _statusMessage = 'getDeviceMetaJson error: $e');
    }
  }

  void _onShowDeviceMetaTyped() {
    try {
      // Explicit DeviceMeta type resolves via the re-export from
      // laravel_notify_fcm.dart — no separate device_meta import needed.
      final DeviceMeta meta = LaravelNotifyFcm.instance.getDeviceMeta();
      setState(() => _statusMessage = 'getDeviceMeta →\n'
          'uuid: ${meta.uuid}\nmodel: ${meta.model}\n'
          'platform: ${meta.platformType}\nversion: ${meta.version}');
    } catch (e) {
      setState(() => _statusMessage = 'getDeviceMeta error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laravel Notify FCM')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _fcmTokenController,
                decoration: const InputDecoration(
                  labelText: 'FCM token',
                  helperText:
                      'In a real app, get this from FirebaseMessaging.instance.getToken()',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _sanctumTokenController,
                decoration: const InputDecoration(
                  labelText: 'Sanctum token',
                  helperText:
                      'Issued by your Laravel app after the user logs in',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onStoreDevice,
                child: const Text('Store device'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _onEnableDevice,
                child: const Text('Enable notifications'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _onDisableDevice,
                child: const Text('Disable notifications'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _onSyncDeviceMeta,
                child: const Text('Sync device meta'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _onShowDeviceMeta,
                child: const Text('Show device meta'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _onShowDeviceMetaTyped,
                child: const Text('Show device meta (typed)'),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        _statusMessage,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
