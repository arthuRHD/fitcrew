import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitcrew/screens/auth/login_screen.dart';
import 'package:fitcrew/theme/colors.dart';
import 'package:fitcrew/providers/auth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseAuth>(),
  MockSpec<GoogleSignIn>(),
  MockSpec<GoogleSignInAccount>(),
  MockSpec<GoogleSignInAuthentication>(),
])
import 'login_screen_test.mocks.dart';

void main() {
  late MockFirebaseAuth mockAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockGoogleSignInAccount mockGoogleSignInAccount;
  late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockGoogleSignInAccount = MockGoogleSignInAccount();
    mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        authProvider.overrideWithValue(mockAuth),
        googleSignInProvider.overrideWithValue(mockGoogleSignIn),
      ],
      child: const MaterialApp(home: LoginScreen()),
    );
  }

  testWidgets('LoginScreen shows title', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('Se connecter'), findsOneWidget);
  });

  testWidgets('LoginScreen shows Google button', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('Continuer avec Google'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });

  testWidgets('LoginScreen shows Apple button', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('Continuer avec Apple'), findsOneWidget);
  });

  testWidgets('LoginScreen uses correct colors', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    
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

  testWidgets('Shows error message on Google sign in failure', (tester) async {
    when(mockGoogleSignIn.signIn()).thenThrow(
      PlatformException(
        code: 'sign_in_failed',
        message: 'Sign in failed',
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.text('Continuer avec Google'));
    await tester.pumpAndSettle();

    expect(find.text('Erreur de connexion: Sign in failed'), findsOneWidget);
  });

  testWidgets('Successfully signs in with Google', (tester) async {
    when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleSignInAccount);
    when(mockGoogleSignInAccount.authentication).thenAnswer((_) async => mockGoogleSignInAuthentication);
    when(mockGoogleSignInAuthentication.accessToken).thenReturn('fake-token');
    when(mockGoogleSignInAuthentication.idToken).thenReturn('fake-id-token');
    when(mockAuth.signInWithCredential(any)).thenAnswer((_) async => MockUserCredential());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.text('Continuer avec Google'));
    await tester.pumpAndSettle();

    verify(mockAuth.signInWithCredential(any)).called(1);
  });
}

class MockUserCredential extends Mock implements UserCredential {} 