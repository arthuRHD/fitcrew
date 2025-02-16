import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authProvider).authStateChanges();
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());

// Add a new provider to handle sign out
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    auth: ref.watch(authProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  );
});

class AuthService {
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  AuthService({required this.auth, required this.googleSignIn});

  Future<void> signOut() async {
    await Future.wait([
      auth.signOut(),
      googleSignIn.signOut(),
    ]);
  }
} 