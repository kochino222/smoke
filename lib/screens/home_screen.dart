import 'dart:async';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Datos (por ahora fijos; después los hacemos configurables)
  final DateTime _defaultLastSmokeAt = DateTime(2026, 1, 11, 19, 0);
  final double _defaultPackPrice = 5000;
  final double _defaultPacksPerDay = 1;

  Timer? _timer;
  DateTime _now = DateTime.now();

  // Estado
  late DateTime lastSmokeAt;
  late double packPrice;
  late double packsPerDay;

  @override
  void initState() {
    super.initState();

    // Inicializamos con defaults (después lo conectamos a SharedPreferences)
    lastSmokeAt = _defaultLastSmokeAt;
    packPrice = _defaultPackPrice;
    packsPerDay = _defaultPacksPerDay;

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
    final duration = _now.difference(lastSmokeAt);

    final totalMinutes = duration.inMinutes;
    final days = totalMinutes / 1440.0; // 1440 min por día
    final saved = packPrice * packsPerDay * days;

    final daysInt = duration.inDays;
    final hoursInt = duration.inHours % 24;
    final minsInt = duration.inMinutes % 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smoke'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tiempo sin fumar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$daysInt días, $hoursInt horas, $minsInt min',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Desde: ${_fmt(lastSmokeAt)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ahorro estimado',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _fmtMoney(saved),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Base: ${packPrice.toStringAsFixed(0)} ARS por atado × ${packsPerDay.toStringAsFixed(0)} atado/día',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Próximo paso: agregar timeline de beneficios de salud + objetivos de ahorro 🎯',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _fmt(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
  }

  static String _fmtMoney(double value) {
    final rounded = value.round();
    final s = rounded.toString();
    final formatted = s.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return '\$$formatted ARS';
  }
}
