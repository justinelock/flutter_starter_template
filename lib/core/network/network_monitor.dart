import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'network_status.dart';

final networkMonitorProvider = Provider<NetworkMonitor>(
  (ref) => ConnectivityNetworkMonitor(Connectivity()),
  name: 'networkMonitorProvider',
);

abstract interface class NetworkMonitor {
  Stream<NetworkStatus> watch();
}

class NoopNetworkMonitor implements NetworkMonitor {
  const NoopNetworkMonitor();

  @override
  Stream<NetworkStatus> watch() => Stream.value(NetworkStatus.unknown);
}

class ConnectivityNetworkMonitor implements NetworkMonitor {
  const ConnectivityNetworkMonitor(this._connectivity);

  final Connectivity _connectivity;

  @override
  Stream<NetworkStatus> watch() {
    return _connectivity.onConnectivityChanged.map(_mapResult);
  }

  NetworkStatus _mapResult(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) return NetworkStatus.offline;
    if (results.isEmpty) return NetworkStatus.unknown;
    return NetworkStatus.online;
  }
}
