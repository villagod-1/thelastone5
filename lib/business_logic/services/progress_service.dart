import '../../data/models/daily_tap_data.dart';
import '../../data/models/tap_record.dart';
import '../../data/repositories/tap_repository.dart';

class ProgressService {
  final TapRepository _repository;

  ProgressService(this._repository);

  Future<List<DailyTapData>> getDailyData(int days) async {
    try {
      final allTaps = await _repository.getAllTaps();
      final currentCycle = await _repository.getCurrentCycle();
      
      if (currentCycle == null) return [];

      // Filtrar toques del ciclo actual
      final cycleTaps = allTaps
          .where((tap) => tap.cycleId == currentCycle.id)
          .toList();

      // Agrupar por día
      final Map<DateTime, int> tapsByDay = {};
      
      for (var tap in cycleTaps) {
        final date = DateTime(
          tap.timestamp.year,
          tap.timestamp.month,
          tap.timestamp.day,
        );
        tapsByDay[date] = (tapsByDay[date] ?? 0) + 1;
      }

      // Crear lista de datos diarios para los últimos N días
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: days - 1));

      final List<DailyTapData> dailyData = [];
      
      for (int i = 0; i < days; i++) {
        final date = startDate.add(Duration(days: i));
        final count = tapsByDay[date] ?? 0;
        dailyData.add(DailyTapData(date: date, tapCount: count));
      }

      return dailyData;
    } catch (e) {
      throw Exception('Error al obtener datos diarios: $e');
    }
  }

  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final currentCycle = await _repository.getCurrentCycle();
      
      if (currentCycle == null) {
        return {
          'total': 0,
          'average': 0.0,
          'daysActive': 0,
        };
      }

      final cycleTaps = await _repository.getTapsByCycle(currentCycle.id);
      final totalTaps = cycleTaps.length;
      
      final daysActive = DateTime.now()
          .difference(currentCycle.startDate)
          .inDays + 1;
      
      final averagePerDay = daysActive > 0 
          ? totalTaps / daysActive 
          : 0.0;

      return {
        'total': totalTaps,
        'average': averagePerDay,
        'daysActive': daysActive,
      };
    } catch (e) {
      throw Exception('Error al calcular estadísticas: $e');
    }
  }

  Future<double> getTrend() async {
    try {
      final dailyData = await getDailyData(14); // Últimos 14 días
      
      if (dailyData.length < 2) return 0.0;

      // Calcular tendencia simple: comparar primera y segunda mitad
      final midPoint = dailyData.length ~/ 2;
      final firstHalf = dailyData.sublist(0, midPoint);
      final secondHalf = dailyData.sublist(midPoint);

      final firstAvg = firstHalf.isEmpty 
          ? 0.0 
          : firstHalf.map((d) => d.tapCount).reduce((a, b) => a + b) / firstHalf.length;
      
      final secondAvg = secondHalf.isEmpty 
          ? 0.0 
          : secondHalf.map((d) => d.tapCount).reduce((a, b) => a + b) / secondHalf.length;

      // Retornar porcentaje de cambio
      if (firstAvg == 0) return 0.0;
      
      return ((secondAvg - firstAvg) / firstAvg) * 100;
    } catch (e) {
      throw Exception('Error al calcular tendencia: $e');
    }
  }
}
