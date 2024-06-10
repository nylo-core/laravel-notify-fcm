import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:laravel_notify_fcm/laravel_notify_fcm.dart';

class InterceptorNotifyFCM extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Map<String, dynamic> deviceMeta =
        LaravelNotifyFcm.instance.getDeviceMetaJson();

    options.headers.addAll({
      "X-DMETA": jsonEncode({
        "uuid": deviceMeta['uuid'],
        "model": deviceMeta['model'],
        "display_name": deviceMeta['name'],
        "platform": deviceMeta['platform_type'],
        "version": deviceMeta['version'],
      })
    });

    String? sanctumToken = LaravelNotifyFcm.instance.getSanctumToken();
    if (sanctumToken != null) {
      options.headers.addAll({"Authorization": "Bearer $sanctumToken"});
    }
    return handler.next(options);
  }
}
