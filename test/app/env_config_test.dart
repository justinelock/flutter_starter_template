import 'package:flutter_starter_template/app/environment/env_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnvConfig.joinApiBaseUrl', () {
    test('joins host and prefix without duplicate slashes', () {
      expect(
        EnvConfig.joinApiBaseUrl(
          baseUrl: 'https://api.example.com',
          apiPrefix: '/api/v1',
        ),
        'https://api.example.com/api/v1',
      );
    });

    test('strips trailing slash from host', () {
      expect(
        EnvConfig.joinApiBaseUrl(
          baseUrl: 'http://192.168.254.127:8091/',
          apiPrefix: '/api/v1',
        ),
        'http://192.168.254.127:8091/api/v1',
      );
    });

    test('adds leading slash to prefix when missing', () {
      expect(
        EnvConfig.joinApiBaseUrl(
          baseUrl: 'https://api.example.com',
          apiPrefix: 'api/v1',
        ),
        'https://api.example.com/api/v1',
      );
    });

    test('returns host only when prefix is empty', () {
      expect(
        EnvConfig.joinApiBaseUrl(
          baseUrl: 'https://api.example.com',
          apiPrefix: '',
        ),
        'https://api.example.com',
      );
    });
  });

  test('EnvConfig.current exposes separated baseUrl and apiPrefix', () {
    final config = EnvConfig.current();

    expect(config.baseUrl, isNot(contains('/api/v1')));
    expect(config.apiPrefix, '/api/v1');
    expect(config.apiBaseUrl, endsWith('/api/v1'));
  });
}
