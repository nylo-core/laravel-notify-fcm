## [3.1.1] - 2026-05-23

### Changed
- Bumped `nylo_support` to ^7.26.1.

## [3.1.0] - 2026-05-23

### Added
- `syncDeviceMeta()` static method to push the latest device metadata (uuid, model, display name, platform, version) to Laravel via `PATCH /device/meta`.
- `syncDeviceMeta` named parameter on `storeFcmDevice()` to optionally sync device meta after the device is stored.
- `updateDeviceMeta()` method on `LaravelFcmApiService` backing the new endpoint.
- `lint: ^2.8.0` dev dependency and root `analysis_options.yaml`.

### Changed
- `init()` is now idempotent — subsequent calls are no-ops instead of overwriting state.
- `storeFcmDevice()` return type tightened from `Future<bool?>` to `Future<bool>`.
- `apiServiceFcm()` is now generic (`apiServiceFcm<T>`) and takes a strongly-typed `Future<T> Function(LaravelFcmApiService)` callback.
- Bumped `nylo_support` to ^7.26.0, `device_meta` to ^3.0.2, `dio` to ^5.9.2, `mockito` to ^5.7.0.

## [3.0.0] - 2026-02-06

### Added
- `LaravelNotifyFcmNotInitializedException` custom exception for clearer error handling when the package is not initialized.
- New test suite with unit, integration, API service, and interceptor tests.
- Proper type annotations on `apiServiceFcm` return type and interceptors getter.

### Changed
- **BREAKING**: `init()` no longer requires a `firebaseMessaging` parameter. The package no longer manages `FirebaseMessaging` internally -- consumers must manage Firebase directly.
- **BREAKING**: `storeFcmDevice()` now requires `fcmToken` as a positional parameter and returns `Future<bool?>` instead of `Future<NotificationSettings?>`.
- **BREAKING**: `enableFcmDevice()` and `disableFcmDevice()` now require `fcmToken` as a positional parameter and `sanctumToken` as a named parameter.
- **BREAKING**: Sanctum token is now passed per-call instead of being stored as instance state. Removed `getSanctumToken()` and `setSanctumToken()` methods.
- Authentication header (`Authorization: Bearer`) is now set at the API request level instead of via the interceptor.
- Interceptor now gracefully handles uninitialized state instead of throwing.
- Upgraded `nylo_support` to ^7.0.0, `device_meta` to ^3.0.0, `dio` to ^5.9.0.

### Removed
- **BREAKING**: `firebase_messaging` direct dependency. Consumers must add `firebase_messaging` to their own `pubspec.yaml` and pass the FCM token to this package.
- **BREAKING**: `getFirebaseMessaging()` method.
- **BREAKING**: `getFcmToken()` static method.
- **BREAKING**: `getSanctumToken()` and `setSanctumToken()` methods.
- CLI scaffolding system (`bin/main.dart`, `lib/cli_dialog/`, `lib/stubs/`, `lib/slate_laravel_notify_fcm.dart`, `lib/models/`).
- `pretty_dio_logger` dependency.

## [2.1.5] - 2025-12-17

* Add extra check to `getFcmToken` method to ensure token is not null
* pubspec.yaml update

## [2.1.4] - 2025-12-13

* pubspec.yaml update

## [2.1.3] - 2025-05-23

* pubspec.yaml update

## [2.1.2] - 2025-03-28

* Small tweak to `EnableNotificationsPage`

## [2.1.1] - 2025-03-27

* pubspec.yaml update

## [2.1.0] - 2025-02-05

* Add the ability to scaffold Notifications in your Nylo app
* Run `dart run laravel_notify_fcm:main install` to scaffold the necessary files for FCM notifications
* pubspec.yaml update
* Update Readme

## [2.0.0] - 2025-01-12

* Small Refactor
* Update Readme
* pubspec.yaml update.

## [1.0.2] - 2024-07-08

* pubspec.yaml update.

## [1.0.1] - 2024-06-15

* pubspec.yaml update.

## [1.0.0] - 2024-06-10

* Update README.md
* Fix bug with API Service and request headers.

## [0.0.4] - 2024-06-09

* Update README.md.
* pubspec.yaml update.

## [0.0.3] - 2024-06-08

* Update README.md.
* pubspec.yaml update.

## [0.0.2] - 2024-06-07

* Add example, update service.

## [0.0.1] - 2024-06-07

* Initial release.
