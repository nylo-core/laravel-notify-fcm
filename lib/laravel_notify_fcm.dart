import 'package:device_meta/device_meta.dart';
import 'package:laravel_notify_fcm/exceptions/laravel_notify_fcm_exception.dart';
import 'package:laravel_notify_fcm/networking/laravel_fcm_api_service.dart';

export 'package:device_meta/device_meta.dart' show DeviceMeta;
export 'package:laravel_notify_fcm/exceptions/laravel_notify_fcm_exception.dart';

/// LaravelNotifyFcm version. Keep in sync with `version:` in pubspec.yaml.
const String _laravelNotifyFcmVersion = '3.2.0';

/// LaravelNotifyFcm class
class LaravelNotifyFcm {
  LaravelNotifyFcm._();

  static final LaravelNotifyFcm instance = LaravelNotifyFcm._();

  /// Current package version (e.g. `3.2.0`).
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

  /// Get the current device metadata as a typed [DeviceMeta] object.
  ///
  /// Returns the live [DeviceMeta] singleton, giving direct access to typed
  /// fields (`uuid`, `model`, `name`, `platformType`, `version`, ...) and
  /// helpers like `getMetaData<T>()`. Use [getDeviceMetaJson] if you only need
  /// a plain `Map<String, dynamic>`.
  ///
  /// Note: this is the same instance the package uses internally (also reachable
  /// via `DeviceMeta.instance`). Mutating its fields changes the values this
  /// package subsequently sends to your Laravel backend.
  ///
  /// Throws [LaravelNotifyFcmNotInitializedException] when [init] has not run.
  DeviceMeta getDeviceMeta() {
    if (_deviceMeta == null) {
      throw LaravelNotifyFcmNotInitializedException(
          "DeviceMeta instance is null. Please call LaravelNotifyFcm.instance.init() first.");
    }
    return _deviceMeta!;
  }

  /// Get the current device metadata as a JSON map.
  ///
  /// Throws [LaravelNotifyFcmNotInitializedException] when [init] has not run.
  Map<String, dynamic> getDeviceMetaJson() {
    return getDeviceMeta().toJson();
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
  /// Sends the [fcmToken] to Laravel for push notification delivery. Requires a
  /// valid [sanctumToken] for authentication.
  ///
  /// Device metadata (uuid, model, display name, platform, version) travels on
  /// the same request via the `X-DMETA` header and is persisted by the
  /// backend's `AppApiRequestMiddleware` before the controller runs — so a
  /// single `PUT /device` call stores both the token and the metadata. No
  /// separate meta-sync request is needed.
  static Future<bool> storeFcmDevice(
    String? fcmToken, {
    required String sanctumToken,
    @Deprecated(
      'Device metadata is now synced on the same request via the X-DMETA '
      'header, so this no longer triggers a second call. The flag is ignored '
      'and will be removed in 4.0.0.',
    )
    bool syncDeviceMeta = false,
  }) async {
    return await enableFcmDevice(fcmToken, sanctumToken: sanctumToken);
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
