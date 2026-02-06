import 'package:flutter_test/flutter_test.dart';
import 'package:laravel_notify_fcm/exceptions/laravel_notify_fcm_exception.dart';

// Note: Tests that require the main LaravelNotifyFcm class are commented out
// due to dependency issues with device_meta/nylo_support path overrides.
// Uncomment when the dependency_overrides are resolved.
//
// import 'package:laravel_notify_fcm/laravel_notify_fcm.dart';

void main() {
  // group('LaravelNotifyFcm singleton', () {
  //   test('instance is not null', () {
  //     expect(LaravelNotifyFcm.instance, isNotNull);
  //   });
  //
  //   test('multiple calls to instance return identical object', () {
  //     final a = LaravelNotifyFcm.instance;
  //     final b = LaravelNotifyFcm.instance;
  //     final c = LaravelNotifyFcm.instance;
  //     expect(identical(a, b), isTrue);
  //     expect(identical(b, c), isTrue);
  //     expect(identical(a, c), isTrue);
  //   });
  //
  //   test('instance hashCode is consistent', () {
  //     final a = LaravelNotifyFcm.instance;
  //     final b = LaravelNotifyFcm.instance;
  //     expect(a.hashCode, equals(b.hashCode));
  //   });
  // });
  //
  // group('LaravelNotifyFcm.version', () {
  //   test('returns non-empty string', () {
  //     expect(LaravelNotifyFcm.version, isNotEmpty);
  //   });
  //
  //   test('follows semantic versioning format', () {
  //     final version = LaravelNotifyFcm.version;
  //     final semverPattern = RegExp(r'^\d+\.\d+\.\d+(-[a-zA-Z0-9.]+)?$');
  //     expect(semverPattern.hasMatch(version), isTrue,
  //         reason: 'Version "$version" should follow semver format');
  //   });
  //
  //   test('major version is at least 1', () {
  //     final version = LaravelNotifyFcm.version;
  //     final majorVersion = int.parse(version.split('.')[0]);
  //     expect(majorVersion, greaterThanOrEqualTo(1));
  //   });
  //
  //   test('version is 3.0.0', () {
  //     expect(LaravelNotifyFcm.version, equals('3.0.0'));
  //   });
  // });
  //
  // group('LaravelNotifyFcm.debugEnabled', () {
  //   test('returns bool', () {
  //     expect(LaravelNotifyFcm.instance.debugEnabled(), isA<bool>());
  //   });
  //
  //   test('defaults to false', () {
  //     expect(LaravelNotifyFcm.instance.debugEnabled(), isFalse);
  //   });
  // });
  //
  // group('LaravelNotifyFcm.apiService', () {
  //   test('is accessible without initialization', () {
  //     expect(LaravelNotifyFcm.instance.apiService, isNotNull);
  //   });
  //
  //   test('returns same instance on multiple accesses', () {
  //     final a = LaravelNotifyFcm.instance.apiService;
  //     final b = LaravelNotifyFcm.instance.apiService;
  //     expect(identical(a, b), isTrue);
  //   });
  // });
  //
  // group('LaravelNotifyFcm.getUrl uninitialized', () {
  //   test('throws LaravelNotifyFcmNotInitializedException', () {
  //     expect(
  //       () => LaravelNotifyFcm.instance.getUrl(),
  //       throwsA(isA<LaravelNotifyFcmNotInitializedException>()),
  //     );
  //   });
  //
  //   test('exception message mentions URL is null', () {
  //     try {
  //       LaravelNotifyFcm.instance.getUrl();
  //       fail('Expected exception to be thrown');
  //     } on LaravelNotifyFcmNotInitializedException catch (e) {
  //       expect(e.message, contains('URL is null'));
  //     }
  //   });
  //
  //   test('exception message mentions init method', () {
  //     try {
  //       LaravelNotifyFcm.instance.getUrl();
  //       fail('Expected exception to be thrown');
  //     } on LaravelNotifyFcmNotInitializedException catch (e) {
  //       expect(e.message, contains('init()'));
  //     }
  //   });
  // });
  //
  // group('LaravelNotifyFcm.getDeviceMetaJson uninitialized', () {
  //   test('throws LaravelNotifyFcmNotInitializedException', () {
  //     expect(
  //       () => LaravelNotifyFcm.instance.getDeviceMetaJson(),
  //       throwsA(isA<LaravelNotifyFcmNotInitializedException>()),
  //     );
  //   });
  //
  //   test('exception message mentions DeviceMeta is null', () {
  //     try {
  //       LaravelNotifyFcm.instance.getDeviceMetaJson();
  //       fail('Expected exception to be thrown');
  //     } on LaravelNotifyFcmNotInitializedException catch (e) {
  //       expect(e.message, contains('DeviceMeta instance is null'));
  //     }
  //   });
  //
  //   test('exception message mentions init method', () {
  //     try {
  //       LaravelNotifyFcm.instance.getDeviceMetaJson();
  //       fail('Expected exception to be thrown');
  //     } on LaravelNotifyFcmNotInitializedException catch (e) {
  //       expect(e.message, contains('init()'));
  //     }
  //   });
  // });
  //
  // group('LaravelNotifyFcm.apiServiceFcm', () {
  //   test('executes callback', () async {
  //     var executed = false;
  //     await LaravelNotifyFcm.apiServiceFcm((api) {
  //       executed = true;
  //     });
  //     expect(executed, isTrue);
  //   });
  //
  //   test('provides api service to callback', () async {
  //     await LaravelNotifyFcm.apiServiceFcm((api) {
  //       expect(api, isNotNull);
  //       expect(api, equals(LaravelNotifyFcm.instance.apiService));
  //     });
  //   });
  //
  //   test('returns value from callback', () async {
  //     final result = await LaravelNotifyFcm.apiServiceFcm((api) => 42);
  //     expect(result, equals(42));
  //   });
  //
  //   test('returns string from callback', () async {
  //     final result = await LaravelNotifyFcm.apiServiceFcm((api) => 'hello');
  //     expect(result, equals('hello'));
  //   });
  //
  //   test('returns null from callback', () async {
  //     final result = await LaravelNotifyFcm.apiServiceFcm((api) => null);
  //     expect(result, isNull);
  //   });
  //
  //   test('returns list from callback', () async {
  //     final result = await LaravelNotifyFcm.apiServiceFcm((api) => [1, 2, 3]);
  //     expect(result, equals([1, 2, 3]));
  //   });
  //
  //   test('returns map from callback', () async {
  //     final result = await LaravelNotifyFcm.apiServiceFcm((api) => {'key': 'value'});
  //     expect(result, equals({'key': 'value'}));
  //   });
  //
  //   test('propagates exceptions from callback', () async {
  //     expect(
  //       () async => await LaravelNotifyFcm.apiServiceFcm((api) {
  //         throw Exception('Test error');
  //       }),
  //       throwsA(isA<Exception>()),
  //     );
  //   });
  //
  //   test('handles async callback', () async {
  //     final result = await LaravelNotifyFcm.apiServiceFcm((api) async {
  //       await Future.delayed(const Duration(milliseconds: 10));
  //       return 'async result';
  //     });
  //     expect(result, equals('async result'));
  //   });
  // });
  //
  // group('LaravelNotifyFcm static methods', () {
  //   group('storeFcmDevice', () {
  //     test('is a static method', () {
  //       expect(LaravelNotifyFcm.storeFcmDevice, isA<Function>());
  //     });
  //
  //     test('returns Future<bool?>', () async {
  //       try {
  //         final result = LaravelNotifyFcm.storeFcmDevice(
  //           'token',
  //           sanctumToken: 'auth',
  //         );
  //         expect(result, isA<Future<bool?>>());
  //       } catch (_) {
  //         // Expected to throw
  //       }
  //     });
  //   });
  //
  //   group('enableFcmDevice', () {
  //     test('is a static method', () {
  //       expect(LaravelNotifyFcm.enableFcmDevice, isA<Function>());
  //     });
  //
  //     test('returns Future<bool>', () async {
  //       try {
  //         final result = LaravelNotifyFcm.enableFcmDevice(
  //           'token',
  //           sanctumToken: 'auth',
  //         );
  //         expect(result, isA<Future<bool>>());
  //       } catch (_) {
  //         // Expected to throw
  //       }
  //     });
  //   });
  //
  //   group('disableFcmDevice', () {
  //     test('is a static method', () {
  //       expect(LaravelNotifyFcm.disableFcmDevice, isA<Function>());
  //     });
  //
  //     test('returns Future<bool>', () async {
  //       try {
  //         final result = LaravelNotifyFcm.disableFcmDevice(
  //           'token',
  //           sanctumToken: 'auth',
  //         );
  //         expect(result, isA<Future<bool>>());
  //       } catch (_) {
  //         // Expected to throw
  //       }
  //     });
  //   });
  // });

  group('LaravelNotifyFcmNotInitializedException', () {
    test('can be instantiated with message', () {
      final exception =
          LaravelNotifyFcmNotInitializedException('Custom message');

      expect(exception, isNotNull);
    });

    test('stores message correctly', () {
      const message = 'Test error message';
      final exception = LaravelNotifyFcmNotInitializedException(message);

      expect(exception.message, equals(message));
    });

    test('toString includes class name', () {
      final exception = LaravelNotifyFcmNotInitializedException('Test');

      expect(exception.toString(),
          contains('LaravelNotifyFcmNotInitializedException'));
    });

    test('toString includes message', () {
      const message = 'Specific error occurred';
      final exception = LaravelNotifyFcmNotInitializedException(message);

      expect(exception.toString(), contains(message));
    });

    test('toString format is consistent', () {
      const message = 'Error message';
      final exception = LaravelNotifyFcmNotInitializedException(message);

      expect(
        exception.toString(),
        equals('LaravelNotifyFcmNotInitializedException: $message'),
      );
    });

    test('implements Exception', () {
      final exception = LaravelNotifyFcmNotInitializedException('Test');

      expect(exception, isA<Exception>());
    });

    test('can be caught as Exception', () {
      var caught = false;

      try {
        throw LaravelNotifyFcmNotInitializedException('Test');
      } on Exception {
        caught = true;
      }

      expect(caught, isTrue);
    });

    test('can be caught specifically', () {
      var caught = false;

      try {
        throw LaravelNotifyFcmNotInitializedException('Test');
      } on LaravelNotifyFcmNotInitializedException {
        caught = true;
      }

      expect(caught, isTrue);
    });

    test('handles empty message', () {
      final exception = LaravelNotifyFcmNotInitializedException('');

      expect(exception.message, isEmpty);
      expect(exception.toString(),
          equals('LaravelNotifyFcmNotInitializedException: '));
    });

    test('handles message with special characters', () {
      const message = 'Error: "test" with \'quotes\' and \$pecial chars!';
      final exception = LaravelNotifyFcmNotInitializedException(message);

      expect(exception.message, equals(message));
    });

    test('handles multiline message', () {
      const message = 'Line 1\nLine 2\nLine 3';
      final exception = LaravelNotifyFcmNotInitializedException(message);

      expect(exception.message, equals(message));
    });
  });
}
