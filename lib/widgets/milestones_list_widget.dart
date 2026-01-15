import 'package:flutter/material.dart';
import '../models/health_milestone.dart';
import '../services/health_milestones_service.dart';
import '../styles.dart';

class MilestonesListWidget extends StatelessWidget {
  final int daysElapsed;

  const MilestonesListWidget({
    required this.daysElapsed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final milestonesService = HealthMilestonesService();
    final minutesElapsed = daysElapsed * 1440;
    final milestones = milestonesService.getAllMilestones();

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            const Text(
              'Logros desbloqueados',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: milestones.take(5).length, // Solo primeros 5
              itemBuilder: (context, index) {
                final milestone = milestones[index];
                final isAchieved = minutesElapsed >= milestone.afterMinutes;
                final isNext = milestone == milestonesService.getNextMilestone(minutesElapsed);

                String statusIcon;
                if (isAchieved) {
                  statusIcon = '✅';
                } else if (isNext) {
                  statusIcon = '⏳';
                } else {
                  statusIcon = '🔒';
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Text(
                        milestone.getCategoryEmoji(),
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              milestone.titleEs,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isAchieved
                                    ? Colors.black87
                                    : Colors.grey[600],
                              ),
                            ),
                            Text(
                              HealthMilestone.formatMinutes(milestone.afterMinutes),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        statusIcon,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (milestones.length > 5) ...[
              const SizedBox(height: 8),
              Center(
                child: Text(
                  '+${milestones.length - 5} más en Timeline',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
  }
}
