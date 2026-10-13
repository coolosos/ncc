import 'package:ncc/ncc.dart';
import 'package:test/test.dart';

import 'clients/mock_success_request_client.dart';
import 'clients/mock_undermantenance_client_exception.dart';

final class _TestNccClient extends NccClient {
  new({required super.client, required super.id});
}

void main() {
  group('GlobalNetworkObservable client state', () {
    test('dispose drops the tracked state for the client', () async {
      final client = _TestNccClient(
        client: MockUndermantenanceClientException(),
        id: 'stateLeakClient',
      );

      await expectLater(
        () => client.get(Uri.dataFromString('test_dart.es')),
        throwsA(isA<ServerAvailabilityException>()),
      );
      expect(client.clientState, NetworkState.underMaintenance);

      client.dispose();

      expect(client.clientState, NetworkState.normal);
    });

    test('a disposed id does not leak its state into a new client', () async {
      final first = _TestNccClient(
        client: MockUndermantenanceClientException(),
        id: 'reusedIdClient',
      );
      await expectLater(
        () => first.get(Uri.dataFromString('test_dart.es')),
        throwsA(isA<ServerAvailabilityException>()),
      );
      expect(first.clientState, NetworkState.underMaintenance);

      first.dispose();

      final second = _TestNccClient(
        client: MockSuccessRequestClient(),
        id: 'reusedIdClient',
      );
      expect(second.clientState, NetworkState.normal);
    });

    test(
      'GlobalNetworkObservable.dispose clears tracked client state',
      () async {
        final client = _TestNccClient(
          client: MockUndermantenanceClientException(),
          id: 'globalDisposeClient',
        );
        await expectLater(
          () => client.get(Uri.dataFromString('test_dart.es')),
          throwsA(isA<ServerAvailabilityException>()),
        );
        expect(client.clientState, NetworkState.underMaintenance);

        GlobalNetworkObservable.dispose();

        expect(client.clientState, NetworkState.normal);
      },
    );
  });
}
