library laravel_notify_fcm;

import 'package:device_meta/device_meta.dart';
import '/exceptions/laravel_notify_fcm_exception.dart';
import '/networking/laravel_fcm_api_service.dart';
export '/exceptions/laravel_notify_fcm_exception.dart';

/// LaravelNotifyFcm version
const String _laravelNotifyFcmVersion = '3.0.0';

/// LaravelNotifyFcm class
class LaravelNotifyFcm {
  LaravelNotifyFcm._privateConstructor();

  static final LaravelNotifyFcm instance =
      LaravelNotifyFcm._privateConstructor();

  static String get version => _laravelNotifyFcmVersion;

  bool _debugMode = false;

  final LaravelFcmApiService apiService = LaravelFcmApiService();

  String? _url;

  DeviceMeta? _deviceMeta;

  /// Initialize LaravelNotifyFcm
  Future<void> init({required String url, bool debugMode = false}) async {
    _debugMode = debugMode;
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
      throw LaravelNotifyFcmNotInitializedException(
          "DeviceMeta instance is null. Please call LaravelNotifyFcm.instance.init() first.");
    }
    return _deviceMeta!.toJson();
  }

  /// Get the URL
  String getUrl() {
    if (_url == null) {
      throw LaravelNotifyFcmNotInitializedException(
          "URL is null. Please call LaravelNotifyFcm.instance.init() first.");
    }
    return _url!;
  }

  /// Store FCM device token with the Laravel backend.
  ///
  /// Sends the [fcmToken] and device metadata to Laravel for push notification delivery.
  /// Requires a valid [sanctumToken] for authentication.
  static Future<bool?> storeFcmDevice(
    String? fcmToken, {
    required String sanctumToken,
  }) async {
    return await enableFcmDevice(fcmToken, sanctumToken: sanctumToken);
  }

  /// Enable FCM device
  static Future<bool> enableFcmDevice(String? fcmToken,
      {required String sanctumToken}) async {
    return await LaravelNotifyFcm.apiServiceFcm((api) =>
            api.createOrUpdateDevice(fcmToken,
                active: true, sanctumToken: sanctumToken)) ??
        false;
  }

  /// Disable FCM device
  static Future<bool> disableFcmDevice(String? fcmToken,
      {required String sanctumToken}) async {
    return await LaravelNotifyFcm.apiServiceFcm((api) =>
            api.createOrUpdateDevice(fcmToken,
                active: false, sanctumToken: sanctumToken)) ??
        false;
  }

  /// Get the LaravelFcmApiService instance
  static Future<dynamic> apiServiceFcm(
      Function(LaravelFcmApiService apiService) callback) async {
    return await callback(LaravelNotifyFcm.instance.apiService);
  }
}
