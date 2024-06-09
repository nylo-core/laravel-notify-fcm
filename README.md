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
  laravel_notify_fcm: ^0.0.4
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
- `firebaseMessaging` - The FirebaseMessaging instance.
- `debugMode` - Whether to enable debug mode. The default is `false`.

```dart
FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

await LaravelNotifyFcm.instance.init(
  url: 'https://example.com/api/fcm/devices',
  firebaseMessaging: firebaseMessaging,
);
```

Then, call `storeFcmDevice` to add the device to the database.

``` dart

await LaravelNotifyFcm.instance.storeFcmDevice(
  sanctumToken: 'from your Laravel user',
);
```

This method will request permission to send notifications to the device. If the user accepts, the device will be added to the database.

View our [docs](https://github.com/nylo-core/laravel-fcm-channel) on Laravel FCM Channel to start sending notifications.

Try the [example](/example) app to see how it works.

## Changelog
Please see [CHANGELOG](https://github.com/nylo-core/laravel-notify-fcm/blob/master/CHANGELOG.md) for more information what has changed recently.

## Social
* [Twitter](https://twitter.com/nylo_dev)

## Licence

The MIT License (MIT). Please view the [License](https://github.com/nylo-core/laravel-notify-fcm/blob/main/LICENSE) File for more information.
