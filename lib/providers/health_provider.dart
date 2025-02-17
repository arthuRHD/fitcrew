import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

final healthStoreProvider = Provider<Health>((ref) => Health());

final healthServiceProvider = Provider<HealthService>((ref) {
  return HealthService(healthStore: ref.watch(healthStoreProvider));
});

final healthDataProvider = FutureProvider<List<HealthDataPoint>>((ref) async {
  return ref.watch(healthServiceProvider).fetchTodayData();
});

class HealthService {
  final Health healthStore;
  static const types = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  HealthService({required this.healthStore});

  Future<bool> requestPermissions() async {
    if (await Permission.activityRecognition.request().isGranted) {
      return await healthStore.requestAuthorization(types);
    }
    return false;
  }

  Future<List<HealthDataPoint>> fetchTodayData() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      return await healthStore.getHealthDataFromTypes(
          types: types,
          startTime: midnight,
          endTime: now,
      );
    } catch (e) {
      return [];
    }
  }
} 