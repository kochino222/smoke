import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/health_milestone.dart';

/// Servicio para cargar y gestionar los hitos de salud bilingual
class HealthMilestonesService {
  static final HealthMilestonesService _instance =
      HealthMilestonesService._internal();
  late List<HealthMilestone> _milestones = [];
  bool _isInitialized = false;

  factory HealthMilestonesService() {
    return _instance;
  }

  HealthMilestonesService._internal();

  /// Carga los hitos desde el archivo JSON
  Future<void> loadMilestones() async {
    if (_isInitialized) return;

    try {
      final jsonString = await rootBundle.loadString(
        'assets/health_milestones.json',
      );
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final milestonesList = jsonData['milestones'] as List<dynamic>? ?? [];

      _milestones = milestonesList
          .map((e) => HealthMilestone.fromJson(e as Map<String, dynamic>))
          .toList();

      // Ordenar por tiempo
      _milestones.sort((a, b) => a.afterMinutes.compareTo(b.afterMinutes));

      _isInitialized = true;
    } catch (e) {
      print('Error loading milestones: $e');
      _milestones = [];
      _isInitialized = true;
    }
  }

  /// Obtiene todos los hitos cargados
  List<HealthMilestone> getAllMilestones() {
    return List.unmodifiable(_milestones);
  }

  /// Obtiene hitos ya alcanzados
  List<HealthMilestone> getAchievedMilestones(int minutesElapsed) {
    return _milestones
        .where((m) => m.afterMinutes <= minutesElapsed)
        .toList();
  }

  /// Obtiene hitos futuros
  List<HealthMilestone> getUpcomingMilestones(int minutesElapsed) {
    return _milestones
        .where((m) => m.afterMinutes > minutesElapsed)
        .toList();
  }

  /// Obtiene el próximo hito
  HealthMilestone? getNextMilestone(int minutesElapsed) {
    final upcoming = getUpcomingMilestones(minutesElapsed);
    return upcoming.isNotEmpty ? upcoming.first : null;
  }

  /// Obtiene el progreso hacia el próximo hito (0.0 - 1.0)
  double getProgressToNextMilestone(int minutesElapsed) {
    final next = getNextMilestone(minutesElapsed);
    if (next == null) return 1.0;

    final previous = _milestones
        .where((m) => m.afterMinutes < next.afterMinutes)
        .lastOrNull
        ?.afterMinutes;

    final prevTime = previous ?? 0;
    final nextTime = next.afterMinutes;
    final elapsed = minutesElapsed - prevTime;
    final total = nextTime - prevTime;

    if (total <= 0) return 0.0;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  /// Obtiene hitos por categoría
  List<HealthMilestone> getMilestonesByCategory(String category) {
    return _milestones.where((m) => m.category == category).toList();
  }

  /// Obtiene categorías únicas
  Set<String> getCategories() {
    return _milestones.map((m) => m.category).toSet();
  }

  /// Obtiene conteo de hitos por categoría
  Map<String, int> getCategoryCount() {
    final counts = <String, int>{};
    for (final milestone in _milestones) {
      counts[milestone.category] =
          (counts[milestone.category] ?? 0) + 1;
    }
    return counts;
  }

  /// Busca un hito por ID
  HealthMilestone? getMilestoneById(String id) {
    try {
      return _milestones.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Formatea tiempo hasta próximo hito
  String getTimeUntilNext(int minutesElapsed) {
    final next = getNextMilestone(minutesElapsed);
    if (next == null) return 'Completado';

    final remaining = next.afterMinutes - minutesElapsed;
    return HealthMilestone.formatMinutes(remaining);
  }
}
