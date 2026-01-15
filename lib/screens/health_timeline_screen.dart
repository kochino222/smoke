import 'package:flutter/material.dart';
import '../widgets/health_timeline_widget.dart';

class HealthTimelineScreen extends StatelessWidget {
  final int daysElapsed;
  final String locale;

  const HealthTimelineScreen({
    required this.daysElapsed,
    this.locale = 'es',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          locale == 'es' ? 'Timeline de Salud' : 'Health Timeline',
        ),
      ),
      body: HealthTimelineWidget(
        daysElapsed: daysElapsed,
        locale: locale,
      ),
    );
  }
}
