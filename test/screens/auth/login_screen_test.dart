import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitcrew/screens/auth/login_screen.dart';
import 'package:fitcrew/theme/colors.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('LoginScreen shows title', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();
    });
    expect(find.text('Se connecter'), findsOneWidget);
  });

  testWidgets('LoginScreen shows Google button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    expect(find.text('Continuer avec Google'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });

  testWidgets('LoginScreen shows Apple button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    expect(find.text('Continuer avec Apple'), findsOneWidget);
  });

  testWidgets('LoginScreen uses correct colors', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, equals(AppColors.loginBackgroundColor));

    final buttons = tester.widgetList<ElevatedButton>(find.byType(ElevatedButton));
    final googleButton = buttons.first;
    final appleButton = buttons.last;

    final googleStyle = googleButton.style as ButtonStyle;
    final appleStyle = appleButton.style as ButtonStyle;

    expect(
      googleStyle.backgroundColor?.resolve({}),
      equals(AppColors.loginButtonColor),
    );
    expect(
      appleStyle.backgroundColor?.resolve({}),
      equals(AppColors.loginTextColor),
    );
  });
} 