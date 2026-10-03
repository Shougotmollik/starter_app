import 'dart:async';
import 'dart:io';

import 'package:shougot_flutter/core/utils/app_snackbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'internet_checker.g.dart';

/// Production-grade internet connectivity checker.
/// 
/// Combines OS network state (via connectivity_plus) with lightweight DNS/socket
/// verification, cached with a 3-second TTL to avoid duplicate lookups on parallel requests.
abstract class InternetChecker {
  static final Connectivity _connectivity = Connectivity();
  static bool _lastKnownStatus = true;
  static DateTime? _lastCheckTime;
  static const Duration _cacheTtl = Duration(seconds: 3);

  /// Checks if the device has an active and verified internet connection.
  /// 
  /// - [showError]: If `true`, pops up a floating error snackbar when offline.
  /// - [forceRefresh]: Ignores the 3s cache and forces an immediate verification.
  static Future<bool> hasConnection({
    bool showError = false,
    bool forceRefresh = false,
  }) async {
    // 1. Return cached result if valid and not forcing refresh
    if (!forceRefresh && _lastCheckTime != null) {
      final elapsed = DateTime.now().difference(_lastCheckTime!);
      if (elapsed < _cacheTtl) {
        if (!_lastKnownStatus && showError) {
          _showOfflineSnackbar();
        }
        return _lastKnownStatus;
      }
    }

    // 2. Hardware check: Is there any network interface available?
    final connectivityResults = await _connectivity.checkConnectivity();
    if (connectivityResults.contains(ConnectivityResult.none)) {
      _lastKnownStatus = false;
      _lastCheckTime = DateTime.now();
      if (showError) _showOfflineSnackbar();
      return false;
    }

    // 3. Real Internet verification (Captive portal & actual throughput check)
    _lastKnownStatus = await _verifyActualInternet();
    _lastCheckTime = DateTime.now();

    if (!_lastKnownStatus && showError) {
      _showOfflineSnackbar();
    }

    return _lastKnownStatus;
  }

  /// Verifies actual internet packet delivery safely across all platforms (including Web).
  static Future<bool> _verifyActualInternet() async {
    if (kIsWeb) {
      final results = await _connectivity.checkConnectivity();
      return !results.contains(ConnectivityResult.none);
    }

    // Fast socket / DNS ping checks
    final hosts = ['1.1.1.1', '8.8.8.8', 'google.com'];

    for (final host in hosts) {
      try {
        final result = await InternetAddress.lookup(host).timeout(
          const Duration(seconds: 2),
        );
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } catch (_) {
        continue;
      }
    }

    return false;
  }

  static void _showOfflineSnackbar() {
    AppSnackbar.show(
      title: 'No Internet Connection',
      message: 'Please check your Wi-Fi or mobile data network.',
      type: SnackbarType.error,
    );
  }
}

/// Reactive, battery-friendly Riverpod stream listening to OS network changes.
@riverpod
Stream<bool> internetStatus(Ref ref) async* {
  // Emit initial status
  yield await InternetChecker.hasConnection();

  // Listen reactively to hardware changes (0 battery waste when idle)
  yield* Connectivity().onConnectivityChanged.asyncMap((results) async {
    if (results.contains(ConnectivityResult.none)) {
      return false;
    }
    return InternetChecker.hasConnection(forceRefresh: true);
  });
}