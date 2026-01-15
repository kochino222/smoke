import 'package:flutter/material.dart';
import '../models/health_milestone.dart';
import '../services/health_milestones_service.dart';
import 'source_bottom_sheet.dart';
import '../styles.dart';

class NextMilestoneCard extends StatelessWidget {
  final int minutesElapsed;
  final String locale;
  final HealthMilestonesService service;

  const NextMilestoneCard({
    super.key,
    required this.minutesElapsed,
    required this.locale,
    required this.service,
  });

  void _showSourceModal(BuildContext context, HealthMilestone milestone) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SourceBottomSheet(
        milestone: milestone,
        locale: locale,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nextMilestone = service.getNextMilestone(minutesElapsed);

    if (nextMilestone == null) {
      // Todos los hitos alcanzados
      return PremiumCard(
        child: Column(
          children: [
            const Text(
              '🏆',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 12),
            Text(
              locale == 'es'
                  ? '¡Todos los hitos alcanzados!'
                  : 'All milestones achieved!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              locale == 'es'
                  ? 'Felicidades por tu progreso en dejar de fumar.'
                  : 'Congratulations on your progress in quitting smoking.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final progress = service.getProgressToNextMilestone(minutesElapsed);
    final timeRemaining = nextMilestone.afterMinutes - minutesElapsed;

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            // Encabezado
            Row(
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
                        locale == 'es' ? 'Próximo hito' : 'Next milestone',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      Text(
                        nextMilestone.getTitle(locale),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Descripción
            Text(
              nextMilestone.getDescription(locale),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // Barra de progreso con jerarquía clara
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                    ),
                    Text(
                      locale == 'es' ? 'Progreso' : 'Progress',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
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
            const SizedBox(height: 12),

            // Tiempo restante con jerarquía
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        HealthMilestone.formatMinutes(timeRemaining),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.amber[900],
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        locale == 'es' ? 'Faltan' : 'Remaining',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.amber[900],
                            ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.schedule,
                    size: 28,
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        _showSourceModal(context, nextMilestone),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      locale == 'es'
                          ? 'Fuente'
                          : 'Source',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        _showSourceModal(context, nextMilestone),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      locale == 'es'
                          ? 'Detalles'
                          : 'Details',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
