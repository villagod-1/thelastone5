import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../data/models/tap_record.dart';
import '../../data/models/cycle.dart';
import '../../data/repositories/tap_repository.dart';

class TapCounterService {
  final TapRepository _repository;
  final _counterController = StreamController<int>.broadcast();
  final _uuid = const Uuid();
  
  DateTime? _lastTapTime;
  static const _debounceDuration = Duration(milliseconds: 500);

  TapCounterService(this._repository);

  Stream<int> watchCounter() => _counterController.stream;

  Future<void> registerTap() async {
    // Debouncing: evitar registros múltiples rápidos
    final now = DateTime.now();
    if (_lastTapTime != null && 
        now.difference(_lastTapTime!) < _debounceDuration) {
      return;
    }
    _lastTapTime = now;

    try {
      // Obtener o crear ciclo actual
      Cycle? currentCycle = await _repository.getCurrentCycle();
      
      if (currentCycle == null) {
        // Crear primer ciclo
        currentCycle = Cycle(
          id: 1,
          startDate: DateTime.now(),
          isActive: true,
        );
        await _repository.saveCurrentCycle(currentCycle);
      }

      // Crear y guardar el registro de toque
      final tapRecord = TapRecord(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        cycleId: currentCycle.id,
      );

      await _repository.saveTap(tapRecord);

      // Actualizar el contador
      final newCount = await getCurrentCount();
      _counterController.add(newCount);
    } catch (e) {
      throw Exception('Error al registrar toque: $e');
    }
  }

  Future<int> getCurrentCount() async {
    try {
      return await _repository.getTotalCount();
    } catch (e) {
      throw Exception('Error al obtener contador: $e');
    }
  }

  Future<void> resetCounter() async {
    try {
      final currentCycle = await _repository.getCurrentCycle();
      
      if (currentCycle != null) {
        // Cerrar ciclo actual
        final closedCycle = currentCycle.copyWith(
          endDate: DateTime.now(),
          isActive: false,
        );
        await _repository.saveCurrentCycle(closedCycle);

        // Crear nuevo ciclo
        final newCycle = Cycle(
          id: currentCycle.id + 1,
          startDate: DateTime.now(),
          isActive: true,
        );
        await _repository.saveCurrentCycle(newCycle);
      }

      // Actualizar el contador a 0
      _counterController.add(0);
    } catch (e) {
      throw Exception('Error al reiniciar contador: $e');
    }
  }

  void dispose() {
    _counterController.close();
  }
}
