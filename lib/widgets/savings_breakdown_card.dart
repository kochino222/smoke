import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SavingsBreakdownCard extends StatelessWidget {
  final double packPrice;
  final double packsPerDay;
  final int daysElapsed;
  final DateTime lastSmokeAt;

  const SavingsBreakdownCard({
    required this.packPrice,
    required this.packsPerDay,
    required this.daysElapsed,
    required this.lastSmokeAt,
    super.key,
  });

  String _formatMoney(double value) {
    final formatter = NumberFormat('#,##0', 'es_AR');
    return '\$${formatter.format(value.round())} ARS';
  }

  double _calculateSavingsToday() {
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);

    if (lastSmokeAt.isAfter(todayMidnight)) {
      // Último cigarrillo fue hoy
      final hours = now.difference(lastSmokeAt).inMinutes / 60.0;
      final packs = (hours / 24.0) * packsPerDay;
      return packPrice * packs;
    }

    // Último cigarrillo fue antes de hoy (día completo ahorrado)
    return packPrice * packsPerDay;
  }

  double _calculateSavingsThisMonth() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    if (lastSmokeAt.isBefore(firstDayOfMonth)) {
      // Todo el mes sin fumar
      return packPrice * packsPerDay * now.day;
    }

    // Quitting durante este mes
    final daysSinceQuitting = now.difference(lastSmokeAt).inDays + 1;
    return packPrice * packsPerDay * daysSinceQuitting;
  }

  double _calculateSavingsThisYear() {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year, 1, 1);

    if (lastSmokeAt.isBefore(firstDayOfYear)) {
      // Todo el año sin fumar
      final daysSoFar = now.difference(firstDayOfYear).inDays + 1;
      return packPrice * packsPerDay * daysSoFar;
    }

    // Quitting durante este año
    final daysSinceQuitting = now.difference(lastSmokeAt).inDays + 1;
    return packPrice * packsPerDay * daysSinceQuitting;
  }

  @override
  Widget build(BuildContext context) {
    final savingsToday = _calculateSavingsToday();
    final savingsMonth = _calculateSavingsThisMonth();
    final savingsYear = _calculateSavingsThisYear();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Economía',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hoy',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatMoney(savingsToday),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Este mes',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatMoney(savingsMonth),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Este año',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatMoney(savingsYear),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
