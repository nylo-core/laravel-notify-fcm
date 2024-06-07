# Laravel Notify Fcm

<p align="center">
  <a href="https://github.com/nylo-core/laravel-notify-fcm/releases/latest"><img src="https://img.shields.io/github/v/release/nylo-core/laravel-notify-fcm?style=plastic" alt="Latest Release Version"></a>
  <a href="https://github.com/nylo-core/laravel-notify-fcm/releases/latest"><img src="https://img.shields.io/github/license/nylo-core/laravel-notify-fcm?style=plastic" alt="Latest Stable Version"></a>
  <a href="https://github.com/nylo-core/laravel-notify-fcm"><img alt="GitHub stars" src="https://img.shields.io/github/stars/nylo-core/laravel-notify-fcm?style=plastic"></a>
</p>

Laravel Notify Fcm if package for sending notifications to your Flutter app using Laravel FCM.

## Getting started

### Installation

Add the following to your `pubspec.yaml` file:

``` yaml
dependencies:
  laravel_notify_fcm: ^0.0.2
```

or with Dart:

``` bash
dart pub add laravel_notify_fcm
```

### Requirements

## Installation

First, install the package via composer:

``` bash
composer require nylo/laravel-fcm-channel
```

The package will automatically register itself.

## Configuration

Run the `install` command.

```bash
php artisan laravelfcm:install
```
This will add a (`laravelfcm.php`) config file

ServiceProvider to your app.php: `App\Providers\FcmAppServiceProvider::class`

Then, ask if you want to run the migrations.

Here's the tables it will migrate:
* fcm_devices

Add your Google Service Account to `firebase_service_account_json`.

```php
<?php

return '{
    "type": "service_account",
    "project_id": "123456789-me908",
    "private_key_id": "123456789",
    "private_key": "-----BEGIN PRIVATE KEY-----\123456789\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-9p9z7@123456789-me908.iam.gserviceaccount.com",
    "client_id": "123456789",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-9p9z7%123456789-me908.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  }';
```

You can download your Google Service Account in your Firebase Project Settings > Service Accounts > Manage service account permissions > "Actions (three dots) - Manage keys" > Add Key > Create New Key.

Then, paste the JSON into the `firebase_service_account_json` file like in the above example.
> **Note:** It's best to keep the key values in a `.env` file. Don't commit the JSON file to your repository.

You can fully configure this package in the `config/laravelfcm.php` file (this file should be added after you run `php artisan laravelfcm:install`).

### Usage

``` dart
import 'package:laravel_notify_fcm/laravel_notify_fcm.dart';

```

### Adding a device to the database

First, call `init` to initialize the package.

Parameters:
- `url` - The URL to your Laravel app where the package will send the device token.
- `firebaseMessaging` - The FirebaseMessaging instance.
- `debugMode` - Whether to enable debug mode. Default is `false`.

```dart
FirebaseMessaging firebaseMessaging = FirebaseMessaging();

await LaravelNotifyFcm.instance.init(
  url: 'https://example.com/api/fcm/devices',
  firebaseMessaging: firebaseMessaging,
);
```

Then, call `storeFcmDevice` to add the device to the database.

``` dart

await LaravelNotifyFcm.instance.storeFcmDevice(
  sanctumToken: 'from your laravel user',
);
```

This method will request permission to send notifications to the device. If the user accepts, the device will be added to the database.

Try the [example](/example) app to see how it works.

## Changelog
Please see [CHANGELOG](https://github.com/nylo-core/laravel-notify-fcm/blob/master/CHANGELOG.md) for more information what has changed recently.

## Social
* [Twitter](https://twitter.com/nylo_dev)

## Licence

The MIT License (MIT). Please view the [License](https://github.com/nylo-core/laravel-notify-fcm/blob/main/LICENSE) File for more information.
