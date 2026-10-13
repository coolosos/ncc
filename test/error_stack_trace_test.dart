import 'package:ncc/ncc.dart';
import 'package:test/test.dart';

import 'clients/mock_socket_exception.dart';

final class TestNccClient extends NccClient {
  new({
    required super.client,
    required super.id,
    super.timeout = const Duration(milliseconds: 200),
  });
}

final class _StackTraceObserver implements NetworkObserver {
  StackTrace? lastStackTrace;
  Object? lastError;

  @override
  void onChangeNetworkStatus({
    required BaseClient client,
    required NetworkState previousState,
    required NetworkState currentState,
  }) {}

  @override
  void onError({
    required BaseClient client,
    required Object error,
    required StackTrace? stackTrace,
  }) {
    lastError = error;
    lastStackTrace = stackTrace;
  }

  @override
  void onResponse({required BaseClient client, required OnResponse response}) {}

  @override
  void dispose() {}
}

void main() {
  group('Error stack trace', () {
    test(
      'preserves the original stack trace when mapping offline errors',
      () async {
        final observer = _StackTraceObserver();
        final client = TestNccClient(
          client: MockSocketException(),
          id: 'stackTracePreserved',
        )..addObserver(observer);

        StackTrace? caughtStackTrace;
        try {
          await client.get(Uri.dataFromString('test_dart.es'));
        } catch (_, stackTrace) {
          caughtStackTrace = stackTrace;
        }

        expect(caughtStackTrace, isNotNull);
        expect(observer.lastStackTrace, isNotNull);
        // The stack trace propagated to the caller must be the original one,
        // not a new trace pointing to the error-mapping code.
        expect(observer.lastStackTrace.toString(), caughtStackTrace.toString());
        expect(
          caughtStackTrace.toString(),
          contains('mock_socket_exception.dart'),
        );
      },
    );
  });
}
