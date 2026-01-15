import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Defaults
  final DateTime _defaultLastSmokeAt = DateTime(2026, 1, 11, 19, 0);
  final double _defaultPackPrice = 5000;
  final double _defaultPacksPerDay = 1;

  Timer? _timer;
  DateTime _now = DateTime.now();

  // Estado (se carga desde Storage)
  DateTime? lastSmokeAt;
  double packPrice = 5000;
  double packsPerDay = 1;

  @override
  void initState() {
    super.initState();
    _loadFromStorage();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadFromStorage() async {
    final storedLast = await StorageService.loadLastSmoke();
    final storedPrice = await StorageService.loadPackPrice();
    final storedPacks = await StorageService.loadPacksPerDay();

    final last = storedLast ?? _defaultLastSmokeAt;
    final price = storedPrice ?? _defaultPackPrice;
    final packs = storedPacks ?? _defaultPacksPerDay;

    setState(() {
      lastSmokeAt = last;
      packPrice = price;
      packsPerDay = packs;
    });

    // Guardar defaults si era primera vez
    if (storedLast == null) await StorageService.saveLastSmoke(last);
    if (storedPrice == null) await StorageService.savePackPrice(price);
    if (storedPacks == null) await StorageService.savePacksPerDay(packs);
  }

  @override
  Widget build(BuildContext context) {
    if (lastSmokeAt == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final duration = _now.difference(lastSmokeAt!);

    final daysInt = duration.inDays;
    final hoursInt = duration.inHours % 24;
    final minsInt = duration.inMinutes % 60;

    final days = duration.inMinutes / 1440.0; // 1440 min por día
    final saved = packPrice * packsPerDay * days;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smoke'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final changed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
              if (changed == true) {
                await _loadFromStorage();
              }
            },
          ),
        ],
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
                    Text('Desde: ${_fmt(lastSmokeAt!)}'),
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
                      'Base: ${packPrice.toStringAsFixed(0)} ARS/atado × ${packsPerDay.toStringAsFixed(0)} atado/día',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _fmt(DateTime dt) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  static String _fmtMoney(double value) {
    final formatter = NumberFormat('#,##0', 'es_AR');
    return '\$${formatter.format(value.round())} ARS';
  }
}
