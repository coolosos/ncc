import 'dart:io' show HttpStatus;

import 'package:ncc/ncc.dart';
import 'package:test/test.dart';

import 'clients/mock_client.dart';

final class _BrokenThenOfflineClient extends MockClient {
  int _calls = 0;

  @override
  Future<Response> get genericResponse {
    _calls++;
    if (_calls == 1) {
      return Future.value(Response('SessionBroke', HttpStatus.unauthorized));
    }
    throw ClientException('offline', Uri.dataFromString('test_dart.es'));
  }
}

final class _SessionClient extends SessionClient {
  new({required super.id, required super.client});

  @override
  Future<String?> getBearerToken() async => 'token';

  @override
  Future<bool> renewSession() async => false;
}

final class _StateObserver implements NetworkObserver {
  final List<NetworkState> states = [];

  @override
  void onChangeNetworkStatus({
    required BaseClient client,
    required NetworkState previousState,
    required NetworkState currentState,
  }) {
    states.add(currentState);
  }

  @override
  void onError({
    required BaseClient client,
    required Object error,
    required StackTrace? stackTrace,
  }) {}

  @override
  void onResponse({required BaseClient client, required OnResponse response}) {}

  @override
  void dispose() {}
}

void main() {
  group('Network state transition from notLoggedIn', () {
    test('a notLoggedIn client can transition to offline', () async {
      final observer = _StateObserver();
      final client = _SessionClient(
        client: _BrokenThenOfflineClient(),
        id: 'notLoggedInToOffline',
      )..addObserver(observer);

      await expectLater(
        () => client.get(Uri.dataFromString('test_dart.es')),
        throwsA(isA<NotLoggedInException>()),
      );
      expect(client.clientState, NetworkState.notLoggedIn);

      await expectLater(
        () => client.get(Uri.dataFromString('test_dart.es')),
        throwsA(isA<NetworkAvailabilityException>()),
      );

      expect(client.clientState, NetworkState.offline);
      expect(observer.states, [NetworkState.notLoggedIn, NetworkState.offline]);
    });
  });
}
