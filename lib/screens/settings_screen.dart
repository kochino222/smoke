import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _priceCtrl = TextEditingController();
  final _packsCtrl = TextEditingController();

  DateTime? _lastSmokeAt;
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _packsCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final last = await StorageService.loadLastSmoke();
      final price = await StorageService.loadPackPrice();
      final packs = await StorageService.loadPacksPerDay();

      setState(() {
        _lastSmokeAt = last ?? DateTime(2026, 1, 11, 19, 0);
        _priceCtrl.text = (price ?? 5000).toStringAsFixed(0);
        _packsCtrl.text = (packs ?? 1).toStringAsFixed(0);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'No pude cargar la configuración: $e';
        _loading = false;
      });
    }
  }

  Future<void> _pickDateTime() async {
    if (!mounted) return;
    
    final current = _lastSmokeAt ?? DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (date == null) return;

    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (time == null) return;

    setState(() {
      _lastSmokeAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  double _parseNum(String s, double fallback) {
    final cleaned = s.trim().replaceAll(',', '.');
    return double.tryParse(cleaned) ?? fallback;
  }

  Future<void> _save() async {
    setState(() {
      _error = null;
      _saving = true;
    });

    // Validar que los campos no estén vacíos
    if (_priceCtrl.text.trim().isEmpty) {
      setState(() {
        _error = 'El precio del atado no puede estar vacío.';
        _saving = false;
      });
      return;
    }
    if (_packsCtrl.text.trim().isEmpty) {
      setState(() {
        _error = 'Atados por día no puede estar vacío.';
        _saving = false;
      });
      return;
    }

    final last = _lastSmokeAt ?? DateTime(2026, 1, 11, 19, 0);
    final price = _parseNum(_priceCtrl.text, -1);
    final packs = _parseNum(_packsCtrl.text, -1);

    // Validar rangos
    if (price <= 0) {
      setState(() {
        _error = 'El precio del atado debe ser mayor a 0.';
        _saving = false;
      });
      return;
    }
    if (packs <= 0) {
      setState(() {
        _error = 'Atados por día debe ser mayor a 0.';
        _saving = false;
      });
      return;
    }
    if (price > 1000000) {
      setState(() {
        _error = 'El precio del atado parece muy alto.';
        _saving = false;
      });
      return;
    }
    if (packs > 100) {
      setState(() {
        _error = 'Atados por día parece muy alto.';
        _saving = false;
      });
      return;
    }

    try {
      await StorageService.saveLastSmoke(last);
      await StorageService.savePackPrice(price);
      await StorageService.savePacksPerDay(packs);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Configuración guardada correctamente'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context, true); // true = hubo cambios
    } catch (e) {
      setState(() => _error = 'No pude guardar los datos: $e');
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null && _lastSmokeAt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Configuración')),
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Último cigarrillo', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _pickDateTime,
              child: Text(_fmt(_lastSmokeAt!)),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio del atado (ARS)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _packsCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Atados por día',
                border: OutlineInputBorder(),
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            const Spacer(),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }

  static String _fmt(DateTime dt) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }
}
