import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:laravel_notify_fcm/laravel_notify_fcm.dart';

class InterceptorNotifyFCM extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final DeviceMeta deviceMeta = LaravelNotifyFcm.instance.getDeviceMeta();

      options.headers.addAll({
        "X-DMETA": jsonEncode({
          "uuid": deviceMeta.uuid,
          "model": deviceMeta.model,
          "display_name": deviceMeta.name,
          "platform": deviceMeta.platformType,
          "version": deviceMeta.version,
        })
      });
    } on LaravelNotifyFcmNotInitializedException {
      // Skip adding device meta if not initialized
    }

    return handler.next(options);
  }
}
