import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

final healthStoreProvider = Provider<Health>((ref) {
  final health = Health();
  return health;
});

final healthServiceProvider = Provider<HealthService>((ref) {
  final service = HealthService(healthStore: ref.watch(healthStoreProvider));
  unawaited(service.configure());
  unawaited(service.requestPermissions());
  return service;
});

final healthDataProvider = FutureProvider<List<HealthDataPoint>>((ref) async {
  final healthService = ref.watch(healthServiceProvider);
  return await healthService.fetchTodayData();
});

final dailyStepsProvider = FutureProvider<double>((ref) async {
  final healthService = ref.watch(healthServiceProvider);
  return await healthService.getDailySteps();
});

class HealthService {
  final Health healthStore;
  static const types = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.WEIGHT,
  ];

  HealthService({required this.healthStore});

  Future<void> configure() async {
    return await healthStore.configure();
  }

  Future<bool> requestPermissions() async {
    if (await Permission.activityRecognition.request().isGranted) {
      return await healthStore.requestAuthorization(types);
    }
    return false;
  }

  Future<double> getDailySteps() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    int? steps = await healthStore.getTotalStepsInInterval(midnight, now);
    if (steps != null) {
      return steps!.toDouble(); 
    }
    return 0;
  }

  Future<List<HealthDataPoint>> fetchTodayData() async {
    final now = DateTime.now();
    final fromThePast = DateTime(now.year - 1, now.month, now.day);

    return await healthStore.getHealthDataFromTypes(
        types: types,
        startTime: fromThePast,
        endTime: now,
    );
  }
} 
