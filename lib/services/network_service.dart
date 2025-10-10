import 'dart:io';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkService {
  static Future<bool> hasInternetConnection() async {
    try {
      // Step 1: Check connection type
      final connectivityResult = await Connectivity().checkConnectivity();

      // New connectivity_plus returns a List<ConnectivityResult>
      if (connectivityResult.every(
        (result) => result == ConnectivityResult.none,
      )) {
        print('No connectivity detected');
        return false;
      }

      // Step 2: Test actual internet access (only if some connection exists)
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));

      final hasInternet = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      print('Internet lookup result: $hasInternet');
      return hasInternet;
    } catch (e) {
      print('Internet connection check failed: $e');
      return false;
    }
  }
}

mixin ConnectionMonitorMixin<T extends StatefulWidget> on State<T> {
  bool hasConnection = true;
  Timer? _connectionTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  void initializeConnectionMonitoring() {
    // Initial connection check
    _checkConnection();

    // Listen to connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _checkConnection();
    });

    // Periodic connection check (every 10 seconds)
    _connectionTimer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) => _checkConnection(),
    );
  }

  void _checkConnection() async {
    try {
      final connectionStatus = await NetworkService.hasInternetConnection();
      if (mounted) {
        setState(() {
          hasConnection = connectionStatus;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          hasConnection = false;
        });
      }
    }
  }

  void disposeConnectionMonitoring() {
    _connectionTimer?.cancel();
    _connectivitySubscription?.cancel();
  }
}
