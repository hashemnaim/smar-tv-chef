import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

enum ConnectivityStatus { WiFi, Cellular, Offline }

class ConnectivityService {
  static ConnectivityStatus connectivityStatus;
  BuildContext context;
  // Create our public controller
  Stream<ConnectivityStatus> get valueStream =>
      connectionStatusController.stream;
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  ConnectivityService() {
    // Subscribe to the connectivity Chanaged Steam
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Use Connectivity() here to gather more info if you need t
      connectionStatusController.add(_getStatusFromResult(result));
      if (_getStatusFromResult(result) == ConnectivityStatus.Offline) {
        connectivityStatus = ConnectivityStatus.Offline;
      } else {
        connectivityStatus = ConnectivityStatus.WiFi;
      }
    });
  }
  // Convert from the third part enum to our own enum
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }
}
