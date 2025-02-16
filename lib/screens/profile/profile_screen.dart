import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/auth_provider.dart';
import '../../theme/colors.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
            onPressed: () async {
              await ref.read(authServiceProvider).signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(
              FontAwesomeIcons.circleUser,
              size: 100,
              color: AppColors.darkGreen,
            ),
            const SizedBox(height: 24),
            Text(
              user?.displayName ?? 'User',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              user?.email ?? 'No email',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
} 