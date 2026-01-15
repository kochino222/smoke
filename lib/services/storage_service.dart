import 'package:shared_preferences/shared_preferences.dart';

/// Servicio de almacenamiento persistente usando SharedPreferences
class StorageService {
  static const _lastSmokeKey = 'lastSmokeAt';
  static const _packPriceKey = 'packPrice';
  static const _packsPerDayKey = 'packsPerDay';

  /// Guarda la fecha y hora del último cigarrillo
  static Future<void> saveLastSmoke(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastSmokeKey, date.millisecondsSinceEpoch);
    } catch (e) {
      throw Exception('Error al guardar último cigarrillo: $e');
    }
  }

  /// Carga la fecha y hora del último cigarrillo
  static Future<DateTime?> loadLastSmoke() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ms = prefs.getInt(_lastSmokeKey);
      if (ms == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(ms);
    } catch (e) {
      throw Exception('Error al cargar último cigarrillo: $e');
    }
  }

  /// Guarda el precio del atado
  static Future<void> savePackPrice(double value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_packPriceKey, value);
    } catch (e) {
      throw Exception('Error al guardar precio del atado: $e');
    }
  }

  /// Carga el precio del atado
  static Future<double?> loadPackPrice() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_packPriceKey);
    } catch (e) {
      throw Exception('Error al cargar precio del atado: $e');
    }
  }

  /// Guarda la cantidad de atados por día
  static Future<void> savePacksPerDay(double value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_packsPerDayKey, value);
    } catch (e) {
      throw Exception('Error al guardar atados por día: $e');
    }
  }

  /// Carga la cantidad de atados por día
  static Future<double?> loadPacksPerDay() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_packsPerDayKey);
    } catch (e) {
      throw Exception('Error al cargar atados por día: $e');
    }
  }
}
