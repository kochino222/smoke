import 'package:flutter/material.dart';
import '../models/health_milestone.dart';
import '../services/health_milestones_service.dart';

class HealthBenefitsCard extends StatelessWidget {
  final int daysElapsed;

  const HealthBenefitsCard({
    required this.daysElapsed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HealthMilestone?>(
      future: HealthMilestonesService.getNextMilestone(daysElapsed),
      builder: (context, nextSnapshot) {
        if (nextSnapshot.connectionState == ConnectionState.waiting) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 100,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          );
        }

        final nextMilestone = nextSnapshot.data;

        if (nextMilestone == null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Beneficios de salud',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '🎊 ¡Completaste todos los hitos!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Has alcanzado el máximo de 365 días. ¡Eres un verdadero campeón!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final daysUntilNext = nextMilestone.daysRequired - daysElapsed;

        return FutureBuilder<double>(
          future: HealthMilestonesService.getProgressToNextMilestone(daysElapsed),
          builder: (context, progressSnapshot) {
            final progress =
                progressSnapshot.data ?? 0.0;

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Beneficios de salud',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          nextMilestone.icon,
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Próximo: ${nextMilestone.title}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Te faltan $daysUntilNext días',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
