import 'package:ncc/ncc.dart';
import 'package:test/test.dart';

import 'clients/mock_infinity_request_client.dart';

final class TimeoutTestNccClient extends NccClient {
  new({
    required super.id,
    required super.client,
    super.timeout = const Duration(milliseconds: 200),
  });
}

final class _TimeoutObserver implements NetworkObserver {
  int onErrorCalls = 0;
  Object? lastError;
  StackTrace? lastStackTrace;

  @override
  void onError({
    required BaseClient client,
    required Object error,
    required StackTrace? stackTrace,
  }) {
    onErrorCalls++;
    lastError = error;
    lastStackTrace = stackTrace;
  }

  @override
  void onChangeNetworkStatus({
    required BaseClient client,
    required NetworkState previousState,
    required NetworkState currentState,
  }) {}

  @override
  void onResponse({required BaseClient client, required OnResponse response}) {}

  @override
  void dispose() {}
}

void main() {
  group('Timeout network state', () {
    test('a timed out request becomes offline and notifies once', () async {
      final observer = _TimeoutObserver();
      final client = TimeoutTestNccClient(
        client: MockInfinityRequestClient(),
        id: 'timeoutClient',
      )..addObserver(observer);

      await expectLater(
        () => client.get(Uri.dataFromString('test_dart.es')),
        throwsA(isA<NetworkTimeoutException>()),
      );

      expect(client.clientState, NetworkState.offline);
      expect(observer.onErrorCalls, 1);
      expect(observer.lastError, isA<NetworkTimeoutException>());
      expect(observer.lastStackTrace, isNotNull);
    });
  });
}
