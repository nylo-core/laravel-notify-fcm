import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:laravel_notify_fcm/laravel_notify_fcm.dart';

void main() async {
  // Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  LaravelNotifyFcm.instance.init(
    firebaseMessaging: firebaseMessaging,
    url: "https://example.com/api/fcm",
    debugMode: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  // This is a simple example of how to use Media Pro.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Laravel Notify Fcm")),
      body: SafeArea(
        child: Container(
          child: InkWell(
            child: Text("Enable notifications"),
            onTap: () async {
              // get your sanctum token from your Laravel app

              await LaravelNotifyFcm.storeFcmDevice(
                  sanctumToken: 'sanctumToken');
            },
          ),
        ),
      ),
    );
  }
}
