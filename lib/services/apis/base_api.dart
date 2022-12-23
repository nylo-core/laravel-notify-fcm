//  StoreMob
//
//  Created by Anthony Gordon.
//  2020, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:dio/dio.dart';
import 'package:laravel_notify_fcm/interceptor_fcm_request.dart';

/// Base class for handling API networking
abstract class BaseApi {
  late Dio client;
  bool debugMode;

  BaseApi({this.debugMode = false}) {
    client = new Dio(this._getOptions());

    client.interceptors
        .add(InterceptorNotifyFCM());
  }

  BaseOptions _getOptions() {
    return BaseOptions(
      connectTimeout: 10000,
      receiveTimeout: 7000,
    );
  }
}
