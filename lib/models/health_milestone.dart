/// Representa un hito de salud en el progreso de dejar de fumar
class HealthMilestone {
  final String id;
  final int afterMinutes;
  final String category;
  final String titleEs;
  final String titleEn;
  final String descriptionEs;
  final String descriptionEn;
  final String sourceName;
  final String sourceUrl;

  HealthMilestone({
    required this.id,
    required this.afterMinutes,
    required this.category,
    required this.titleEs,
    required this.titleEn,
    required this.descriptionEs,
    required this.descriptionEn,
    required this.sourceName,
    required this.sourceUrl,
  });

  /// Obtener título según idioma
  String getTitle(String locale) {
    return locale == 'es' ? titleEs : titleEn;
  }

  /// Obtener descripción según idioma
  String getDescription(String locale) {
    return locale == 'es' ? descriptionEs : descriptionEn;
  }

  /// Emoji por categoría
  String getCategoryEmoji() {
    switch (category) {
      case 'cardio':
        return '❤️';
      case 'pulmon':
        return '💨';
      case 'cancer':
        return '🛡️';
      case 'sentidos':
        return '👃';
      case 'energia':
        return '⚡';
      case 'ambiente':
        return '🌍';
      default:
        return '✨';
    }
  }

  /// Nombre de categoría legible
  String getCategoryName(String locale) {
    final names = {
      'cardio': locale == 'es' ? 'Corazón' : 'Heart',
      'pulmon': locale == 'es' ? 'Pulmones' : 'Lungs',
      'cancer': locale == 'es' ? 'Prevención' : 'Prevention',
      'sentidos': locale == 'es' ? 'Sentidos' : 'Senses',
      'energia': locale == 'es' ? 'Energía' : 'Energy',
      'ambiente': locale == 'es' ? 'Ambiente' : 'Environment',
      'general': locale == 'es' ? 'General' : 'General',
    };
    return names[category] ?? 'General';
  }

  /// Formatea tiempo transcurrido
  static String formatMinutes(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else if (minutes < 1440) {
      final hours = (minutes / 60).floor();
      return '$hours h';
    } else if (minutes < 525600) {
      final days = (minutes / 1440).floor();
      return '$days días';
    } else {
      final years = (minutes / 525600).floor();
      return '$years año${years > 1 ? 's' : ''}';
    }
  }

  /// Crea una instancia desde JSON
  factory HealthMilestone.fromJson(Map<String, dynamic> json) {
    return HealthMilestone(
      id: json['id'] as String,
      afterMinutes: json['afterMinutes'] as int,
      category: json['category'] as String? ?? 'general',
      titleEs: json['title_es'] as String,
      titleEn: json['title_en'] as String,
      descriptionEs: json['description_es'] as String,
      descriptionEn: json['description_en'] as String,
      sourceName: json['source_name'] as String? ?? 'Unknown',
      sourceUrl: json['source_url'] as String? ?? '',
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'afterMinutes': afterMinutes,
      'category': category,
      'title_es': titleEs,
      'title_en': titleEn,
      'description_es': descriptionEs,
      'description_en': descriptionEn,
      'source_name': sourceName,
      'source_url': sourceUrl,
    };
  }

  @override
  String toString() => 'HealthMilestone(id: $id, afterMinutes: $afterMinutes)';
}
