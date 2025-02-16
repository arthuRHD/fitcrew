import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fitcrew/screens/profile/profile_screen.dart';
import 'package:fitcrew/providers/auth_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@GenerateNiceMocks([MockSpec<User>(), MockSpec<FirebaseAuth>(), MockSpec<AuthService>()])
import 'profile_screen_test.mocks.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockUser mockUser;
  late MockFirebaseAuth mockAuth;
  late MockGoRouter mockRouter;
  late MockAuthService mockAuthService;

  setUp(() {
    mockUser = MockUser();
    mockAuth = MockFirebaseAuth();
    mockRouter = MockGoRouter();
    mockAuthService = MockAuthService();
    
    when(mockUser.email).thenReturn('test@example.com');
    when(mockUser.displayName).thenReturn('Test User');
    when(mockAuth.authStateChanges()).thenAnswer((_) => Stream.value(mockUser));
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        authProvider.overrideWithValue(mockAuth),
        authServiceProvider.overrideWithValue(mockAuthService),
      ],
      child: InheritedGoRouter(
        goRouter: mockRouter,
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );
  }

  testWidgets('ProfileScreen shows user info', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
  });

  testWidgets('ProfileScreen shows logout button', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    
    final icon = find.byWidgetPredicate((widget) => 
      widget is FaIcon && widget.icon == FontAwesomeIcons.arrowRightFromBracket
    );
    expect(icon, findsOneWidget);
  });

  testWidgets('Can logout from profile', (tester) async {
    when(mockAuthService.signOut()).thenAnswer((_) async {});
    
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(
      find.byWidgetPredicate((widget) => 
        widget is FaIcon && widget.icon == FontAwesomeIcons.arrowRightFromBracket
      ),
    );
    await tester.pumpAndSettle();

    verify(mockAuthService.signOut()).called(1);
    verify(mockRouter.go('/login')).called(1);
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

  testWidgets('Shows user avatar icon', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    
    final icon = find.byWidgetPredicate((widget) => 
      widget is FaIcon && widget.icon == FontAwesomeIcons.circleUser
    );
    expect(icon, findsOneWidget);
  });
} 