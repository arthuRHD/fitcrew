import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitcrew/screens/crews/create_crew_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitcrew/providers/crew_provider.dart';
import 'package:fitcrew/providers/firestore_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@GenerateNiceMocks([
  MockSpec<GoRouter>(),
  MockSpec<CrewService>(),
  MockSpec<FirebaseFirestore>(),
])
import 'create_crew_screen_test.mocks.dart';

void main() {
  late MockGoRouter mockRouter;
  late MockCrewService mockCrewService;
  late MockFirebaseFirestore mockFirestore;

  setUp(() {
    mockRouter = MockGoRouter();
    mockCrewService = MockCrewService();
    mockFirestore = MockFirebaseFirestore();

    when(mockCrewService.createCrew(
      name: anyNamed('name'),
      description: anyNamed('description'),
    )).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        crewServiceProvider.overrideWithValue(mockCrewService),
        firestoreProvider.overrideWithValue(mockFirestore),
      ],
      child: InheritedGoRouter(
        goRouter: mockRouter,
        child: const MaterialApp(home: CreateCrewScreen()),
      ),
    );
  }

  testWidgets('Shows form fields', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Crew Name'), findsOneWidget);
    expect(find.text('Description (Optional)'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
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

  testWidgets('Shows validation error for empty name', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a crew name'), findsOneWidget);
  });

  testWidgets('Can create crew with valid data', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Crew Name'),
      'Test Crew',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Description (Optional)'),
      'Test Description',
    );
    
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    verify(mockCrewService.createCrew(
      name: 'Test Crew',
      description: 'Test Description',
    )).called(1);
    verify(mockRouter.go('/home')).called(1);
  });
} 