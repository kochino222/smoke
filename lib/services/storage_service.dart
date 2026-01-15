import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _lastSmokeKey = 'lastSmokeAt';
  static const _packPriceKey = 'packPrice';
  static const _packsPerDayKey = 'packsPerDay';

  static Future<void> saveLastSmoke(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastSmokeKey, date.millisecondsSinceEpoch);
  }

  static Future<DateTime?> loadLastSmoke() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_lastSmokeKey);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  static Future<void> savePackPrice(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_packPriceKey, value);
  }

  static Future<double?> loadPackPrice() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_packPriceKey);
  }

  static Future<void> savePacksPerDay(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_packsPerDayKey, value);
  }

  static Future<double?> loadPacksPerDay() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_packsPerDayKey);
  }
}
