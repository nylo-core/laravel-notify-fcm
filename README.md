# Laravel Notify Fcm

<p align="center">
  <a href="https://github.com/nylo-core/laravel-notify-fcm/releases/latest"><img src="https://img.shields.io/github/v/release/nylo-core/laravel-notify-fcm?style=plastic" alt="Latest Release Version"></a>
  <a href="https://github.com/nylo-core/laravel-notify-fcm/releases/latest"><img src="https://img.shields.io/github/license/nylo-core/laravel-notify-fcm?style=plastic" alt="Latest Stable Version"></a>
  <a href="https://github.com/nylo-core/laravel-notify-fcm"><img alt="GitHub stars" src="https://img.shields.io/github/stars/nylo-core/laravel-notify-fcm?style=plastic"></a>
</p>

Laravel Notify Fcm is a package for sending notifications to your Flutter app using Laravel FCM.

## Getting started

### Installation

Add the following to your `pubspec.yaml` file:

``` yaml
dependencies:
  laravel_notify_fcm: ^3.2.0
```

or with Dart:

``` bash
dart pub add laravel_notify_fcm
```

### Requirements

- [Laravel](https://laravel.com/)
- [Laravel Sanctum](https://laravel.com/docs/11.x/sanctum)
- [laravel-fcm-channel](https://github.com/nylo-core/laravel-fcm-channel)

### Usage

``` dart
import 'package:laravel_notify_fcm/laravel_notify_fcm.dart';
```

### Adding a device to the database

First, call `init` to initialize the package.

Parameters:
- `url` - The URL to your Laravel app where the package will send the device token.
- `debugMode` - Whether to enable debug mode. The default is `false`.

```dart
await LaravelNotifyFcm.instance.init(
  url: 'https://example.com/api/fcm',
);
```

Then, call `storeFcmDevice` to register the device with your Laravel backend.

Parameters:
- `fcmToken` - The FCM token from `FirebaseMessaging.instance.getToken()`.
- `sanctumToken` - A valid Laravel Sanctum token for the authenticated user.

``` dart
String? fcmToken = await FirebaseMessaging.instance.getToken();

await LaravelNotifyFcm.storeFcmDevice(
  fcmToken,
  sanctumToken: 'from your Laravel user',
);
```

This will send the device token and metadata to your Laravel backend via a PUT `/device` request.

View our [docs](https://github.com/nylo-core/laravel-fcm-channel) on Laravel FCM Channel to start sending notifications.

Try the [example](/example) app to see how it works.

### Accessing device metadata

After `init`, you can read the current device metadata either as a typed object or as a JSON map.

``` dart
// Typed DeviceMeta object — direct field access
DeviceMeta meta = LaravelNotifyFcm.instance.getDeviceMeta();
print(meta.uuid);
print(meta.model);

// Or as a plain Map<String, dynamic>
Map<String, dynamic> metaJson = LaravelNotifyFcm.instance.getDeviceMetaJson();
```

Both throw `LaravelNotifyFcmNotInitializedException` if called before `init`.

## Changelog
Please see [CHANGELOG](https://github.com/nylo-core/laravel-notify-fcm/blob/master/CHANGELOG.md) for more information what has changed recently.

## Social
* [Twitter](https://twitter.com/nylo_dev)

## Licence

The MIT License (MIT). Please view the [License](https://github.com/nylo-core/laravel-notify-fcm/blob/main/LICENSE) File for more information.
