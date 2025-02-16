import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../theme/colors.dart';
import '../../widgets/common/loading_indicator.dart';
import 'package:flutter/services.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final googleSignIn = ref.read(googleSignInProvider);
      final googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await ref.read(authProvider).signInWithCredential(credential);
      if (mounted) context.go('/home');
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithApple() async {
    setState(() => _isLoading = true);
    try {
      final provider = AppleAuthProvider();
      await ref.read(authProvider).signInWithProvider(provider);
      if (mounted) context.go('/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.loginBackgroundColor,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Se connecter',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.loginTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.loginButtonColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _isLoading ? null : _signInWithGoogle,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.google, color: AppColors.loginTextColor),
                        SizedBox(width: 12),
                        Text(
                          'Continuer avec Google',
                          style: TextStyle(color: AppColors.loginTextColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.loginTextColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _isLoading ? null : _signInWithApple,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.apple, color: AppColors.loginBackgroundColor),
                        SizedBox(width: 12),
                        Text(
                          'Continuer avec Apple',
                          style: TextStyle(color: AppColors.loginBackgroundColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          const LoadingIndicator(
            message: 'Connexion en cours...',
            overlay: true,
          ),
      ],
    );
  }
} 