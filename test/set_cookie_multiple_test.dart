import 'package:ncc/ncc.dart';
import 'package:test/test.dart';

import 'clients/mock_save_cookie_client.dart';

final class _MultipleCookieSessionClient extends SessionClient {
  new({required super.id, required super.client});

  @override
  Future<String?> getBearerToken() async => null;

  @override
  Future<bool> renewSession() async => true;
}

void main() {
  group('Set-Cookie handling', () {
    test(
      'stores every cookie from a comma-separated Set-Cookie header',
      () async {
        final client = _MultipleCookieSessionClient(
          client: MockSaveCookieClient(
            cookie:
                'session=abc; Path=/; HttpOnly, '
                'expires=xyz; Expires=Sun, 06 Nov 1994 08:49:37 GMT',
          ),
          id: 'multipleSetCookie',
        );

        final response = await client.get(Uri.dataFromString('test_dart.es'));
        expect(response.statusCode, 200);

        final headers = await client.sessionHeaders(null);
        expect(headers, <String, String>{
          HttpHeaders.cookieHeader: 'session=abc; expires=xyz',
        });
      },
    );
  });
}
