import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcrew/theme/colors.dart';
import 'firebase_options.dart';
import 'package:fitcrew/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsApp.debugAllowBannerOverride = false;
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FitCrew',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.darkGreen),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
