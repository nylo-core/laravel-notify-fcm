import 'package:dio/dio.dart';
import 'package:laravel_notify_fcm/laravel_notify_fcm.dart';

class InterceptorNotifyFCM extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers
        .addAll({"X-DMETA": LaravelNotifyFcm.instance.getDeviceMetaJson()});
    return handler.next(options);
  }
}
