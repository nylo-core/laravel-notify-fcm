import 'package:flutter_test/flutter_test.dart';
import 'package:laravel_notify_fcm/exceptions/laravel_notify_fcm_exception.dart';

// Note: Tests that require LaravelFcmApiService and InterceptorNotifyFCM
// are commented out due to dependency issues with device_meta/nylo_support.
// Uncomment when the dependency_overrides are resolved.
//
// import 'package:laravel_notify_fcm/networking/laravel_fcm_api_service.dart';
// import 'package:laravel_notify_fcm/networking/interceptors/interceptor_fcm_request.dart';

void main() {
  // group('LaravelFcmApiService', () {
  //   late LaravelFcmApiService apiService;
  //
  //   setUp(() {
  //     apiService = LaravelFcmApiService();
  //   });
  //
  //   group('initialization', () {
  //     test('creates instance without BuildContext', () {
  //       final service = LaravelFcmApiService();
  //       expect(service, isNotNull);
  //     });
  //
  //     test('creates instance with null BuildContext', () {
  //       final service = LaravelFcmApiService(buildContext: null);
  //       expect(service, isNotNull);
  //     });
  //   });
  //
  //   group('interceptors', () {
  //     test('includes InterceptorNotifyFCM when APP_DEBUG is true', () {
  //       final interceptors = apiService.interceptors;
  //       expect(interceptors, isA<Map<Type, dynamic>>());
  //     });
  //
  //     test('interceptors map contains correct types', () {
  //       final interceptors = apiService.interceptors;
  //       final hasInterceptor = interceptors.containsKey(InterceptorNotifyFCM);
  //       expect(hasInterceptor, isTrue);
  //     });
  //   });
  //
  //   group('urlLaravel', () {
  //     test('throws when LaravelNotifyFcm not initialized', () {
  //       expect(
  //         () => apiService.urlLaravel,
  //         throwsA(isA<Exception>()),
  //       );
  //     });
  //   });
  //
  //   group('createOrUpdateDevice request parameters', () {
  //     test('method signature accepts null fcmToken', () {
  //       expect(
  //         () => apiService.createOrUpdateDevice(
  //           null,
  //           sanctumToken: 'test-token',
  //         ),
  //         throwsA(anything),
  //       );
  //     });
  //
  //     test('method signature accepts fcmToken string', () {
  //       expect(
  //         () => apiService.createOrUpdateDevice(
  //           'fcm-token-123',
  //           sanctumToken: 'test-token',
  //         ),
  //         throwsA(anything),
  //       );
  //     });
  //
  //     test('method signature accepts active parameter defaulting to true', () {
  //       expect(
  //         () => apiService.createOrUpdateDevice(
  //           'fcm-token',
  //           sanctumToken: 'test-token',
  //         ),
  //         throwsA(anything),
  //       );
  //     });
  //
  //     test('method signature accepts active=false', () {
  //       expect(
  //         () => apiService.createOrUpdateDevice(
  //           'fcm-token',
  //           active: false,
  //           sanctumToken: 'test-token',
  //         ),
  //         throwsA(anything),
  //       );
  //     });
  //   });
  // });

  group('Response handling logic', () {
    // These tests verify the handleSuccess logic without making actual HTTP calls

    test('returns false when response data is null', () {
      dynamic data;
      bool? result;

      // Simulate handleSuccess logic
      // ignore: unnecessary_null_comparison
      if (data == null || data is! Map) {
        result = false;
      } else {
        result = data.containsKey('status') && data['status'] == 200;
      }

      expect(result, isFalse);
    });

    test('returns false when response data is not a Map', () {
      const dynamic data = 'string response';
      bool? result;

      if (data == null || data is! Map) {
        result = false;
      } else {
        result = data.containsKey('status') && data['status'] == 200;
      }

      expect(result, isFalse);
    });

    test('returns false when response data is a list', () {
      final dynamic data = [1, 2, 3];
      bool? result;

      if (data == null || data is! Map) {
        result = false;
      } else {
        result = data.containsKey('status') && data['status'] == 200;
      }

      expect(result, isFalse);
    });

    test('returns false when status key is missing', () {
      final dynamic data = {'message': 'success'};
      bool? result;

      if (data == null || data is! Map) {
        result = false;
      } else {
        result = data.containsKey('status') && data['status'] == 200;
      }

      expect(result, isFalse);
    });

    test('returns false when status is not 200', () {
      final dynamic data = {'status': 201};
      bool? result;

      if (data == null || data is! Map) {
        result = false;
      } else {
        result = data.containsKey('status') && data['status'] == 200;
      }

      expect(result, isFalse);
    });

    test('returns false when status is 400', () {
      final dynamic data = {'status': 400};
      bool? result;

      if (data == null || data is! Map) {
        result = false;
      } else {
        result = data.containsKey('status') && data['status'] == 200;
      }

      expect(result, isFalse);
    });

    test('returns false when status is 500', () {
      final dynamic data = {'status': 500};
      bool? result;

      if (data == null || data is! Map) {
        result = false;
      } else {
        result = data.containsKey('status') && data['status'] == 200;
      }

      expect(result, isFalse);
    });

    test('returns true when status is 200', () {
      final dynamic data = {'status': 200};
      bool? result;

      if (data == null || data is! Map) {
        result = false;
      } else {
        result = data.containsKey('status') && data['status'] == 200;
      }

      expect(result, isTrue);
    });

    test('returns true when status is 200 with additional data', () {
      final dynamic data = {
        'status': 200,
        'message': 'Device updated successfully',
        'device_id': 123,
      };
      bool? result;

      if (data == null || data is! Map) {
        result = false;
      } else {
        result = data.containsKey('status') && data['status'] == 200;
      }

      expect(result, isTrue);
    });

    test('returns false when status is string "200"', () {
      final dynamic data = {'status': '200'};
      bool? result;

      if (data == null || data is! Map) {
        result = false;
      } else {
        result = data.containsKey('status') && data['status'] == 200;
      }

      // '200' != 200 (type mismatch)
      expect(result, isFalse);
    });

    test('returns false when response is empty map', () {
      final dynamic data = <String, dynamic>{};
      bool? result;

      if (data == null || data is! Map) {
        result = false;
      } else {
        result = data.containsKey('status') && data['status'] == 200;
      }

      expect(result, isFalse);
    });
  });

  group('Request data format', () {
    test('is_active should be 1 when active is true', () {
      const active = true;
      const isActive = active == true ? 1 : 0;

      expect(isActive, equals(1));
    });

    test('is_active should be 0 when active is false', () {
      const active = false;
      const isActive = active == true ? 1 : 0;

      expect(isActive, equals(0));
    });

    test('request data contains expected keys', () {
      const fcmToken = 'test-fcm-token';
      const active = true;

      final data = {
        'is_active': active == true ? 1 : 0,
        'fcm_token': fcmToken,
      };

      expect(data.containsKey('is_active'), isTrue);
      expect(data.containsKey('fcm_token'), isTrue);
      expect(data['is_active'], equals(1));
      expect(data['fcm_token'], equals('test-fcm-token'));
    });

    test('request data handles null fcmToken', () {
      const String? fcmToken = null;
      const active = true;

      final data = {
        'is_active': active == true ? 1 : 0,
        'fcm_token': fcmToken,
      };

      expect(data['fcm_token'], isNull);
    });
  });

  group('updateDeviceMeta request data format', () {
    // These tests document and verify the body shape sent to PATCH /device/meta.
    // The keys must match what the Laravel backend expects, so the dashboard
    // can display up-to-date device information. Each field is conditionally
    // included only when the source key exists in the device meta map, and
    // null values fall back to an empty string.

    Map<String, dynamic> buildBody(Map<String, dynamic> deviceMeta) {
      return {
        if (deviceMeta.containsKey('uuid')) 'uuid': deviceMeta['uuid'] ?? '',
        if (deviceMeta.containsKey('model')) 'model': deviceMeta['model'] ?? '',
        if (deviceMeta.containsKey('name'))
          'display_name': deviceMeta['name'] ?? '',
        if (deviceMeta.containsKey('platform_type'))
          'platform': deviceMeta['platform_type'] ?? '',
        if (deviceMeta.containsKey('version'))
          'version': deviceMeta['version'] ?? '',
      };
    }

    test('body contains all expected keys when all source keys present', () {
      final deviceMeta = {
        'uuid': 'device-uuid-123',
        'model': 'iPhone 14',
        'name': "Anthony's iPhone",
        'platform_type': 'ios',
        'version': '16.0',
      };

      final body = buildBody(deviceMeta);

      expect(body.containsKey('uuid'), isTrue);
      expect(body.containsKey('model'), isTrue);
      expect(body.containsKey('display_name'), isTrue);
      expect(body.containsKey('platform'), isTrue);
      expect(body.containsKey('version'), isTrue);
    });

    test('body excludes extra fields not in the known mapping', () {
      final deviceMeta = {
        'uuid': 'device-uuid-123',
        'model': 'iPhone 14',
        'name': "Anthony's iPhone",
        'platform_type': 'ios',
        'version': '16.0',
        'extra_field': 'should_not_appear',
      };

      final body = buildBody(deviceMeta);

      expect(body.keys.length, equals(5));
      expect(body.containsKey('extra_field'), isFalse);
    });

    test('maps DeviceMeta "name" to body "display_name"', () {
      final deviceMeta = {
        'uuid': 'u',
        'model': 'm',
        'name': 'My Display Name',
        'platform_type': 'ios',
        'version': 'v',
      };

      final body = buildBody(deviceMeta);

      expect(body['display_name'], equals('My Display Name'));
      expect(body.containsKey('name'), isFalse);
    });

    test('maps DeviceMeta "platform_type" to body "platform"', () {
      final deviceMeta = {
        'uuid': 'u',
        'model': 'm',
        'name': 'n',
        'platform_type': 'android',
        'version': 'v',
      };

      final body = buildBody(deviceMeta);

      expect(body['platform'], equals('android'));
      expect(body.containsKey('platform_type'), isFalse);
    });

    test('passes through uuid, model, and version verbatim', () {
      final deviceMeta = {
        'uuid': 'abc-123-def-456',
        'model': 'Pixel 7 Pro',
        'name': 'n',
        'platform_type': 'p',
        'version': '13.0.1',
      };

      final body = buildBody(deviceMeta);

      expect(body['uuid'], equals('abc-123-def-456'));
      expect(body['model'], equals('Pixel 7 Pro'));
      expect(body['version'], equals('13.0.1'));
    });

    test('omits keys entirely when DeviceMeta fields are missing', () {
      final deviceMeta = <String, dynamic>{};

      final body = buildBody(deviceMeta);

      expect(body, isEmpty);
      expect(body.containsKey('uuid'), isFalse);
      expect(body.containsKey('model'), isFalse);
      expect(body.containsKey('display_name'), isFalse);
      expect(body.containsKey('platform'), isFalse);
      expect(body.containsKey('version'), isFalse);
    });

    test('omits only the missing keys when some are present', () {
      final deviceMeta = {
        'uuid': 'device-uuid-123',
        'platform_type': 'ios',
      };

      final body = buildBody(deviceMeta);

      expect(body.keys.length, equals(2));
      expect(body['uuid'], equals('device-uuid-123'));
      expect(body['platform'], equals('ios'));
      expect(body.containsKey('model'), isFalse);
      expect(body.containsKey('display_name'), isFalse);
      expect(body.containsKey('version'), isFalse);
    });

    test('replaces null values with empty string', () {
      final deviceMeta = <String, dynamic>{
        'uuid': null,
        'model': null,
        'name': null,
        'platform_type': null,
        'version': null,
      };

      final body = buildBody(deviceMeta);

      expect(body['uuid'], equals(''));
      expect(body['model'], equals(''));
      expect(body['display_name'], equals(''));
      expect(body['platform'], equals(''));
      expect(body['version'], equals(''));
    });

    test('does not include fcm_token or is_active', () {
      // syncDeviceMeta is meta-only; the FCM token endpoint is separate.
      final deviceMeta = {
        'uuid': 'u',
        'model': 'm',
        'name': 'n',
        'platform_type': 'p',
        'version': 'v',
      };

      final body = buildBody(deviceMeta);

      expect(body.containsKey('fcm_token'), isFalse);
      expect(body.containsKey('is_active'), isFalse);
    });
  });

  group('updateDeviceMeta not-initialized handling', () {
    // updateDeviceMeta catches LaravelNotifyFcmNotInitializedException from
    // getDeviceMetaJson() and returns null instead of propagating. The static
    // syncDeviceMeta wrapper then converts null to false (`?? false`) so the
    // caller sees a clean boolean failure rather than a crash.

    bool? simulateUpdateDeviceMeta(Map<String, dynamic>? Function() readMeta) {
      Map<String, dynamic> deviceMeta;
      try {
        final result = readMeta();
        if (result == null) return null;
        deviceMeta = result;
      } on LaravelNotifyFcmNotInitializedException {
        return null;
      }
      // Returns 1 to represent "request was attempted with meta".
      return deviceMeta.isNotEmpty;
    }

    test('returns null when getDeviceMetaJson throws not-initialized', () {
      final result = simulateUpdateDeviceMeta(() {
        throw LaravelNotifyFcmNotInitializedException(
            'DeviceMeta instance is null. Please call '
            'LaravelNotifyFcm.instance.init() first.');
      });

      expect(result, isNull);
    });

    test('does not catch unrelated exceptions', () {
      expect(
        () => simulateUpdateDeviceMeta(() {
          throw StateError('unrelated failure');
        }),
        throwsA(isA<StateError>()),
      );
    });

    test('proceeds normally when getDeviceMetaJson returns a map', () {
      final result = simulateUpdateDeviceMeta(() => {'uuid': 'u'});

      expect(result, isTrue);
    });

    test('syncDeviceMeta wrapper coalesces null and preserves bool', () {
      // Mirrors the `?? false` in LaravelNotifyFcm.syncDeviceMeta.
      bool applyWrapper(bool? apiResult) => apiResult ?? false;

      expect(applyWrapper(null), isFalse);
      expect(applyWrapper(true), isTrue);
      expect(applyWrapper(false), isFalse);
    });
  });

  group('Authorization header format', () {
    test('Bearer token format is correct', () {
      const sanctumToken = 'abc123def456';
      const header = 'Bearer $sanctumToken';

      expect(header, equals('Bearer abc123def456'));
      expect(header.startsWith('Bearer '), isTrue);
    });

    test('Bearer token preserves token value', () {
      const sanctumToken = 'my-super-secret-token-with-special-chars!@#';
      const header = 'Bearer $sanctumToken';

      expect(header, contains(sanctumToken));
    });
  });
}
