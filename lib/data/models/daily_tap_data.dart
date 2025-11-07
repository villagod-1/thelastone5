class DailyTapData {
  final DateTime date;
  final int tapCount;

  DailyTapData({
    required this.date,
    required this.tapCount,
  });

  @override
  String toString() {
    return 'DailyTapData(date: $date, tapCount: $tapCount)';
  }
}
