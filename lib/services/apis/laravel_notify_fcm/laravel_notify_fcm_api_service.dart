//  StoreMob
//
//  Created by Anthony Gordon.
//  2020, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:dio/dio.dart';
import 'package:laravel_notify_fcm/laravel_notify_fcm_service.dart';
import 'package:laravel_notify_fcm/services/apis/base_api.dart';

class ApiService extends BaseApi {

  ApiService(String siteUrl) {
   this.client.options.baseUrl = siteUrl + "/api/fcm";
  }

  Future<dynamic> updatePushToken({required String sanctumToken, required bool active}) async {
    try {
      this.client.options.headers.addAll({"Authorization": "Bearer $sanctumToken"});
      Response response = await this.client.put("/device", data: {"is_active": (active == true ? 1 : 0)});
      return response.data;
    } on Exception catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<dynamic> sendPushToken({required String sanctumToken}) async {
    try {
      this.client.options.headers.addAll({"Authorization": "Bearer $sanctumToken"});
      String? token = LaravelNotifyFCMService.instance.token;
      Response response = await this.client.put("/device", data: {"push_token": token});
      return response.data;
    } on Exception catch (e) {
      print(e.toString());
    }
    return null;
  }
}
