import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'hive_service.dart';

/// Stub sync service that simulates backend synchronization.
/// In production, replace the _pushToServer method with actual API calls.
class SyncService {
  static final SyncService _instance = SyncService._();
  factory SyncService() => _instance;
  SyncService._();

  bool _isSyncing = false;
  bool _isOnline = false;
  StreamSubscription? _connectivitySub;

  bool get isOnline => _isOnline;
  bool get isSyncing => _isSyncing;

  int get pendingSyncCount => HiveService.getUnsyncedEntries().length;

  /// Start listening for connectivity changes
  void startListening() {
    _connectivitySub = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _isOnline = result != ConnectivityResult.none;
      if (_isOnline) {
        syncPendingEntries();
      }
    });

    // Check initial connectivity
    Connectivity().checkConnectivity().then((results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _isOnline = result != ConnectivityResult.none;
    });
  }

  /// Stop listening for connectivity changes
  void stopListening() {
    _connectivitySub?.cancel();
  }

  /// Sync all pending (unsynced) meal entries
  Future<void> syncPendingEntries() async {
    if (_isSyncing || !_isOnline) return;
    _isSyncing = true;

    try {
      final unsynced = HiveService.getUnsyncedEntries();
      for (final entry in unsynced) {
        // Simulate network call with a small delay
        await Future.delayed(const Duration(milliseconds: 100));
        // In production: await _pushToServer(entry);
        await HiveService.markAsSynced(entry.id);
      }
    } catch (e) {
      // Silently fail - will retry on next connectivity change
    } finally {
      _isSyncing = false;
    }
  }
}
