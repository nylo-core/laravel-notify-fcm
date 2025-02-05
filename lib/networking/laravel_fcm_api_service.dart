import 'package:flutter/material.dart';
import 'package:laravel_notify_fcm/laravel_notify_fcm.dart';
import 'package:laravel_notify_fcm/networking/interceptors/interceptor_fcm_request.dart';
import 'package:nylo_support/helpers/helper.dart';
import 'package:nylo_support/networking/ny_api_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/* LaravelFcmApiService
|--------------------------------------------------------------------------
| Define your API endpoints
| Learn more https://nylo.dev/docs/6.x/networking
|-------------------------------------------------------------------------- */

class LaravelFcmApiService extends NyApiService {
  LaravelFcmApiService({BuildContext? buildContext})
      : super(
          buildContext,
          decoders: {},
        );

  @override
  get interceptors => {
        if (getEnv('APP_DEBUG', defaultValue: true) == true)
          PrettyDioLogger: PrettyDioLogger(),
        InterceptorNotifyFCM: InterceptorNotifyFCM(),
      };

  /// Laravel FCM URL
  String get urlLaravel => LaravelNotifyFcm.instance.getUrl();

  /// Get the Sanctum token
  String? get sanctumToken => LaravelNotifyFcm.instance.getSanctumToken();

  /// Create or update device
  Future<bool?> createOrUpdateDevice({bool active = true}) async {
    String? fcmToken = await LaravelNotifyFcm.getFcmToken();
    return await network(
      request: (api) => api.put("/device", data: {
        "is_active": (active == true ? 1 : 0),
        "fcm_token": fcmToken,
      }),
      baseUrl: urlLaravel,
      handleSuccess: (response) {
        dynamic data = response.data;
        if (!(data is Map)) return false;
        return data.containsKey('status') && data['status'] == 200;
      },
    );
  }
}
