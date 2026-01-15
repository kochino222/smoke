import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget independiente para mostrar el contador de tiempo sin fumar
/// Tiene su propio Timer para no afectar el scroll de la pantalla principal
class TimeSinceSmokingWidget extends StatefulWidget {
  final DateTime lastSmokeAt;

  const TimeSinceSmokingWidget({
    required this.lastSmokeAt,
    super.key,
  });

  @override
  State<TimeSinceSmokingWidget> createState() => _TimeSinceSmokingWidgetState();
}

class _TimeSinceSmokingWidgetState extends State<TimeSinceSmokingWidget> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duration = _now.difference(widget.lastSmokeAt);
    final daysInt = duration.inDays;
    final hoursInt = duration.inHours % 24;
    final minsInt = duration.inMinutes % 60;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tiempo sin fumar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$daysInt días, $hoursInt horas, $minsInt min',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text('Desde: ${_fmt(widget.lastSmokeAt)}'),
          ],
        ),
      ),
    );
  }

  static String _fmt(DateTime dt) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }
}
