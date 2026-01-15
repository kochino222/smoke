import 'package:flutter/material.dart';
import '../models/health_milestone.dart';
import '../services/health_milestones_service.dart';

class MilestonesListWidget extends StatelessWidget {
  final int daysElapsed;

  const MilestonesListWidget({
    required this.daysElapsed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HealthMilestone>>(
      future: HealthMilestonesService.loadMilestones(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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

        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        final milestones = snapshot.data ?? [];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                  itemCount: milestones.length,
                  itemBuilder: (context, index) {
                    final milestone = milestones[index];
                    final isAchieved = daysElapsed >= milestone.daysRequired;
                    final isNext = index == 0 ||
                        (daysElapsed >=
                                milestones[index - 1].daysRequired &&
                            daysElapsed < milestone.daysRequired);

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
                            milestone.icon,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  milestone.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isAchieved
                                        ? Colors.black87
                                        : Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  '${milestone.daysRequired} días',
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
              ],
            ),
          ),
        );
      },
    );
  }
}
