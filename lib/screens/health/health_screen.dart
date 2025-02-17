import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health/health.dart';
import '../../providers/health_provider.dart';
import '../../theme/colors.dart';

class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthData = ref.watch(healthDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Data'),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.rotate),
            onPressed: () => unawaited(ref.refresh(healthDataProvider.future)),
          ),
        ],
      ),
      body: healthData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.triangleExclamation,
                color: AppColors.error,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Permission required',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final granted = await ref
                      .read(healthServiceProvider)
                      .requestPermissions();
                  if (granted) {
                    unawaited(ref.refresh(healthDataProvider.future));
                  }
                },
                child: const Text('Grant Access'),
              ),
            ],
          ),
        ),
        data: (data) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _HealthCard(
              icon: FontAwesomeIcons.personWalking,
              title: 'Steps',
              value: _findLatestValue(data, HealthDataType.STEPS),
              unit: 'steps',
            ),
            _HealthCard(
              icon: FontAwesomeIcons.heart,
              title: 'Heart Rate',
              value: _findLatestValue(data, HealthDataType.HEART_RATE),
              unit: 'bpm',
            ),
            _HealthCard(
              icon: FontAwesomeIcons.route,
              title: 'Distance',
              value: _findLatestValue(data, HealthDataType.DISTANCE_WALKING_RUNNING),
              unit: 'km',
            ),
            _HealthCard(
              icon: FontAwesomeIcons.fire,
              title: 'Calories',
              value: _findLatestValue(data, HealthDataType.ACTIVE_ENERGY_BURNED),
              unit: 'kcal',
            ),
          ],
        ),
      ),
    );
  }

  double _findLatestValue(List<HealthDataPoint> data, HealthDataType type) {
    if (kDebugMode) {
      print(data);
    }
    final points = data.where((p) => p.type == type);
    if (points.isEmpty) return 0;
    return double.tryParse(points.last.value.toString()) ?? 0;
  }
}

class _HealthCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final double value;
  final String unit;

  const _HealthCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            FaIcon(icon, color: AppColors.darkGreen, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '$value $unit',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 