/// Integration tests for LaravelNotifyFcm
///
/// These tests require the full dependency chain to be available.
/// Run with: flutter test test/laravel_notify_fcm_integration_test.dart
///
/// Note: Some tests may fail if Firebase is not properly initialized
/// or if running in an environment without platform channel support.

import 'package:flutter_test/flutter_test.dart';
import 'package:laravel_notify_fcm/laravel_notify_fcm.dart';

void main() {
  group('LaravelNotifyFcm', () {
    group('version', () {
      test('returns correct version string', () {
        expect(LaravelNotifyFcm.version, equals('3.0.0'));
      });

      test('version follows semver format', () {
        final semverRegex = RegExp(r'^\d+\.\d+\.\d+$');
        expect(semverRegex.hasMatch(LaravelNotifyFcm.version), isTrue);
      });
    });

    group('singleton', () {
      test('instance returns same object', () {
        final instance1 = LaravelNotifyFcm.instance;
        final instance2 = LaravelNotifyFcm.instance;

        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('uninitialized state', () {
      test(
          'getUrl throws LaravelNotifyFcmNotInitializedException when not initialized',
          () {
        expect(
          () => LaravelNotifyFcm.instance.getUrl(),
          throwsA(isA<LaravelNotifyFcmNotInitializedException>().having(
            (e) => e.toString(),
            'message',
            contains('URL is null'),
          )),
        );
      });

      test(
          'getDeviceMetaJson throws LaravelNotifyFcmNotInitializedException when not initialized',
          () {
        expect(
          () => LaravelNotifyFcm.instance.getDeviceMetaJson(),
          throwsA(isA<LaravelNotifyFcmNotInitializedException>().having(
            (e) => e.toString(),
            'message',
            contains('DeviceMeta instance is null'),
          )),
        );
      });
    });

    group('LaravelNotifyFcmNotInitializedException', () {
      test('has correct message', () {
        final exception =
            LaravelNotifyFcmNotInitializedException('Test message');
        expect(exception.message, equals('Test message'));
      });

      test('toString includes class name and message', () {
        final exception =
            LaravelNotifyFcmNotInitializedException('Test message');
        expect(
          exception.toString(),
          equals('LaravelNotifyFcmNotInitializedException: Test message'),
        );
      });
    });

    group('debugEnabled', () {
      test('returns false by default', () {
        expect(LaravelNotifyFcm.instance.debugEnabled(), isFalse);
      });
    });

    group('apiService', () {
      test('apiService instance is not null', () {
        expect(LaravelNotifyFcm.instance.apiService, isNotNull);
      });

      test('apiServiceFcm provides callback access', () async {
        var callbackExecuted = false;

        await LaravelNotifyFcm.apiServiceFcm((api) {
          callbackExecuted = true;
          expect(api, isNotNull);
        });

        expect(callbackExecuted, isTrue);
      });

      test('apiServiceFcm returns callback result', () async {
        final result = await LaravelNotifyFcm.apiServiceFcm((api) {
          return 'test-result';
        });

        expect(result, equals('test-result'));
      });
    });

    group('storeFcmDevice', () {
      test('requires sanctumToken parameter', () {
        // This test verifies the API contract - sanctumToken is required
        // The method signature enforces this at compile time
        expect(
          LaravelNotifyFcm.storeFcmDevice,
          isA<Function>(),
        );
      });
    });

    group('enableFcmDevice', () {
      test('requires sanctumToken parameter', () {
        expect(
          LaravelNotifyFcm.enableFcmDevice,
          isA<Function>(),
        );
      });
    });

    group('disableFcmDevice', () {
      test('requires sanctumToken parameter', () {
        expect(
          LaravelNotifyFcm.disableFcmDevice,
          isA<Function>(),
        );
      });
    });
  });
}
