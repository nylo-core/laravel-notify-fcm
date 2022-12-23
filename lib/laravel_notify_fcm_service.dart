import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:laravel_notify_fcm/services/apis/laravel_notify_fcm/laravel_notify_fcm_api_service.dart';

class FCMListener {

  FCMListener(this.firebaseMessaging);

  FirebaseMessaging? firebaseMessaging;

  onMessage(Function(RemoteMessage message) onMessage) {
    FirebaseMessaging.onMessage.listen((message) async {
      await onMessage(message);
    });
  }

  onBackgroundMessage(Function(RemoteMessage message) onMessage) {
    FirebaseMessaging.onBackgroundMessage((message) => onMessage(message));
  }
}

class LaravelNotifyFCMService {
  LaravelNotifyFCMService._privateConstructor();

  static final LaravelNotifyFCMService instance = LaravelNotifyFCMService._privateConstructor();

  FCMListener? listen;
  late String siteUrl;
  String? token;
  late ApiService _apiService;

  FirebaseMessaging? _firebaseMessaging;

  init({required siteUrl, required FirebaseMessaging? firebaseMessaging}) {
    this.siteUrl = siteUrl;
    _apiService = ApiService(this.siteUrl);
    _firebaseMessaging = firebaseMessaging;
    listen = FCMListener(firebaseMessaging);
  }

  Future<String?> requestToSendNotifications() async {
    if (Platform.isIOS) {
      await _firebaseMessaging!.requestPermission();
    }
    String? token = await _firebaseMessaging!.getToken();
    this.token = token;
    return token;
  }

  Future<dynamic> sendToken({required String sanctumToken}) async {
    return await _apiService.sendPushToken(sanctumToken: sanctumToken);
  }

  Future<dynamic> updateToken(active, {required String sanctumToken}) async {
    return await _apiService.updatePushToken(active: active, sanctumToken: sanctumToken);
  }

  FirebaseMessaging? getFirebase() {
    return _firebaseMessaging;
  }
}