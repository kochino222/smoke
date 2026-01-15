import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';
import '../services/health_milestones_service.dart';
import '../widgets/health_benefits_card.dart';
import '../widgets/milestones_list_widget.dart';
import '../widgets/savings_breakdown_card.dart';
import '../widgets/time_since_smoking_widget.dart';
import '../widgets/next_milestone_card.dart';
import '../widgets/timeline_widget.dart';
import 'settings_screen.dart';
import 'health_timeline_screen.dart';

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

  // Estado (se carga desde Storage)
  DateTime? lastSmokeAt;
  double packPrice = 5000;
  double packsPerDay = 1;
  String appLanguage = 'es'; // Variable para idioma

  // Servicio de hitos
  final HealthMilestonesService _milestonesService = HealthMilestonesService();

  @override
  void initState() {
    super.initState();
    _loadFromStorage();
    _milestonesService.loadMilestones(); // Cargar hitos
  }

  @override
  void dispose() {
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

  void _toggleLanguage() {
    setState(() {
      appLanguage = appLanguage == 'es' ? 'en' : 'es';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (lastSmokeAt == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Calcular minutos y días transcurridos
    final minutesElapsed = DateTime.now().difference(lastSmokeAt!).inMinutes;
    final daysElapsed = DateTime.now().difference(lastSmokeAt!).inDays;
    final days = minutesElapsed / 1440.0;
    final saved = packPrice * packsPerDay * days;

    return DefaultTabController(
      length: 2, // Dos tabs: Dashboard y Timeline
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Smoke'),
          bottom: TabBar(
            tabs: [
              Tab(text: appLanguage == 'es' ? 'Dashboard' : 'Dashboard'),
              Tab(text: appLanguage == 'es' ? 'Timeline' : 'Timeline'),
            ],
          ),
          actions: [
            // Botón para cambiar idioma
            IconButton(
              icon: Text(
                appLanguage == 'es' ? '🇪🇸' : '🇬🇧',
                style: const TextStyle(fontSize: 18),
              ),
              tooltip: appLanguage == 'es' ? 'English' : 'Español',
              onPressed: _toggleLanguage,
            ),
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
        body: TabBarView(
          children: [
            // Tab 1: Dashboard
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tiempo sin fumar (widget independiente con su propio timer)
                  TimeSinceSmokingWidget(lastSmokeAt: lastSmokeAt!),
                  const SizedBox(height: 12),

                  // Ahorro estimado total
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appLanguage == 'es'
                                ? 'Ahorro acumulado'
                                : 'Total savings',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _fmtMoney(saved),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            appLanguage == 'es'
                                ? 'Base: ${packPrice.toStringAsFixed(0)} ARS/atado × ${packsPerDay.toStringAsFixed(0)} atado/día'
                                : 'Base: ${packPrice.toStringAsFixed(0)} ARS/pack × ${packsPerDay.toStringAsFixed(0)} pack/day',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Desglose de ahorros
                  SavingsBreakdownCard(
                    packPrice: packPrice,
                    packsPerDay: packsPerDay,
                    daysElapsed: daysElapsed,
                    lastSmokeAt: lastSmokeAt!,
                  ),
                  const SizedBox(height: 12),

                  // Próximo hito
                  NextMilestoneCard(
                    minutesElapsed: minutesElapsed,
                    locale: appLanguage,
                    service: _milestonesService,
                  ),
                  const SizedBox(height: 12),

                  // Beneficios de salud (legacy)
                  HealthBenefitsCard(daysElapsed: daysElapsed),
                  const SizedBox(height: 12),

                  // Logros desbloqueados (legacy)
                  MilestonesListWidget(daysElapsed: daysElapsed),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Tab 2: Timeline profesional
            FutureBuilder<void>(
              future: _milestonesService.loadMilestones().then((_) {}),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      appLanguage == 'es'
                          ? 'Error cargando timeline'
                          : 'Error loading timeline',
                    ),
                  );
                }

                return TimelineWidget(
                  minutesElapsed: minutesElapsed,
                  locale: appLanguage,
                  service: _milestonesService,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static String _fmtMoney(double value) {
    final formatter = NumberFormat('#,##0', 'es_AR');
    return '\$${formatter.format(value.round())} ARS';
  }
}
