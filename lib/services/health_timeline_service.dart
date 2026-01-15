import 'dart:convert';
import 'package:flutter/services.dart';

/// Modelo para representar un hito de salud en la timeline
class HealthTimelineMilestone {
  final String id;
  final int afterMinutes;
  final String titleEs;
  final String titleEn;
  final String descriptionEs;
  final String descriptionEn;
  final String category;
  final String sourceName;
  final String sourceUrl;

  HealthTimelineMilestone({
    required this.id,
    required this.afterMinutes,
    required this.titleEs,
    required this.titleEn,
    required this.descriptionEs,
    required this.descriptionEn,
    required this.category,
    required this.sourceName,
    required this.sourceUrl,
  });

  /// Crea una instancia desde JSON
  factory HealthTimelineMilestone.fromJson(Map<String, dynamic> json) {
    return HealthTimelineMilestone(
      id: json['id'] as String,
      afterMinutes: json['afterMinutes'] as int,
      titleEs: json['title_es'] as String,
      titleEn: json['title_en'] as String,
      descriptionEs: json['description_es'] as String,
      descriptionEn: json['description_en'] as String,
      category: json['category'] as String,
      sourceName: json['source_name'] as String,
      sourceUrl: json['source_url'] as String,
    );
  }

  /// Obtiene el título en el idioma especificado
  String getTitle(String locale) {
    return locale == 'es' ? titleEs : titleEn;
  }

  /// Obtiene la descripción en el idioma especificado
  String getDescription(String locale) {
    return locale == 'es' ? descriptionEs : descriptionEn;
  }

  @override
  String toString() => 'HealthTimelineMilestone($id)';
}

/// Servicio para cargar y gestionar la timeline de salud
class HealthTimelineService {
  static const _assetsPath = 'assets/health_timeline_es_en.json';
  static List<HealthTimelineMilestone>? _cachedMilestones;

  /// Carga todos los hitos de la timeline
  static Future<List<HealthTimelineMilestone>> loadTimeline() async {
    if (_cachedMilestones != null) {
      return _cachedMilestones!;
    }

    try {
      final jsonString = await rootBundle.loadString(_assetsPath);
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final milestonesList = jsonData['milestones'] as List<dynamic>;

      _cachedMilestones = milestonesList
          .map((m) => HealthTimelineMilestone.fromJson(m as Map<String, dynamic>))
          .toList();

      // Ordenar por minutos (hitos continuos al principio)
      _cachedMilestones!.sort((a, b) => a.afterMinutes.compareTo(b.afterMinutes));

      return _cachedMilestones!;
    } catch (e) {
      throw Exception('Error cargando timeline de salud: $e');
    }
  }

  /// Obtiene los hitos ya alcanzados basado en minutos transcurridos
  static Future<List<HealthTimelineMilestone>> getAchievedMilestones(
    int minutes,
  ) async {
    final allMilestones = await loadTimeline();
    return allMilestones.where((m) => m.afterMinutes <= minutes).toList();
  }

  /// Obtiene los hitos no alcanzados aún
  static Future<List<HealthTimelineMilestone>> getUpcomingMilestones(
    int minutes,
  ) async {
    final allMilestones = await loadTimeline();
    return allMilestones.where((m) => m.afterMinutes > minutes).toList();
  }

  /// Obtiene los hitos por categoría
  static Future<List<HealthTimelineMilestone>> getMilestonesByCategory(
    String category,
  ) async {
    final allMilestones = await loadTimeline();
    return allMilestones.where((m) => m.category == category).toList();
  }

  /// Obtiene las categorías únicas
  static Future<Set<String>> getCategories() async {
    final allMilestones = await loadTimeline();
    return allMilestones.map((m) => m.category).toSet();
  }

  /// Obtiene hitos para un rango de minutos específico
  static Future<List<HealthTimelineMilestone>> getMilestonesInRange(
    int fromMinutes,
    int toMinutes,
  ) async {
    final allMilestones = await loadTimeline();
    return allMilestones
        .where((m) => m.afterMinutes >= fromMinutes && m.afterMinutes <= toMinutes)
        .toList();
  }
}
