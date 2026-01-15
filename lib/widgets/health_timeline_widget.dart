import 'package:flutter/material.dart';
import '../services/health_timeline_service.dart';

enum MilestoneState {
  done,
  next,
  locked,
}

/// Widget que muestra la timeline completa de hitos de salud
class HealthTimelineWidget extends StatefulWidget {
  final int daysElapsed;
  final String locale; // 'es' o 'en'

  const HealthTimelineWidget({
    required this.daysElapsed,
    this.locale = 'es',
    super.key,
  });

  @override
  State<HealthTimelineWidget> createState() => _HealthTimelineWidgetState();
}

class _HealthTimelineWidgetState extends State<HealthTimelineWidget> {
  late Future<List<HealthTimelineMilestone>> _achievedFuture;
  late Future<List<HealthTimelineMilestone>> _upcomingFuture;

  @override
  void initState() {
    super.initState();
    final minutes = widget.daysElapsed * 24 * 60;
    _achievedFuture = HealthTimelineService.getAchievedMilestones(minutes);
    _upcomingFuture = HealthTimelineService.getUpcomingMilestones(minutes);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tabs
          TabBar(
            tabs: [
              Tab(
                text: widget.locale == 'es' ? 'Logrados' : 'Achieved',
              ),
              Tab(
                text: widget.locale == 'es' ? 'Próximos' : 'Upcoming',
              ),
            ],
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              children: [
                // Achieved milestones
                FutureBuilder<List<HealthTimelineMilestone>>(
                  future: _achievedFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    final milestones = snapshot.data ?? [];

                    if (milestones.isEmpty) {
                      return Center(
                        child: Text(
                          widget.locale == 'es'
                              ? 'Todavía no hay hitos logrados'
                              : 'No milestones achieved yet',
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: milestones.length,
                      itemBuilder: (context, index) {
                        final milestone = milestones[index];
                        return _MilestoneCard(
                          milestone: milestone,
                          locale: widget.locale,
                          state: MilestoneState.done,
                        );
                      },
                    );
                  },
                ),
                // Upcoming milestones
                FutureBuilder<List<HealthTimelineMilestone>>(
                  future: _upcomingFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    final milestones = snapshot.data ?? [];

                    if (milestones.isEmpty) {
                      return Center(
                        child: Text(
                          widget.locale == 'es'
                              ? '¡Completaste todos los hitos!'
                              : 'You\'ve achieved all milestones!',
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: milestones.length,
                      itemBuilder: (context, index) {
                        final milestone = milestones[index];
                        final state = index == 0
                            ? MilestoneState.next
                            : MilestoneState.locked;
                        return _MilestoneCard(
                          milestone: milestone,
                          locale: widget.locale,
                          state: state,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget para mostrar una tarjeta individual de hito
class _MilestoneCard extends StatelessWidget {
  final HealthTimelineMilestone milestone;
  final String locale;
  final MilestoneState state;

  const _MilestoneCard({
    required this.milestone,
    required this.locale,
    required this.state,
  });

  String _formatMinutes(int minutes) {
    if (minutes == 0) {
      return locale == 'es' ? 'Continuo' : 'Continuous';
    }

    if (minutes < 60) {
      return '$minutes ${locale == 'es' ? 'min' : 'min'}';
    }

    final hours = minutes ~/ 60;
    if (hours < 24) {
      return '$hours ${locale == 'es' ? 'horas' : 'hours'}';
    }

    final days = hours ~/ 24;
    if (days < 365) {
      return '$days ${locale == 'es' ? 'días' : 'days'}';
    }

    final years = days ~/ 365;
    return '$years ${locale == 'es' ? 'año(s)' : 'year(s)'}';
  }

  String _getCategoryEmoji(String category) {
    const emojis = {
      'cardio': '❤️',
      'pulmon': '🫁',
      'cancer': '🛡️',
      'sentidos': '👃',
      'energia': '⚡',
      'general': '✨',
      'ambiente': '🌍',
    };
    return emojis[category] ?? '📍';
  }

  @override
  Widget build(BuildContext context) {
    final Color stateColor;
    final IconData stateIcon;

    switch (state) {
      case MilestoneState.done:
        stateColor = const Color(0xFFC8E6C9); // Verde suave
        stateIcon = Icons.check_circle;
        break;
      case MilestoneState.next:
        stateColor = Theme.of(context).colorScheme.primary; // Acento (teal)
        stateIcon = Icons.hourglass_bottom;
        break;
      default:
        stateColor = Colors.grey; // Gris
        stateIcon = Icons.lock;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con tiempo y estatus
            Row(
              children: [
                Text(
                  _getCategoryEmoji(milestone.category),
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        milestone.getTitle(locale),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: state == MilestoneState.locked
                              ? Colors.grey[600]
                              : Colors.black87,
                        ),
                      ),
                      Text(
                        _formatMinutes(milestone.afterMinutes),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  stateIcon,
                  color: stateColor,
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Descripción
            Text(
              milestone.getDescription(locale),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            // Fuente
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Aquí se podría abrir el URL en un navegador
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(milestone.sourceUrl),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                    child: Text(
                      milestone.sourceName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[600],
                        decoration: TextDecoration.underline,
                      ),
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
