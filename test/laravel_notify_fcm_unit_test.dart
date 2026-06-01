import 'package:flutter_test/flutter_test.dart';
import 'package:laravel_notify_fcm/exceptions/laravel_notify_fcm_exception.dart';

void main() {
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
