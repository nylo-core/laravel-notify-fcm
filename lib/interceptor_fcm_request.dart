import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:laravel_notify_fcm/helpers/tools.dart';
import 'package:uuid/uuid.dart';

class InterceptorNotifyFCM extends InterceptorsWrapper {

  InterceptorNotifyFCM();

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll(await this._xMetaData());
    return handler.next(options);
  }

  Future<Map<String, dynamic>> _xMetaData() async {
    Map<String, dynamic> headers = {};
    Map<String, String?> userDeviceMeta = await this._getUserMeta();
    headers.addAll({"X-DMETA": jsonEncode(userDeviceMeta)});
    return headers;
  }

  Future<Map<String, String?>> _getUserMeta() async {
    String uuid = await _getUUID();

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    Map<String, String?> data = {
      "uuid": uuid,
    };
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidMeta = await deviceInfo.androidInfo;
      data.addAll({
        "model": androidMeta.product.toString(),
        "display_name":
        androidMeta.brand!.replaceAll(new RegExp('[^\u0001-\u007F]'), '_'),
        "platform": "android",
        "version": androidMeta.version.release,
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosMeta = await deviceInfo.iosInfo;
      data.addAll({
        "model": iosMeta.model,
        "display_name": iosMeta.name!.replaceAll(new RegExp('[^\u0001-\u007F]'), '_'),
        "platform": "ios",
        "version": iosMeta.systemVersion.toString(),
      });
    }
    return data;
  }

  Future<String> _getUUID() async {
    String? uuid = await getStorage(key: 'fcm_app_uuid');
    if (uuid == null) {
      var newUUID = new Uuid();
      uuid = newUUID.v1();
      await storeStorage(uuid, key: 'fcm_app_uuid');
    }
    return uuid;
  }
}