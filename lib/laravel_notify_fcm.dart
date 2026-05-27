import 'package:device_meta/device_meta.dart';
import 'package:laravel_notify_fcm/exceptions/laravel_notify_fcm_exception.dart';
import 'package:laravel_notify_fcm/networking/laravel_fcm_api_service.dart';

export 'package:laravel_notify_fcm/exceptions/laravel_notify_fcm_exception.dart';

/// LaravelNotifyFcm version. Keep in sync with `version:` in pubspec.yaml.
const String _laravelNotifyFcmVersion = '3.1.2';

/// LaravelNotifyFcm class
class LaravelNotifyFcm {
  LaravelNotifyFcm._();

  static final LaravelNotifyFcm instance = LaravelNotifyFcm._();

  /// Current package version (e.g. `3.1.2`).
  static String get version => _laravelNotifyFcmVersion;

  bool _debugMode = false;

  /// Shared [LaravelFcmApiService] used for all backend calls.
  ///
  /// Prefer reaching this through [apiServiceFcm] so the resolution
  /// strategy can change later without churning call sites.
  late final LaravelFcmApiService apiService = LaravelFcmApiService();

  String? _url;

  DeviceMeta? _deviceMeta;

  /// Initialize LaravelNotifyFcm. Subsequent calls are no-ops.
  Future<void> init({required String url, bool debugMode = false}) async {
    if (_deviceMeta != null) return;
    _debugMode = debugMode;
    _url = url;
    _deviceMeta =
        await DeviceMeta.init(storageKey: "laravel_notify_fcm_device_meta");
  }

  /// Whether debug logging was enabled in [init].
  bool debugEnabled() {
    return _debugMode;
  }

  /// Get the current device metadata as a JSON map.
  ///
  /// Throws [LaravelNotifyFcmNotInitializedException] when [init] has not run.
  Map<String, dynamic> getDeviceMetaJson() {
    if (_deviceMeta == null) {
      throw LaravelNotifyFcmNotInitializedException(
          "DeviceMeta instance is null. Please call LaravelNotifyFcm.instance.init() first.");
    }
    return _deviceMeta!.toJson();
  }

  /// Base URL of the Laravel backend, as passed to [init].
  ///
  /// Throws [LaravelNotifyFcmNotInitializedException] when [init] has not run.
  String getUrl() {
    if (_url == null) {
      throw LaravelNotifyFcmNotInitializedException(
          "URL is null. Please call LaravelNotifyFcm.instance.init() first.");
    }
    return _url!;
  }

  /// Store FCM device token with the Laravel backend.
  ///
  /// Sends the [fcmToken] and device metadata to Laravel for push notification
  /// delivery. Requires a valid [sanctumToken] for authentication.
  ///
  /// When [syncDeviceMeta] is `true`, also pushes the latest device metadata
  /// (uuid, model, display name, platform, version) to Laravel via
  /// `PATCH /device/meta` after the device is stored. The returned `Future`
  /// resolves to `true` only when both the store and the meta sync succeed.
  static Future<bool> storeFcmDevice(
    String? fcmToken, {
    required String sanctumToken,
    bool syncDeviceMeta = false,
  }) async {
    final stored = await enableFcmDevice(fcmToken, sanctumToken: sanctumToken);
    if (!syncDeviceMeta) {
      return stored;
    }
    final synced =
        await LaravelNotifyFcm.syncDeviceMeta(sanctumToken: sanctumToken);
    return stored && synced;
  }

  /// Enable FCM device
  static Future<bool> enableFcmDevice(String? fcmToken,
      {required String sanctumToken}) async {
    return await LaravelNotifyFcm.apiServiceFcm<bool?>((api) =>
            api.createOrUpdateDevice(fcmToken, sanctumToken: sanctumToken)) ??
        false;
  }

  /// Disable FCM device
  static Future<bool> disableFcmDevice(String? fcmToken,
      {required String sanctumToken}) async {
    return await LaravelNotifyFcm.apiServiceFcm<bool?>((api) =>
            api.createOrUpdateDevice(fcmToken,
                active: false, sanctumToken: sanctumToken)) ??
        false;
  }

  /// Sync the current device meta data with the Laravel backend.
  ///
  /// Sends the latest device metadata (uuid, model, display name, platform,
  /// version) to Laravel so dashboard staff always see up-to-date device
  /// information for the user. Requires a valid [sanctumToken] for
  /// authentication.
  static Future<bool> syncDeviceMeta({required String sanctumToken}) async {
    return await LaravelNotifyFcm.apiServiceFcm<bool?>(
            (api) => api.updateDeviceMeta(sanctumToken: sanctumToken)) ??
        false;
  }

  /// Run [callback] with the shared [LaravelFcmApiService] instance.
  ///
  /// This is the sanctioned way to reach [apiService] from outside the
  /// package; internal call sites use it so the resolution strategy can
  /// change later (e.g. test injection) without touching every caller.
  static Future<T> apiServiceFcm<T>(
      Future<T> Function(LaravelFcmApiService apiService) callback) {
    return callback(LaravelNotifyFcm.instance.apiService);
  }
}
