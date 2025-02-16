import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitcrew/router/router.dart';
import 'package:fitcrew/providers/auth_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<User>(), MockSpec<FirebaseAuth>()])
import 'router_test.mocks.dart';

void main() {
  late MockUser mockUser;
  late MockFirebaseAuth mockAuth;

  setUp(() {
    mockUser = MockUser();
    mockAuth = MockFirebaseAuth();
    when(mockUser.email).thenReturn('test@example.com');
    when(mockUser.displayName).thenReturn('Test User');
  });

  testWidgets('Redirects to login when not authenticated', (tester) async {
    when(mockAuth.authStateChanges())
        .thenAnswer((_) => Stream.value(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWithValue(mockAuth),
        ],
        child: Consumer(
          builder: (context, ref, _) => MaterialApp.router(
            routerConfig: ref.watch(routerProvider),
          ),
        ),
      ),
    );

    expect(find.text('Se connecter'), findsOneWidget);
  });

  testWidgets('Redirects to home when authenticated', (tester) async {
    when(mockAuth.authStateChanges())
        .thenAnswer((_) => Stream.value(mockUser));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWithValue(mockAuth),
        ],
        child: Consumer(
          builder: (context, ref, _) => MaterialApp.router(
            routerConfig: ref.watch(routerProvider),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Welcome Test User!'), findsOneWidget);
  });
} 