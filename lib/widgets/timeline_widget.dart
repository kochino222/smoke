import 'package:flutter/material.dart';
import '../models/health_milestone.dart';
import '../services/health_milestones_service.dart';
import 'source_bottom_sheet.dart';

class TimelineWidget extends StatefulWidget {
  final int minutesElapsed;
  final String locale;
  final HealthMilestonesService service;

  const TimelineWidget({
    Key? key,
    required this.minutesElapsed,
    required this.locale,
    required this.service,
  }) : super(key: key);

  @override
  State<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showSourceModal(HealthMilestone milestone) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SourceBottomSheet(
        milestone: milestone,
        locale: widget.locale,
      ),
    );
  }

  Widget _buildMilestoneCard(HealthMilestone milestone, bool isAchieved) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isAchieved ? Colors.green.withOpacity(0.3) : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Row(
              children: [
                // Icono de status
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isAchieved
                        ? Colors.green.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      isAchieved ? '✓' : milestone.getCategoryEmoji(),
                      style: TextStyle(
                        fontSize: isAchieved ? 20 : 18,
                        color: isAchieved ? Colors.green : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        milestone.getTitle(widget.locale),
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isAchieved
                                      ? Colors.green[700]
                                      : Colors.black87,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        HealthMilestone.formatMinutes(milestone.afterMinutes),
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                      ),
                    ],
                  ),
                ),
                // Icono de estatus
                if (isAchieved)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  )
                else
                  const Icon(
                    Icons.circle_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Descripción
            Text(
              milestone.getDescription(widget.locale),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),

            // Botón de fuente
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showSourceModal(milestone),
                icon: const Icon(Icons.info_outline, size: 16),
                label: Text(
                  widget.locale == 'es' ? 'Ver fuente' : 'View source',
                  style: const TextStyle(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final achieved =
        widget.service.getAchievedMilestones(widget.minutesElapsed);
    final upcoming =
        widget.service.getUpcomingMilestones(widget.minutesElapsed);
    final all = widget.service.getAllMilestones();

    return Column(
      children: [
        // TabBar
        TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle),
                  const SizedBox(width: 6),
                  Text(
                    widget.locale == 'es' ? 'Alcanzados' : 'Achieved',
                  ),
                  const SizedBox(width: 6),
                  Badge(
                    label: Text('${achieved.length}'),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.schedule),
                  const SizedBox(width: 6),
                  Text(
                    widget.locale == 'es' ? 'Próximos' : 'Upcoming',
                  ),
                  const SizedBox(width: 6),
                  Badge(
                    label: Text('${upcoming.length}'),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.list),
                  const SizedBox(width: 6),
                  Text(
                    widget.locale == 'es' ? 'Todos' : 'All',
                  ),
                  const SizedBox(width: 6),
                  Badge(
                    label: Text('${all.length}'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // TabBarView
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Alcanzados
              achieved.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sentiment_dissatisfied,
                                size: 48, color: Colors.grey[300]),
                            const SizedBox(height: 12),
                            Text(
                              widget.locale == 'es'
                                  ? 'Aún no hay hitos alcanzados'
                                  : 'No milestones achieved yet',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: achieved.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) =>
                          _buildMilestoneCard(achieved[i], true),
                    ),

              // Tab 2: Próximos
              upcoming.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.celebration,
                                size: 48, color: Colors.green),
                            const SizedBox(height: 12),
                            Text(
                              widget.locale == 'es'
                                  ? '¡Todos los hitos alcanzados!'
                                  : 'All milestones achieved!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[700]),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: upcoming.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) =>
                          _buildMilestoneCard(upcoming[i], false),
                    ),

              // Tab 3: Todos
              ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: all.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final milestone = all[i];
                  final isAchieved =
                      milestone.afterMinutes <= widget.minutesElapsed;
                  return _buildMilestoneCard(milestone, isAchieved);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
