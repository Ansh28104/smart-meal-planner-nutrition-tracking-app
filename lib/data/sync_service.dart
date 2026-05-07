import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hive_service.dart';

/// Sync service that pushes offline data to Firebase Firestore
class SyncService {
  static final SyncService _instance = SyncService._();
  factory SyncService() => _instance;
  SyncService._();

  bool _isSyncing = false;
  bool _isOnline = false;
  StreamSubscription? _connectivitySub;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        // Push to Firebase Firestore
        await _firestore.collection('meal_entries').doc(entry.id).set({
          'id': entry.id,
          'foodName': entry.foodName,
          'calories': entry.totalCalories,
          'protein': entry.totalProtein,
          'carbs': entry.totalCarbs,
          'fats': entry.totalFats,
          'quantity': entry.quantity,
          'mealType': entry.mealType.toString(),
          'date': entry.date.toIso8601String(),
          'syncedAt': FieldValue.serverTimestamp(),
        });

        await HiveService.markAsSynced(entry.id);
      }
    } catch (e) {
      print('Firebase sync failed: $e');
    } finally {
      _isSyncing = false;
    }
  }
}
