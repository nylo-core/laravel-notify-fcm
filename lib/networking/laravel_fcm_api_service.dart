import 'package:dio/dio.dart';
import 'package:nylo_support/networking/src/ny_api_service.dart';
import '/laravel_notify_fcm.dart';
import '/networking/interceptors/interceptor_fcm_request.dart';
import 'package:nylo_support/helpers/ny_helpers.dart';

/* LaravelFcmApiService
|--------------------------------------------------------------------------
| Define your API endpoints
| Learn more https://nylo.dev/docs/7.x/networking
|-------------------------------------------------------------------------- */

class LaravelFcmApiService extends NyApiService {
  @override
  Map<Type, Interceptor> get interceptors => {
        ...super.interceptors,
        if (getEnv('APP_DEBUG', defaultValue: true) == true)
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
        dynamic data = response.data;
        if (data == null || data is! Map) return false;
        return data.containsKey('status') && data['status'] == 200;
      },
    );
  }
}
