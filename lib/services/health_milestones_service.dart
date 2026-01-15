import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/health_milestone.dart';

/// Servicio para cargar y gestionar los hitos de salud
class HealthMilestonesService {
  static const _assetsPath = 'assets/health_milestones_es.json';
  static List<HealthMilestone>? _cachedMilestones;

  /// Carga todos los hitos desde el archivo JSON
  static Future<List<HealthMilestone>> loadMilestones() async {
    if (_cachedMilestones != null) {
      return _cachedMilestones!;
    }

    try {
      final jsonString = await rootBundle.loadString(_assetsPath);
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final milestonesList = jsonData['milestones'] as List<dynamic>;

      _cachedMilestones = milestonesList
          .map((m) => HealthMilestone.fromJson(m as Map<String, dynamic>))
          .toList();

      // Ordenar por días requeridos
      _cachedMilestones!.sort((a, b) => a.daysRequired.compareTo(b.daysRequired));

      return _cachedMilestones!;
    } catch (e) {
      throw Exception('Error cargando hitos de salud: $e');
    }
  }

  /// Obtiene los hitos alcanzados basado en los días transcurridos
  static Future<List<HealthMilestone>> getAchievedMilestones(int days) async {
    final allMilestones = await loadMilestones();
    return allMilestones.where((m) => m.daysRequired <= days).toList();
  }

  /// Obtiene el próximo hito a alcanzar
  static Future<HealthMilestone?> getNextMilestone(int days) async {
    final allMilestones = await loadMilestones();
    try {
      return allMilestones.firstWhere((m) => m.daysRequired > days);
    } catch (e) {
      return null; // Todos los hitos han sido alcanzados
    }
  }

  /// Obtiene el progreso hacia el próximo hito (0.0 a 1.0)
  static Future<double> getProgressToNextMilestone(int days) async {
    final nextMilestone = await getNextMilestone(days);
    if (nextMilestone == null) return 1.0;

    final previousMilestones = await loadMilestones();
    final nextIndex = previousMilestones.indexOf(nextMilestone);
    
    int previousDays = 0;
    if (nextIndex > 0) {
      previousDays = previousMilestones[nextIndex - 1].daysRequired;
    }

    final daysInRange = nextMilestone.daysRequired - previousDays;
    final daysPassed = days - previousDays;

    return daysPassed / daysInRange;
  }
}
