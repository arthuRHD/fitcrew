import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:health/health.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitcrew/screens/health/health_screen.dart';
import 'package:fitcrew/providers/health_provider.dart';

@GenerateNiceMocks([
  MockSpec<HealthService>(),
  MockSpec<GoRouter>(),
])
import 'health_screen_test.mocks.dart';

void main() {
  late MockHealthService mockHealthService;
  late MockGoRouter mockRouter;

  setUp(() {
    mockHealthService = MockHealthService();
    mockRouter = MockGoRouter();

    when(mockHealthService.getDailySteps())
        .thenAnswer((_) async => 5000.0);
        
    when(mockHealthService.fetchTodayData())
        .thenAnswer((_) async => [
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
           HealthDataPoint(
          value: NumericHealthValue(numericValue: 75.0),
          type: HealthDataType.HEART_RATE,
          unit: HealthDataUnit.BEATS_PER_MINUTE,
          dateFrom:DateTime.now(),
          dateTo: DateTime.now(),
          sourcePlatform: HealthPlatformType.googleHealthConnect,
          uuid: 'uuid',
          sourceDeviceId: 'sourceDeviceId',
          sourceId: 'sourceId',
          sourceName: 'sourceName',
        ),
        ]);
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        healthServiceProvider.overrideWithValue(mockHealthService),
      ],
      child: InheritedGoRouter(
        goRouter: mockRouter,
        child: const MaterialApp(home: HealthScreen()),
      ),
    );
  }

  testWidgets('Shows health cards with data', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Steps'), findsOneWidget);
    expect(find.text('5000.0 steps'), findsOneWidget);
    expect(find.text('Weight'), findsOneWidget);
    expect(find.text('70.5 kg'), findsOneWidget);
    expect(find.text('Heart Rate'), findsOneWidget);
    expect(find.text('75.0 bpm'), findsOneWidget);
  });

  testWidgets('Can navigate back to home', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    
    await tester.tap(
      find.byWidgetPredicate((widget) => 
        widget is FaIcon && widget.icon == FontAwesomeIcons.arrowLeft
      ),
    );
    await tester.pumpAndSettle();

    verify(mockRouter.go('/home')).called(1);
  });

  testWidgets('Shows error state and permission button', (tester) async {
    when(mockHealthService.fetchTodayData())
        .thenThrow(Exception('Permission denied'));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Permission required'), findsOneWidget);
    expect(find.text('Grant Access'), findsOneWidget);
  });
} 