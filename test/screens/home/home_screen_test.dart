import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fitcrew/screens/home/home_screen.dart';
import 'package:fitcrew/providers/auth_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@GenerateNiceMocks([MockSpec<User>(), MockSpec<FirebaseAuth>()])
import 'home_screen_test.mocks.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockUser mockUser;
  late MockFirebaseAuth mockAuth;
  late MockGoRouter mockRouter;

  setUp(() {
    mockUser = MockUser();
    mockAuth = MockFirebaseAuth();
    mockRouter = MockGoRouter();
    when(mockUser.email).thenReturn('test@example.com');
    when(mockUser.displayName).thenReturn('Test User');
    when(mockAuth.authStateChanges()).thenAnswer((_) => Stream.value(mockUser));
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        authProvider.overrideWithValue(mockAuth),
      ],
      child: InheritedGoRouter(
        goRouter: mockRouter,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
  }

  testWidgets('Can navigate to profile', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    
    await tester.tap(
      find.byWidgetPredicate((widget) => 
        widget is FaIcon && widget.icon == FontAwesomeIcons.user
      ),
    );
    await tester.pumpAndSettle();

    verify(mockRouter.go('/profile')).called(1);
  });
} 