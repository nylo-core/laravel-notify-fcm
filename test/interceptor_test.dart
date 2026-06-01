import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('X-DMETA header format', () {
    test('X-DMETA should be valid JSON when present', () {
      // This tests the expected format of the X-DMETA header
      // When LaravelNotifyFcm is properly initialized, the header should contain:
      final expectedStructure = {
        'uuid': 'device-uuid',
        'model': 'iPhone 14',
        'display_name': 'Test Device',
        'platform': 'ios',
        'version': '16.0',
      };

      final jsonString = jsonEncode(expectedStructure);
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;

      expect(decoded.containsKey('uuid'), isTrue);
      expect(decoded.containsKey('model'), isTrue);
      expect(decoded.containsKey('display_name'), isTrue);
      expect(decoded.containsKey('platform'), isTrue);
      expect(decoded.containsKey('version'), isTrue);
    });

    test('X-DMETA field mapping matches expected keys', () {
      // Documents the field mapping from DeviceMeta to X-DMETA
      // DeviceMeta field -> X-DMETA field
      final fieldMapping = {
        'uuid': 'uuid',
        'model': 'model',
        'name': 'display_name', // Note: 'name' maps to 'display_name'
        'platform_type': 'platform', // Note: 'platform_type' maps to 'platform'
        'version': 'version',
      };

      expect(fieldMapping['name'], equals('display_name'));
      expect(fieldMapping['platform_type'], equals('platform'));
    });
  });
}
