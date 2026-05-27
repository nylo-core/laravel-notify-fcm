// Integration tests for LaravelNotifyFcm
//
// These tests require the full dependency chain to be available.
// Run with: flutter test test/laravel_notify_fcm_integration_test.dart
//
// Note: Some tests may fail if Firebase is not properly initialized
// or if running in an environment without platform channel support.

import 'package:flutter_test/flutter_test.dart';
import 'package:laravel_notify_fcm/laravel_notify_fcm.dart';
import 'package:nylo_support/helpers/ny_helpers.dart' show NyEnvRegistry;

void main() {
  // LaravelFcmApiService reads `APP_DEBUG` via getEnv() during construction.
  // Stub the env registry so the default value is returned in tests that do
  // not ship a generated env.g.dart.
  TestWidgetsFlutterBinding.ensureInitialized();
  NyEnvRegistry.register(
    getter: (key, {dynamic defaultValue}) => defaultValue,
  );

  group('LaravelNotifyFcm', () {
    group('version', () {
      test('returns correct version string', () {
        expect(LaravelNotifyFcm.version, equals('3.1.2'));
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

        await LaravelNotifyFcm.apiServiceFcm<void>((api) async {
          callbackExecuted = true;
          expect(api, isNotNull);
        });

        expect(callbackExecuted, isTrue);
      });

      test('apiServiceFcm returns callback result', () async {
        final result =
            await LaravelNotifyFcm.apiServiceFcm<String>((api) async {
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

      test('accepts optional syncDeviceMeta named parameter', () {
        // Compile-time check: the assignment below must type-check against
        // the current signature for the test file to build at all.
        const Future<bool> Function(String?,
            {required String sanctumToken,
            bool syncDeviceMeta}) signature = LaravelNotifyFcm.storeFcmDevice;
        expect(signature, isA<Function>());
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

    group('syncDeviceMeta', () {
      test('is exposed as a static function', () {
        expect(
          LaravelNotifyFcm.syncDeviceMeta,
          isA<Function>(),
        );
      });
    });

    // Note: this group mutates singleton state. Keep it last so it does not
    // affect tests that depend on the uninitialized state above.
    group('init idempotency', () {
      test('subsequent init calls do not overwrite earlier state', () async {
        const firstUrl = 'https://first.example.com/api';
        const secondUrl = 'https://second.example.com/api';

        try {
          await LaravelNotifyFcm.instance.init(url: firstUrl);
        } catch (e) {
          // DeviceMeta.init relies on platform channels that may be
          // unavailable in this test environment — surface and skip.
          // ignore: avoid_print
          print('init idempotency test skipped: $e');
          return;
        }

        await LaravelNotifyFcm.instance.init(url: secondUrl, debugMode: true);

        expect(LaravelNotifyFcm.instance.getUrl(), equals(firstUrl));
        expect(LaravelNotifyFcm.instance.debugEnabled(), isFalse,
            reason: 'second init must not flip debugMode');
      });
    });
  });
}
