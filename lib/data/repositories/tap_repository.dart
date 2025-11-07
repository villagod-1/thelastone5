import 'package:hive/hive.dart';
import '../models/tap_record.dart';
import '../models/cycle.dart';

abstract class TapRepository {
  Future<void> saveTap(TapRecord tap);
  Future<List<TapRecord>> getAllTaps();
  Future<void> clearAllTaps();
  Future<int> getTotalCount();
  Future<Cycle?> getCurrentCycle();
  Future<void> saveCurrentCycle(Cycle cycle);
  Future<List<TapRecord>> getTapsByCycle(int cycleId);
}

class TapRepositoryImpl implements TapRepository {
  static const String _tapsBoxName = 'taps_box';
  static const String _cyclesBoxName = 'cycles_box';
  static const String _currentCycleKey = 'current_cycle_id';

  @override
  Future<void> saveTap(TapRecord tap) async {
    final box = await Hive.openBox<TapRecord>(_tapsBoxName);
    await box.add(tap);
  }

  @override
  Future<List<TapRecord>> getAllTaps() async {
    final box = await Hive.openBox<TapRecord>(_tapsBoxName);
    return box.values.toList();
  }

  @override
  Future<void> clearAllTaps() async {
    final box = await Hive.openBox<TapRecord>(_tapsBoxName);
    await box.clear();
  }

  @override
  Future<int> getTotalCount() async {
    final box = await Hive.openBox<TapRecord>(_tapsBoxName);
    final currentCycle = await getCurrentCycle();
    
    if (currentCycle == null) return 0;
    
    return box.values
        .where((tap) => tap.cycleId == currentCycle.id)
        .length;
  }

  @override
  Future<Cycle?> getCurrentCycle() async {
    final box = await Hive.openBox<Cycle>(_cyclesBoxName);
    final currentCycleId = box.get(_currentCycleKey) as int?;
    
    if (currentCycleId == null) return null;
    
    return box.values.firstWhere(
      (cycle) => cycle.id == currentCycleId,
      orElse: () => box.values.first,
    );
  }

  @override
  Future<void> saveCurrentCycle(Cycle cycle) async {
    final box = await Hive.openBox<Cycle>(_cyclesBoxName);
    await box.put(cycle.id, cycle);
    await box.put(_currentCycleKey, cycle.id);
  }

  @override
  Future<List<TapRecord>> getTapsByCycle(int cycleId) async {
    final box = await Hive.openBox<TapRecord>(_tapsBoxName);
    return box.values
        .where((tap) => tap.cycleId == cycleId)
        .toList();
  }
}
