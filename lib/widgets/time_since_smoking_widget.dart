import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../styles.dart';

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

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Número grande + contexto pequeño
          Text(
            '${daysInt} ${daysInt == 1 ? 'día' : 'días'}',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tiempo sin fumar',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 8),

          // Línea corta con horas y minutos
          Text(
            '${hoursInt}h ${minsInt}m',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 6),

          // Fecha de referencia
          Text(
            'Desde: ${_fmt(widget.lastSmokeAt)}',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  static String _fmt(DateTime dt) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }
}
