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
    final milestonesService = HealthMilestonesService();
    final minutesElapsed = daysElapsed * 1440; // Convertir días a minutos
    final nextMilestone = milestonesService.getNextMilestone(minutesElapsed);

    if (nextMilestone == null) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                'Has alcanzado el máximo. ¡Eres un verdadero campeón!',
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

    final daysUntilNext = (nextMilestone.afterMinutes - minutesElapsed) ~/ 1440;
    final progress = milestonesService.getProgressToNextMilestone(minutesElapsed);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Próximo beneficio',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nextMilestone.getCategoryEmoji(),
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nextMilestone.titleEs,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'En $daysUntilNext días',
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
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.blue.shade400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
