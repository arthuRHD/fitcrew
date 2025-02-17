import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitcrew/providers/health_provider.dart';
import 'package:permission_handler/permission_handler.dart';

@GenerateNiceMocks([
  MockSpec<Health>(),
  MockSpec<Permission>(),
])
import 'health_provider_test.mocks.dart';

void main() {
  late MockHealth mockHealth;
  late HealthService healthService;

  setUp(() {
    mockHealth = MockHealth();
    healthService = HealthService(healthStore: mockHealth);
  });

  group('HealthService', () {
    test('configure calls health store configure', () async {
      when(mockHealth.configure()).thenAnswer((_) async => true);
      
      await healthService.configure();
      
      verify(mockHealth.configure()).called(1);
    });

    test('getDailySteps returns steps count', () async {
      when(mockHealth.getTotalStepsInInterval(any, any))
          .thenAnswer((_) async => 1000);
      
      final steps = await healthService.getDailySteps();
      
      expect(steps, 1000.0);
    });

    test('getDailySteps returns 0 when no data', () async {
      when(mockHealth.getTotalStepsInInterval(any, any))
          .thenAnswer((_) async => null);
      
      final steps = await healthService.getDailySteps();
      
      expect(steps, 0.0);
    });

    test('fetchTodayData returns health data points', () async {
      final mockData = [
        HealthDataPoint(
          value: NumericHealthValue(numericValue: 70.5),
          type: HealthDataType.WEIGHT,
          unit: HealthDataUnit.KILOGRAM,
          dateFrom:DateTime.now(),
          dateTo: DateTime.now(),
          sourcePlatform: HealthPlatformType.googleHealthConnect,
          uuid: 'uuid',
          sourceDeviceId: 'sourceDeviceId',
          sourceId: 'sourceId',
          sourceName: 'sourceName',
        ),
      ];

      when(mockHealth.getHealthDataFromTypes(
        types: anyNamed('types'),
        startTime: anyNamed('startTime'),
        endTime: anyNamed('endTime'),
      )).thenAnswer((_) async => mockData);
      
      final data = await healthService.fetchTodayData();
      
      expect(data, equals(mockData));
    });
  });
} 