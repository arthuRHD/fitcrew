import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitcrew/router/router.dart';
import 'package:fitcrew/screens/auth/login_screen.dart';
import 'package:fitcrew/screens/home/home_screen.dart';
import 'package:fitcrew/screens/profile/profile_screen.dart';

void main() {
  testWidgets('Router initializes at login screen', (tester) async {
    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router),
    );
    
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Can navigate to home screen', (tester) async {
    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router),
    );

    router.go('/home');
    await tester.pumpAndSettle();
    
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Can navigate to profile screen', (tester) async {
    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router),
    );

    router.go('/profile');
    await tester.pumpAndSettle();
    
    expect(find.byType(ProfileScreen), findsOneWidget);
  });
} 