library laravel_notify_fcm;

import 'dart:io';

import 'package:device_meta/device_meta.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:laravel_notify_fcm/networking/laravel_fcm_api_service.dart';

/// LaravelNotifyFcm version
const String _laravelNotifyFcmVersion = '0.0.4';

/// LaravelNotifyFcm class
class LaravelNotifyFcm {
  LaravelNotifyFcm._privateConstructor();

  static final LaravelNotifyFcm instance =
      LaravelNotifyFcm._privateConstructor();

  static String get version => _laravelNotifyFcmVersion;

  bool _debugMode = false;

  FirebaseMessaging? _firebaseMessaging;

  String? sanctumToken;

  final LaravelFcmApiService apiService = LaravelFcmApiService();

  String? _url;

  DeviceMeta? _deviceMeta;

  /// Initialize LaravelNotifyFcm
  init(
      {required FirebaseMessaging firebaseMessaging,
      required String url,
      bool debugMode = false}) async {
    _debugMode = debugMode;
    _firebaseMessaging = firebaseMessaging;
    _url = url;
    _deviceMeta =
        await DeviceMeta.init(storageKey: "laravel_notify_fcm_device_meta");
  }

  /// Check if debug mode is enabled
  bool debugEnabled() {
    return _debugMode;
  }

  /// Get the DeviceMeta instance
  Map<String, dynamic> getDeviceMetaJson() {
    if (_deviceMeta == null) {
      throw Exception(
          "DeviceMeta instance is null. Please initialize LaravelNotifyFcm first.");
    }
    return _deviceMeta!.toJson();
  }

  /// Get the FirebaseMessaging instance
  FirebaseMessaging getFirebaseMessaging() {
    if (_firebaseMessaging == null) {
      throw Exception(
          "FirebaseMessaging instance is null. Please initialize LaravelNotifyFcm first.");
    }
    return _firebaseMessaging!;
  }

  /// Get the FCM token
  static Future<String?> getFcmToken() async {
    FirebaseMessaging firebaseMessaging =
        LaravelNotifyFcm.instance.getFirebaseMessaging();
    return await firebaseMessaging.getToken();
  }

  /// Get the URL
  String getUrl() {
    if (_url == null) {
      throw Exception("URL is null. Please initialize LaravelNotifyFcm first.");
    }
    return _url!;
  }

  /// Get Sanctum token
  String? getSanctumToken() {
    if (sanctumToken == null) {
      print("Sanctum token is null. Please set the sanctum token first.");
    }
    return sanctumToken!;
  }

  /// Set Sanctum token
  void setSanctumToken(String token) {
    sanctumToken = token;
  }

  /// Request permission to send notifications
  static Future<NotificationSettings?> storeFcmDevice({
    required String sanctumToken,

    /// Request permission to display alerts. Defaults to `true`.
    ///
    /// iOS/macOS only.
    bool alert = true,

    /// Request permission for Siri to automatically read out notification messages over AirPods.
    /// Defaults to `false`.
    ///
    /// iOS only.
    bool announcement = false,

    /// Request permission to update the application badge. Defaults to `true`.
    ///
    /// iOS/macOS only.
    bool badge = true,

    /// Request permission to display notifications in a CarPlay environment.
    /// Defaults to `false`.
    ///
    /// iOS only.
    bool carPlay = false,

    /// Request permission for critical alerts. Defaults to `false`.
    ///
    /// Note; your application must explicitly state reasoning for enabling
    /// critical alerts during the App Store review process or your may be
    /// rejected.
    ///
    /// iOS only.
    bool criticalAlert = false,

    /// Request permission to provisionally create non-interrupting notifications.
    /// Defaults to `false`.
    ///
    /// iOS only.
    bool provisional = false,

    /// Request permission to play sounds. Defaults to `true`.
    ///
    /// iOS/macOS only.
    bool sound = true,
  }) async {
    FirebaseMessaging _firebaseMessaging =
        LaravelNotifyFcm.instance.getFirebaseMessaging();

    LaravelNotifyFcm.instance.sanctumToken = sanctumToken;

    NotificationSettings? notificationSettings;
    if (Platform.isIOS) {
      notificationSettings = await _firebaseMessaging.requestPermission();
    }

    await enableFcmDevice();

    return notificationSettings;
  }

  /// Enable FCM device
  static Future<bool> enableFcmDevice() async {
    return await LaravelNotifyFcm.apiServiceFcm(
        (api) => api.createOrUpdateDevice(active: true));
  }

  /// Disable FCM device
  static Future<bool> disableFcmDevice() async {
    return await LaravelNotifyFcm.apiServiceFcm(
        (api) => api.createOrUpdateDevice(active: false));
  }

  /// Get the LaravelFcmApiService instance
  static apiServiceFcm(
      Function(LaravelFcmApiService apiService) callback) async {
    await callback(LaravelNotifyFcm.instance.apiService);
  }
}
