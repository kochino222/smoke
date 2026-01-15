/// Representa un hito de salud en el progreso de dejar de fumar
class HealthMilestone {
  final int id;
  final int daysRequired;
  final String title;
  final String description;
  final String icon;

  HealthMilestone({
    required this.id,
    required this.daysRequired,
    required this.title,
    required this.description,
    required this.icon,
  });

  /// Crea una instancia desde JSON
  factory HealthMilestone.fromJson(Map<String, dynamic> json) {
    return HealthMilestone(
      id: json['id'] as int,
      daysRequired: json['daysRequired'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'daysRequired': daysRequired,
      'title': title,
      'description': description,
      'icon': icon,
    };
  }

  @override
  String toString() => 'HealthMilestone($id: $title)';
}
