import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:laravel_notify_fcm/laravel_notify_fcm.dart';
import 'package:laravel_notify_fcm/networking/interceptors/interceptor_fcm_request.dart';
import 'package:nylo_support/networking/src/ny_api_service.dart';

/* LaravelFcmApiService
|--------------------------------------------------------------------------
| Define your API endpoints
| Learn more https://nylo.dev/docs/7.x/networking
|-------------------------------------------------------------------------- */

class LaravelFcmApiService extends NyApiService {
  @override
  Map<Type, Interceptor> get interceptors => {
        ...super.interceptors,
        InterceptorNotifyFCM: InterceptorNotifyFCM(),
      };

  /// Laravel FCM URL
  String get urlLaravel => LaravelNotifyFcm.instance.getUrl();

  /// Create or update device
  Future<bool?> createOrUpdateDevice(String? fcmToken,
      {bool active = true, required String sanctumToken}) async {
    return await network(
      request: (api) => api.put("/device", data: {
        "is_active": (active == true ? 1 : 0),
        "fcm_token": fcmToken,
      }),
      baseUrl: urlLaravel,
      headers: {
        "Authorization": "Bearer $sanctumToken",
      },
      handleSuccess: (response) {
        final dynamic data = response.data;
        if (data == null || data is! Map) return false;
        return data.containsKey('status') && data['status'] == 200;
      },
    );
  }

  /// Update the device meta data
  Future<bool?> updateDeviceMeta({required String sanctumToken}) async {
    Map<String, dynamic> deviceMeta;
    try {
      deviceMeta = LaravelNotifyFcm.instance.getDeviceMetaJson();
    } on LaravelNotifyFcmNotInitializedException catch (e) {
      if (LaravelNotifyFcm.instance.debugEnabled()) {
        if (kDebugMode) {
          print('[LaravelNotifyFcm] updateDeviceMeta skipped: ${e.message}');
        }
      }
      return null;
    }
    return await network(
      request: (api) => api.patch("/device/meta", data: {
        if (deviceMeta.containsKey('uuid')) "uuid": deviceMeta['uuid'] ?? "",
        if (deviceMeta.containsKey('model')) "model": deviceMeta['model'] ?? "",
        if (deviceMeta.containsKey('name'))
          "display_name": deviceMeta['name'] ?? "",
        if (deviceMeta.containsKey('platform_type'))
          "platform": deviceMeta['platform_type'] ?? "",
        if (deviceMeta.containsKey('version'))
          "version": deviceMeta['version'] ?? "",
      }),
      baseUrl: urlLaravel,
      headers: {
        "Authorization": "Bearer $sanctumToken",
      },
      handleSuccess: (response) {
        final dynamic data = response.data;
        if (data == null || data is! Map) return false;
        return data.containsKey('status') && data['status'] == 200;
      },
    );
  }
}
