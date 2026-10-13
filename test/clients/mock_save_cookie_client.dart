import 'package:ncc/ncc.dart';

import 'mock_client.dart';

final class MockSaveCookieClient extends MockClient {
  new({required this.cookie});
  final String cookie;
  @override
  Future<Response> get genericResponse async => Response(
    'Save cookie',
    200,
    headers: {HttpHeaders.setCookieHeader: cookie},
  );
}
